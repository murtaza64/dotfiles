let tabSearchOverlay = null;
let allTabs = [];
let allHistory = [];
let fuse = null;
let searchMode = 'tabs'; // 'tabs' or 'history'
const defaultFavicon = 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"><rect width="16" height="16" fill="%23ddd"/></svg>';

function formatTimeAgo(timestamp) {
    const now = Date.now();
    const diff = now - timestamp;
    const seconds = Math.floor(diff / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);
    
    if (seconds < 60) return 'Just now';
    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    if (days < 7) return `${days}d ago`;
    
    const date = new Date(timestamp);
    return date.toLocaleDateString();
}

function highlightMatches(text, matches) {
    if (!matches || matches.length === 0) return text;
    
    let result = text;
    const offsets = [];
    
    matches.forEach(match => {
        match.indices.forEach(([start, end]) => {
            offsets.push({ start, end: end + 1 });
        });
    });
    
    // Sort by start position descending to avoid offset issues
    offsets.sort((a, b) => b.start - a.start);
    
    offsets.forEach(({ start, end }) => {
        const before = result.substring(0, start);
        const match = result.substring(start, end);
        const after = result.substring(end);
        result = before + '<mark class="highlight">' + match + '</mark>' + after;
    });
    
    return result;
}

function createTabSearchOverlay() {
    const overlay = document.createElement('div');
    overlay.id = 'tab-search-overlay';
    overlay.innerHTML = `
        <div class="tab-search-popup">
            <div class="search-header">
                <input type="text" id="tab-search-input" placeholder="Search tabs..." autofocus>
                <div class="mode-indicator" id="mode-indicator">TABS</div>
            </div>
            <div id="tab-search-list"></div>
        </div>
    `;
    
    document.body.appendChild(overlay);
    return overlay;
}

function search() {
    const searchInput = document.getElementById('tab-search-input');
    const tabList = document.getElementById('tab-search-list');
    const query = searchInput.value.trim();
    
    tabList.innerHTML = '';
    
    let itemsWithMatches;
    const currentData = searchMode === 'tabs' ? allTabs : allHistory;
    
    if (!query) {
        itemsWithMatches = currentData.map(item => ({ item, matches: [] }));
    } else {
        const fuseResults = fuse.search(query);
        itemsWithMatches = fuseResults.map(result => ({
            item: result.item,
            matches: result.matches || []
        }));
    }
    
    itemsWithMatches.forEach(({ item, matches }) => {
        const titleMatches = matches.filter(m => m.key === 'title');
        const urlMatches = matches.filter(m => m.key === 'url');
        
        const itemElement = document.createElement('div');
        itemElement.className = 'tab-item';
        
        if (searchMode === 'tabs') {
            itemElement.innerHTML = `
                ${item.favIconUrl 
                    ? `<img src="${item.favIconUrl}" alt="" class="favicon">` 
                    : `<svg class="favicon" width="16" height="16"><rect width="16" height="16" fill="#8c8c8c"/></svg>`
                }
                <div class="tab-info">
                    <div class="tab-title">${highlightMatches(item.title, titleMatches)}</div>
                    <div class="tab-url">${highlightMatches(item.url, urlMatches)}</div>
                </div>
            `;
            
            itemElement.addEventListener('click', () => {
                chrome.runtime.sendMessage({
                    action: 'switchToTab',
                    tabId: item.id,
                    windowId: item.windowId
                });
                hideTabSearch();
            });
        } else {
            // History mode
            const favicon = `https://www.google.com/s2/favicons?domain=${new URL(item.url).hostname}&sz=16`;
            itemElement.innerHTML = `
                <img src="${favicon}" alt="" class="favicon" onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-block';">
                <svg class="favicon" width="16" height="16" style="display:none;"><rect width="16" height="16" fill="#8c8c8c"/></svg>
                <div class="tab-info">
                    <div class="tab-title">${highlightMatches(item.title || 'Untitled', titleMatches)}</div>
                    <div class="tab-url">${highlightMatches(item.url, urlMatches)}</div>
                </div>
                <div class="timestamp">${formatTimeAgo(item.lastVisitTime)}</div>
            `;
            
            itemElement.addEventListener('click', () => {
                chrome.runtime.sendMessage({
                    action: 'openHistory',
                    url: item.url
                });
                hideTabSearch();
            });
        }
        
        tabList.appendChild(itemElement);
    });
}

