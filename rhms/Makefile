.PHONY: help up down ps bolt

help: ## Show this help
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Start the services
	@docker network create rhms ||:
	@for dir in */; do \
		service_name=$${dir%/}; \
		docker compose -p $$service_name -f $$service_name/compose.yaml up -d --remove-orphans --force-recreate --build; \
		echo "✅ $$service_name started"; \
	done

down: ## Stop the services
	@for dir in */; do \
		service_name=$${dir%/}; \
		docker compose -p $$service_name -f $$service_name/compose.yaml down; \
		echo "✅ $$service_name stopped"; \
	done

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
	@docker compose -p $(c) -f $(c)/compose.yaml up -d --remove-orphans --force-recreate --build

bolt:
	cd bolt && process-compose -D -f process-compose.yaml -t=false

bolt-stop:
	cd bolt && process-compose down

attach:
	cd bolt && process-compose attach
