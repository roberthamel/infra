#!/usr/bin/env bash
set -e

# Log configuration for debugging
echo "Starting Searxng MCP Server"
echo "======================================"
echo "SSE Port: ${SSE_PORT}"
echo "Host IP: ${HOST_IP}"
echo "Base Path: ${BASE_PATH}"
echo "SearXNG URL": ${SEARXNG_URL}
echo "======================================"

# Set NODE_OPTIONS to increase memory limit if needed
export NODE_OPTIONS="--max-old-space-size=4096"

# Start the supergateway with the MCP server
echo "Starting Supergateway with Searxng MCP server..."

supergateway \
  --stdio "SEARXNG_URL=${SEARXNG_URL} /uv run /root/.local/share/uv/tools/mcp-searxng/bin/mcp-searxng" \
  --host ${HOST_IP} \
  --port ${SSE_PORT} \
  --healthEndpoint /health \
  --cors