function switchMode() {
    searchMode = searchMode === 'tabs' ? 'history' : 'tabs';
    const modeIndicator = document.getElementById('mode-indicator');
    const searchInput = document.getElementById('tab-search-input');
    
    if (searchMode === 'tabs') {
        modeIndicator.textContent = 'TABS';
        searchInput.placeholder = 'Search tabs...';
        fuse = new Fuse(allTabs, {
            keys: ['title', 'url'],
            threshold: 0.4,
            includeScore: true,
            includeMatches: true
        });
    } else {
        modeIndicator.textContent = 'HISTORY';
        searchInput.placeholder = 'Search history...';
        fuse = new Fuse(allHistory, {
            keys: ['title', 'url'],
            threshold: 0.4,
            includeScore: true,
            includeMatches: true,
            sortFn: (a, b) => {
                // If scores are very similar (within 0.01), use recency as tiebreaker
                const scoreDiff = a.score - b.score;
                if (Math.abs(scoreDiff) < 0.01) {
                    return (b.item.lastVisitTime || 0) - (a.item.lastVisitTime || 0);
                }
                return scoreDiff;
            }
        });
    }
    
    searchInput.value = '';
    search();
}

function showTabSearch() {
    if (tabSearchOverlay) return;
    
    tabSearchOverlay = createTabSearchOverlay();
    
    // Load both tabs and history
    Promise.all([
        new Promise(resolve => chrome.runtime.sendMessage({action: 'getTabs'}, resolve)),
        new Promise(resolve => chrome.runtime.sendMessage({action: 'getHistory'}, resolve))
    ]).then(([tabsResponse, historyResponse]) => {
        allTabs = tabsResponse.tabs.sort((a, b) => (b.lastAccessed || 0) - (a.lastAccessed || 0));
        allHistory = historyResponse.history.sort((a, b) => (b.lastVisitTime || 0) - (a.lastVisitTime || 0));
        
        // Initialize with tabs mode
        searchMode = 'tabs';
        fuse = new Fuse(allTabs, {
            keys: ['title', 'url'],
            threshold: 0.4,
            includeScore: true,
            includeMatches: true
        });
        
        search();
    });
    
    const searchInput = document.getElementById('tab-search-input');
    searchInput.addEventListener('input', search);
    
    searchInput.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            hideTabSearch();
            return;
        }
        
        if (e.key === 'Tab') {
            e.preventDefault();
            switchMode();
            return;
        }
        
        const tabItems = document.querySelectorAll('.tab-item');
        let currentSelection = document.querySelector('.tab-item.selected');
        let currentIndex = Array.from(tabItems).indexOf(currentSelection);
        
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            if (currentSelection) currentSelection.classList.remove('selected');
            currentIndex = (currentIndex + 1) % tabItems.length;
            if (tabItems[currentIndex]) {
                tabItems[currentIndex].classList.add('selected');
                tabItems[currentIndex].scrollIntoView({ block: 'nearest' });
            }
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            if (currentSelection) currentSelection.classList.remove('selected');
            currentIndex = currentIndex <= 0 ? tabItems.length - 1 : currentIndex - 1;
            if (tabItems[currentIndex]) {
                tabItems[currentIndex].classList.add('selected');
                tabItems[currentIndex].scrollIntoView({ block: 'nearest' });
            }
        } else if (e.key === 'Enter') {
            e.preventDefault();
            if (currentSelection) {
                currentSelection.click();
            } else if (tabItems[0]) {
                tabItems[0].click();
            }
        }
        
        if (!currentSelection && tabItems.length > 0 && (e.key === 'ArrowDown' || e.key === 'ArrowUp')) {
            tabItems[0].classList.add('selected');
        }
    });
    
    tabSearchOverlay.addEventListener('click', (e) => {
        if (e.target === tabSearchOverlay) {
            hideTabSearch();
        }
    });
    
    setTimeout(() => {
        searchInput.focus();
    }, 0);
}

function hideTabSearch() {
    if (tabSearchOverlay) {
        tabSearchOverlay.remove();
        tabSearchOverlay = null;
    }
}

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === 'toggleTabSearch') {
        if (tabSearchOverlay) {
            hideTabSearch();
        } else {
            showTabSearch();
        }
    }
});

// Fallback keyboard listener
document.addEventListener('keydown', (e) => {
    if (e.altKey && e.code === 'Space') {
        e.preventDefault();
        if (tabSearchOverlay) {
            hideTabSearch();
        } else {
            showTabSearch();
        }
    }
});