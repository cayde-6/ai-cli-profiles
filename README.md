# 🤖 AI CLI Profiles

**Multi-account profile isolation for AI CLI tools like Claude Code and Codex.**

## 📖 Overview

This project provides isolated profile wrappers for AI CLI tools, allowing you to maintain separate configurations, authentication, and workspaces for different contexts (e.g., personal vs. work accounts).

### The Problem

AI CLI tools like Claude Code and Codex typically store their configuration, authentication tokens, and chat history in your home directory:
- `~/.config/claude/` - Claude Code settings & auth
- `~/.codex/` - Codex settings & auth

This makes it difficult to:
- Use different accounts for work and personal projects
- Keep work and personal chat histories separate
- Switch between profiles without re-authenticating

### The Solution

This project creates wrapper scripts that run AI CLIs in isolated environments:
- **`claude-work`** - Claude Code with isolated config/auth in `~/.claude-work/`
- **`codex-work`** - Codex with isolated config/auth in `~/.codex-work/`

Each wrapper maintains its own:
- ✅ Authentication credentials
- ✅ Configuration settings
- ✅ Chat/conversation history
- ✅ Cached data

## 🚀 Installation

### Prerequisites

- macOS or Linux
- `zsh` shell
- [Claude Code CLI](https://claude.ai/download) installed (for claude-work)
- [Codex CLI](https://www.npmjs.com/package/@openai/codex) installed (for codex-work)

### Install Claude Work Profile

```bash
bash install-claude-work.sh
```

This will:
1. Create `~/.ai-cli-profiles/claude-work` wrapper
2. Add `~/.ai-cli-profiles` to your PATH in `~/.zshrc`
3. Set up isolated environment in `~/.claude-work/`

### Install Codex Work Profile

```bash
bash install-codex-work.sh
```

This will:
1. Create `~/.ai-cli-profiles/codex-work` wrapper
2. Add `~/.ai-cli-profiles` to your PATH in `~/.zshrc`
3. Set up isolated environment in `~/.codex-work/`

### After Installation

**Restart your terminal** or run:
```bash
source ~/.zshrc
```

## 📚 Usage

### Claude Profiles

```bash
# Personal account (default)
claude --version
claude login

# Work account (isolated)
claude-work --version
claude-work login
```

Each profile maintains separate:
- Login credentials
- Settings in `~/.config/claude/` vs `~/.claude-work/home/.config/claude/`
- Chat history

### Codex Profiles

```bash
# Personal account (default)
codex --version
codex login

# Work account (isolated)
codex-work --version
codex-work login
```

Each profile maintains separate:
- API keys/auth
- Settings in `~/.codex/` vs `~/.codex-work/`
- Conversation history

## 🗂️ Project Structure

```
ai-cli-profiles/
├── README.md                    # This file
├── install-claude-work.sh       # Claude work profile installer
└── install-codex-work.sh        # Codex work profile installer
```

### Created Files

After installation, you'll have:

```
~/.ai-cli-profiles/
├── claude-work                  # Claude work wrapper script
└── codex-work                   # Codex work wrapper script

~/.claude-work/                  # Claude work profile data
└── home/
    ├── .config/claude/          # Isolated config
    ├── .cache/                  # Isolated cache
    └── .local/                  # Isolated data

~/.codex-work/                   # Codex work profile data
└── (Codex configuration)
```

## 🔧 How It Works

### Claude Work Wrapper

The `claude-work` wrapper:
1. Creates an isolated `HOME` directory at `~/.claude-work/home/`
2. Sets environment variables to redirect XDG paths:
   - `XDG_CONFIG_HOME`
   - `XDG_CACHE_HOME`
   - `XDG_DATA_HOME`
   - `XDG_STATE_HOME`
3. Adjusts `PATH` to include the isolated `.local/bin`
4. Executes the real `claude` binary with the isolated environment

### Codex Work Wrapper

The `codex-work` wrapper:
1. Sets `CODEX_HOME` to `~/.codex-work/`
2. Executes the `codex` binary with the isolated environment

## ⚙️ Customization

You can create additional profiles by:
1. Copying an install script
2. Changing the wrapper name (e.g., `claude-client-a`, `codex-project-x`)
3. Changing the sandbox directory (e.g., `~/.claude-client-a`, `~/.codex-project-x`)
4. Running the modified script

## 🧹 Uninstallation

To remove a profile:

```bash
# Remove wrapper
rm ~/.ai-cli-profiles/claude-work
rm ~/.ai-cli-profiles/codex-work

# Remove isolated data
rm -rf ~/.claude-work
rm -rf ~/.codex-work

# Remove from PATH (edit ~/.zshrc and remove the line)
# export PATH="$HOME/.ai-cli-profiles:$PATH"
```

## 📝 License

MIT

## 🤝 Contributing

Feel free to open issues or submit pull requests!
