SHELL := /bin/bash

init:
	@echo "Initializing..."
	@rm -rf .devbox > /dev/null
	@brew bundle --no-lock > /dev/null
	@echo "Done."

