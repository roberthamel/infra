SHELL := /bin/bash

.ONESHELL:
up: init
	cp app.ini ~/.local/gitea/app.ini
	docker compose up -d

down:
	docker compose down

init:
	$(shell [[ ! -d ~/.local/gitea ]] && mkdir -p ~/.local/gitea)

clean:
	rm -rf ~/.local/gitea/app.ini

config:
	cat ~/.local/gitea/app.ini
