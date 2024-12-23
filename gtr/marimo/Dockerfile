FROM ghcr.io/marimo-team/marimo:latest
COPY --from=ghcr.io/astral-sh/uv:0.4.20 /uv /bin/uv
ENV UV_SYSTEM_PYTHON=1
WORKDIR /app
CMD [ "marimo", "edit", "--no-token", "-p", "7777", "--host", "0.0.0.0" ]
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:7777/health || exit 1
