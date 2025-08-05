FROM --platform=linux/amd64 mcr.microsoft.com/playwright:v1.40.0-jammy

ARG SSE_PORT=8000
WORKDIR /app

RUN apt update \
  && apt upgrade -y \
  && apt install -y --no-install-recommends \
    curl \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN node --version | grep -q "v22" || (curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt install -y nodejs)

RUN npm install -g supergateway @playwright/mcp
RUN npx playwright install --with-deps chrome

RUN mkdir -p /data
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV NODE_ENV=production \
    BASE_PATH=/data \
    NODE_OPTIONS="--max-old-space-size=4096"

EXPOSE ${SSE_PORT}

CMD ["/app/start.sh"]
