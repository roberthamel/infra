SHELL := /bin/bash
USER := rh

init:
	@echo "Installing Homebrew dependencies"
	@brew bundle

install:
	@echo "Installing multissh"
	cp .multissh.conf $(HOME)
	cp multissh /usr/local/bin
	cp pty.node /usr/local/bin
	cp com.$(USER).multissh.plist $(HOME)/Library/LaunchAgents
	chmod 644 ~/Library/LaunchAgents/com.$(USER).multissh.plist
	@echo "multissh installed"

load:
	launchctl load $(HOME)/Library/LaunchAgents/com.$(USER).multissh.plist

lint:
	@echo "Linting .multissh.conf"
	plutil -lint com.$(USER).multissh.plist
	@echo "Lint .multissh.conf no problems found"

bootstrap:
	@echo "Bootstrapping multissh"
	sudo launchctl bootstrap system $(HOME)/Library/LaunchAgents/com.$(USER).multissh.plist
	@echo "multissh bootstrapped"

destroy:
	@echo "Uninstalling multissh"
	launchctl unload $(HOME)/Library/LaunchAgents/com.$(USER).multissh.plist
	rm -f /usr/local/bin/multissh
	rm -f /usr/local/bin/pty.node
	rm -f $(HOME)/Library/LaunchAgents/com.$(USER).multissh.plist
	rm -f $(HOME)/.multissh.conf
	@echo "multissh uninstalled"

run:
	@echo "Running local multissh"
	./multissh

relaunch: destroy wait install wait load

wait:
	@echo "Waiting 2 seconds"
	@sleep 2

.PHONY: addhost
HOST_NAME := somehost
addhost:
	@echo "Adding host $(HOST_NAME)"
	@echo $(HOST_NAME)
	@[[ "$(HOST_NAME)" == "somehost" ]] && (echo "Please provide a host name with 'make addhost HOST_NAME:=yourhost'" && exit 1) ||:
	@jq '. += [{"group": "$(HOST_NAME)", "hosts": [ "$(HOST_NAME)" ]}]' .multissh.conf | sponge .multissh.conf
	@echo "Added host $(HOST_NAME) to .multissh.conf"
