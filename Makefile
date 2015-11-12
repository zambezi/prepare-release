SHELL := /bin/bash
PATH  := $(shell echo $${PATH//\.\/node_modules\/\.bin:/}):node_modules/.bin

NPM = @npm install --local && touch node_modules

test: node_modules
	@bats test

node_modules: package.json
	$(NPM)
node_modules/%:
	$(NPM)

clean:
	@rm -rf $$(cat .gitignore)

.PHONY: build clean