set -euo pipefail

# --- Config ---
BIN_DIR="$HOME/.ai-cli-profiles"
WRAPPER="$BIN_DIR/claude-work"
SANDBOX_DIR="$HOME/.claude-work"

# --- 1) Ensure ~/.ai-cli-profiles exists ---
mkdir -p "$BIN_DIR"

# --- 2) Create claude-work wrapper ---
cat > "$WRAPPER" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

REAL_HOME="$HOME"
SANDBOX="$REAL_HOME/.claude-work"
WORK_HOME="$SANDBOX/home"

# Create isolated home + the path Claude expects
mkdir -p "$WORK_HOME/.local/bin"

# 1) Isolate all Claude CLI state
export HOME="$WORK_HOME"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# 2) Remove Claude's sidebar warning:
# Claude checks for "$HOME/.local/bin" in PATH, so include it.
# Also include REAL_HOME's ~/.local/bin so we can run the real installed binary.
export PATH="$HOME/.local/bin:$REAL_HOME/.local/bin:$PATH"

# 3) Run Claude (native install path)
exec "$REAL_HOME/.local/bin/claude" "$@"
EOF

chmod +x "$WRAPPER"

# --- 3) Ensure ~/.ai-cli-profiles is in PATH for zsh ---
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
  echo 'export PATH="$HOME/.ai-cli-profiles:$PATH"' >> "$HOME/.zshrc"
  echo "✅ Added ~/.ai-cli-profiles to PATH in ~/.zshrc"
fi

# --- 4) Reload zsh config (best effort) ---
if [[ -n "${ZSH_VERSION-}" ]]; then
  source "$HOME/.zshrc" || true
fi

# --- 5) Verify ---
echo "✅ Installed: $WRAPPER"
echo ""
echo "⚠️  Restart your terminal or run:"
echo "   source ~/.zshrc"
echo ""
echo "Then try:"
echo "  claude-work --version"
echo "  claude-work login   # if CLI asks for browser login"
