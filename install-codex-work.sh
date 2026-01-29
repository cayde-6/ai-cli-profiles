set -euo pipefail

# --- Config ---
BIN_DIR="$HOME/.ai-cli-profiles"
WRAPPER="$BIN_DIR/codex-work"
SANDBOX_DIR="$HOME/.codex-work"

# --- 1) Ensure ~/.ai-cli-profiles exists ---
mkdir -p "$BIN_DIR"

# --- 2) Create codex-work wrapper ---
cat > "$WRAPPER" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

REAL_HOME="$HOME"
SANDBOX="$REAL_HOME/.codex-work"

mkdir -p "$SANDBOX"

# 1) Isolate Codex state/config/history/logs under CODEX_HOME
# (Codex defaults to ~/.codex, so this cleanly separates profiles)
export CODEX_HOME="$SANDBOX"

# 2) Run codex
if command -v codex >/dev/null 2>&1; then
  exec codex "$@"
else
  echo "codex not found in PATH." >&2
  echo "Install Codex CLI, then retry:" >&2
  echo "  npm i -g @openai/codex" >&2
  echo "or" >&2
  echo "  brew install --cask codex" >&2
  exit 127
fi
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
echo "  codex-work --version"
echo "  codex-work login   # if you use login flow"
echo "State will be stored in: $SANDBOX_DIR"
