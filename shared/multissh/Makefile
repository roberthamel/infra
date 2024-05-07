USER := rh

install:
	cp .multissh.conf $(HOME)
	cp multissh /usr/local/bin
	cp pty.node /usr/local/bin
	cp com.$(USER).multissh.plist $(HOME)/Library/LaunchAgents
	chmod 644 ~/Library/LaunchAgents/com.$(USER).multissh.plist

load:
	launchctl load $(HOME)/Library/LaunchAgents/com.$(USER).multissh.plist

lint:
	plutil -lint com.$(USER).multissh.plist

bootstrap:
	sudo launchctl bootstrap system $(HOME)/Library/LaunchAgents/com.$(USER).multissh.plist

destroy:
	launchctl unload $(HOME)/Library/LaunchAgents/com.$(USER).multissh.plist
	rm -f /usr/local/bin/multissh
	rm -f /usr/local/bin/pty.node
	rm -f $(HOME)/Library/LaunchAgents/com.$(USER).multissh.plist
	rm -f $(HOME)/.multissh.conf

run:
	./multissh

relaunch: destroy  wait install wait load

wait:
	sleep 2
