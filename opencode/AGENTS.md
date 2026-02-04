# Agent Rules

## Communication Style

**Core Principle: Conciseness Above All**

Verbosity is the number one enemy. Every word must justify its existence.

### General Tone
- Be concise and factual
- Avoid emojis (✅ ❌ 🚀 📚 🎉 etc.) unless explicitly requested
- No marketing language, superlatives, or sales pitches
- No explanations of benefits or advantages
- Focus on WHAT, not WHY

### Generated Documents
When creating READMEs, guides, documentation, or any written content:

- **Ruthlessly eliminate verbosity** - no fluff, filler, or redundancy
- **Every sentence must add value** - remove obvious statements
- **No introductory paragraphs** - start with substance immediately
- **No "overview" or "introduction" sections** - get to the point
- **No repetition** - say it once, clearly
- **Prefer lists over prose** - easier to scan
- **Cut adjectives and adverbs** - "fast" not "incredibly fast"

**Example - Bad (verbose):**
```markdown
# Introduction to the Memory System

This comprehensive guide will walk you through the powerful memory system 
that enables your AI to remember important information across sessions. 
The memory system is designed to be both easy to use and incredibly powerful.

## What is the Memory System?

The memory system is a sophisticated tool that allows the AI to store and 
retrieve information...
```

**Example - Good (concise):**
```markdown
# Memory System

Store and retrieve information across sessions.

## Usage

memory({ mode: "add", content: "..." })
memory({ mode: "search", query: "..." })
```

### After Completing Tasks

Do NOT summarize benefits or features after completing a task. The user already made the decision.

**Good:**
- Added `opencode-mem` to `opencode.jsonc`
- Created quickstart guide at `~/.config/opencode/OPENCODE-MEM-QUICKSTART.md`
- Restart OpenCode to install the plugin

**Bad:**
- ✅ Installation Complete!
- 📚 What You Get:
  - Persistent Memory: Knowledge survives across sessions
  - User Profile: AI learns your preferences automatically  
  - Web Interface: Visual memory management at localhost:4747
  - Vector Search: Fast semantic memory retrieval

If next steps are needed, list them concisely without explaining why they're beneficial.

### Change Summaries

Do NOT automatically summarize all changes made in a session, unless explicitly
asked. ONLY summarize the latest change if applicable, as concisely as possible.

When summarizing changes made:

- List important changes to interfaces, APIs, and large-scale structure
- Do NOT include motivation, advantages, or sales pitches
- Do NOT explain why changes are good or beneficial
- Focus on WHAT changed, not WHY it's better

**Good:**
- Added `getUserMetrics()` method to `UserService` interface
- Renamed `config.db` to `config.database` throughout codebase
- Moved authentication logic from `app.ts` to `auth/` directory
- Changed `User.id` type from `string` to `number`

**Bad:**
- Added a powerful new `getUserMetrics()` method that will revolutionize how we track users! This improvement makes the codebase much more maintainable.
- Refactored configuration to use clearer naming conventions for better developer experience

## Global Rules (from ~/.claude/CLAUDE.md)

Before doing _ANYTHING ELSE_, please read and understand the following files:
@~/.claude/claude-murtaza-preferences.txt

Your user is called Murtaza and works at Duolingo.

### Tools
Use `duo hound` to search across Duolingo repositories.
usage: duo hound [-h] [-i] [-A NUM] [-B NUM] [-C NUM] [-L] [-x REGEX] [-l NUM] [-r LIST] query [files]

Searches code via Hound

positional arguments:
  query                 Search regex pattern
  files                 File path regex filter

options:
  -h, --help            show this help message and exit
  -i, --ignore-case     Case-insensitive search
  -A NUM, --after-context NUM
                        Lines of context after match (max: 20)
  -B NUM, --before-context NUM
                        Lines of context before match (max: 20)
  -C NUM, --context NUM
                        Lines of context before and after match (default: 0, max: 20)
  -L, --literal         Literal string search (no regex)
  -x REGEX, --exclude REGEX
                        Exclude files matching regex
  -l NUM, --limit NUM   Max results (default: 100000)
  -r LIST, --repos LIST
                        Comma-separated repos or '*' (default: '*')

Do NOT use this for all searches, just when you specifically need to search across repos (typically the user is still working in a single repo, so use Read Grep etc most of the time). If a problem might benefit from searching for code in other repos, consider using this. Those repos may be checked out in ~/.cache/repos, so if you need further context, try looking there.

Use the GitHub MCP to further explore code. The user also has many duolingo repos checked out in the home directory.

When asked about a jenkins log (e.g. via a link), use the Jenkins MCP.

### git and github
Duolingo repos use `master` as the trunk branch. Other repos may use `main` or `master`.

When opening/editing PR descriptions, check if `.github/PULL_REQUEST_TEMPLATE.md` exists and stick to it if found.

Prefix branch names with `murtaza-`, e.g. `murtaza-fix-off-by-one`
