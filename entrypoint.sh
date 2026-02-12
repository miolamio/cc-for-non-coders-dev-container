#!/usr/bin/env bash
#
# entrypoint.sh — Container startup with API key management and auth gateway
#
# Architecture:
#   auth-gateway.py (:8080) → code-server (:8081) + File Browser (:9090)
#   Single login portal, then full access to IDE and file manager.
#
# Supports two API keys: primary (ANTHROPIC_AUTH_TOKEN) and backup
# (ANTHROPIC_AUTH_TOKEN_BACKUP). The switch-api-key command lets the
# instructor swap all containers to the backup key mid-session.

set -euo pipefail

# Initialize course directory from image if volume is empty (first run)
if [ -d /home/coder/.course-image ] && [ ! -f /home/coder/course/.initialized ]; then
    cp -a /home/coder/.course-image/. /home/coder/course/
    touch /home/coder/course/.initialized
fi

# Write Claude Code env config with the active API key
mkdir -p /home/coder/.claude
cat > /home/coder/.claude/.env << EOF
ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN:-}
ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL:-https://api.z.ai/api/anthropic}
ANTHROPIC_DEFAULT_OPUS_MODEL=${ANTHROPIC_DEFAULT_OPUS_MODEL:-GLM-5}
ANTHROPIC_DEFAULT_SONNET_MODEL=${ANTHROPIC_DEFAULT_SONNET_MODEL:-GLM-5}
ANTHROPIC_DEFAULT_HAIKU_MODEL=${ANTHROPIC_DEFAULT_HAIKU_MODEL:-GLM-4.5-Air}
API_TIMEOUT_MS=${API_TIMEOUT_MS:-3000000}
EOF

# Helper script to switch API keys (writes to .claude/.env so Claude Code picks it up)
cat > /home/coder/switch-api-key.sh << 'SWITCH'
#!/usr/bin/env bash
ENV_FILE="/home/coder/.claude/.env"

if [ "${1:-}" = "backup" ] && [ -n "${ANTHROPIC_AUTH_TOKEN_BACKUP:-}" ]; then
    sed -i "s|^ANTHROPIC_AUTH_TOKEN=.*|ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN_BACKUP}|" "$ENV_FILE"
    echo "Switched to BACKUP key in .claude/.env"
    echo "Restart Claude Code (Ctrl+C, then 'claude') to apply."
elif [ "${1:-}" = "primary" ] && [ -n "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
    sed -i "s|^ANTHROPIC_AUTH_TOKEN=.*|ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN}|" "$ENV_FILE"
    echo "Switched to PRIMARY key in .claude/.env"
    echo "Restart Claude Code (Ctrl+C, then 'claude') to apply."
else
    echo "Usage: ./switch-api-key.sh [primary|backup]"
    echo ""
    CURRENT=$(grep ANTHROPIC_AUTH_TOKEN "$ENV_FILE" | head -1 | cut -d= -f2)
    echo "Current key: ${CURRENT:0:8}..."
    [ -n "${ANTHROPIC_AUTH_TOKEN_BACKUP:-}" ] && echo "Backup key: ${ANTHROPIC_AUTH_TOKEN_BACKUP:0:8}..." || echo "Backup key: not set"
fi
SWITCH
chmod +x /home/coder/switch-api-key.sh

# Welcome banner in terminal
cat >> /home/coder/.bashrc << 'BANNER'

echo ""
echo -e "\033[1;36m  Claude Code: рабочая среда курса\033[0m"
echo -e "\033[0;37m  ─────────────────────────────────\033[0m"
echo -e "  Запустить Claude Code:  \033[1;32mclaude\033[0m"
echo -e "  Первое демо:            \033[0;33mcd sessions/01-setup/demo/financial-dashboard\033[0m"
echo -e "  Файловый менеджер:      \033[0;33m/files/\033[0m в адресной строке"
echo -e "  Переключить API-ключ:   \033[0;33m./switch-api-key.sh [primary|backup]\033[0m"
echo ""
BANNER

# Start File Browser in background (noauth + branding configured at build time in Dockerfile)
FB_DB="/home/coder/.config/filebrowser/filebrowser.db"
filebrowser --database "$FB_DB" > /tmp/filebrowser.log 2>&1 &

# Start code-server in background (internal, no auth — gateway handles auth)
code-server \
    --bind-addr 127.0.0.1:8081 \
    --auth none \
    --disable-telemetry \
    /home/coder/course > /tmp/code-server.log 2>&1 &

# Start auth gateway (single entry point on :8080)
exec python3 /home/coder/auth-gateway.py
