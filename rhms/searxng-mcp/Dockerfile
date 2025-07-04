FROM ghcr.io/astral-sh/uv AS uv
FROM node:22-slim
COPY --from=uv /uv /
ARG SSE_PORT 8000
WORKDIR /app
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends curl \
  && rm -rf /var/lib/apt/lists/* \
  && /uv tool install mcp-searxng \
  && npm install -g supergateway \
  && mkdir -p /data
COPY start.sh /app/start.sh
ENV NODE_ENV=production \
  BASE_PATH=/data
EXPOSE ${SSE_PORT}
CMD ["/app/start.sh"]
