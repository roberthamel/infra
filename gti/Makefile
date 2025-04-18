.PHONY: help up down ps logs kill start

help: ## Show this help
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up-all: ## Start the services
	@docker network create gti ||:
	@for dir in */; do \
		service_name=$${dir%/}; \
		docker compose -p $$service_name -f $$service_name/compose.yaml up -d --remove-orphans --force-recreate; \
		echo "✅ $$service_name started"; \
	done

down-all: ## Stop the services
	@for dir in */; do \
		service_name=$${dir%/}; \
		docker compose -p $$service_name -f $$service_name/compose.yaml down; \
		echo "✅ $$service_name stopped"; \
	done

down: ## Stop a specific container (make down-single c=gitea)
	@docker compose -p $(c) -f $(c)/compose.yaml down

up: ## Start a specific container (make up-single c=gitea)
	@docker compose -p $(c) -f $(c)/compose.yaml up -d --remove-orphans --force-recreate

restart: down pull up ## restart a specific container (make restart c=gitea)
restart-all: down-all pull-all up-all ## restart all containers

ps: ## List all running services
	@echo "📦 Running services:"
	@echo "------------------------------------------------------"
	@docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo "------------------------------------------------------"

logs: ## Show logs for a specific service
	@docker compose -p $(c) -f $(c)/compose.yaml logs -f

kill: ## stop a specific container (make kill c=gitea)
	@docker compose -p $(c) -f $(c)/compose.yaml down

start: ## launch a specific container (make start c=gitea)
	@if [ -f $(c)/docker-compose.yml ]; then \
		docker compose -p $(c) -f $(c)/docker-compose.yml up -d --remove-orphans --force-recreate --build; \
	else \
		docker compose -p $(c) -f $(c)/compose.yaml up -d --remove-orphans --force-recreate --build; \
	fi

pull: ## pull a specific container (make pull c=gitea)
	@docker compose -p $(c) -f $(c)/compose.yaml pull

pull-all: ## pull all containers
	@for dir in */; do \
		service_name=$${dir%/}; \
		docker compose -p $$service_name -f $$service_name/compose.yaml pull; \
	done
