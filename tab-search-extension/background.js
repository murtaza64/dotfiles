chrome.commands.onCommand.addListener((command) => {
    if (command === 'open-tab-search') {
        chrome.tabs.query({active: true, currentWindow: true}, (tabs) => {
            chrome.tabs.sendMessage(tabs[0].id, {action: 'toggleTabSearch'});
        });
    }
});

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === 'getTabs') {
        chrome.tabs.query({}, (tabs) => {
            sendResponse({tabs: tabs});
        });
        return true;
    }
    
    if (request.action === 'getHistory') {
        chrome.history.search({
            text: '',
            maxResults: 200,
            startTime: Date.now() - (7 * 24 * 60 * 60 * 1000) // Last 7 days
        }, (historyItems) => {
            sendResponse({history: historyItems});
        });
        return true;
    }
    
    if (request.action === 'switchToTab') {
        chrome.tabs.update(request.tabId, {active: true});
        chrome.windows.update(request.windowId, {focused: true});
    }
    
    if (request.action === 'openHistory') {
        chrome.tabs.create({url: request.url, active: true});
    }
});