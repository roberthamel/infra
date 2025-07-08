#!/usr/bin/env bash
set -e

# Log configuration for debugging
echo "Starting Playwright MCP Server"
echo "======================================"
echo "SSE Port: ${SSE_PORT}"
echo "Host IP: ${HOST_IP}"
echo "Base Path: ${BASE_PATH}"
echo "======================================"

# Clean up any existing profile locks
echo "Cleaning up existing browser profiles..."
if [ -d "/root/.cache/ms-playwright/mcp-chrome-profile" ]; then
    echo "Removing existing profile directory"
    rm -rf /root/.cache/ms-playwright/mcp-chrome-profile
fi

# Check if browsers are installed
echo "Checking Playwright installation..."
if [ -d "/root/.cache/ms-playwright" ]; then
    echo "✓ Playwright browsers found"
    ls -la /root/.cache/ms-playwright/
else
    echo "⚠ Playwright browsers not found in expected location"
fi

# Debug: Check the actual package structure
echo "Checking @playwright/mcp package structure..."
if [ -d "/app/node_modules/@playwright/mcp" ]; then
    echo "✓ @playwright/mcp package found"
    ls -la /app/node_modules/@playwright/mcp/
    echo "Package contents:"
    find /app/node_modules/@playwright/mcp -name "*.js" -o -name "*.json" | head -10
else
    echo "⚠ @playwright/mcp package not found"
fi

# Start with isolated mode to prevent profile conflicts
echo "Starting Supergateway with Playwright MCP server..."

supergateway \
  --stdio "npx @playwright/mcp --isolated --headless --no-sandbox" \
  --host ${HOST_IP} \
  --port ${SSE_PORT} \
  --healthEndpoint /health \
  --cors
