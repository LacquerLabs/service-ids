.DEFAULT_GOAL := help
DOCKERSYNC := $(shell command -v docker-sync-stack 2> /dev/null)

makestorage: ## just make the directories for storage
	mkdir -p ./storage/elasticsearch ./storage/portainer ./storage/eve

makenetwork: ## just make the networks
	-bash ./network.sh start

stopnetwork: ## just make the networks
	-bash ./network.sh stop

build: ## Build the app
	docker-compose stop ;\
	docker-compose build

rebuild: ## Attempt to rebuild the app without cache
	docker-compose rm --stop --force ;\
	docker-compose build --force-rm --no-cache

start: makestorage makenetwork ## Start the ids cluster
	docker-compose -f docker-compose.yml up

run: makestorage makenetwork ## Start the development cluster in detached mode
	docker-compose -f docker-compose.yml up -d

stop: ## Attempt to stop the ids cluster
	docker-compose -f docker-compose.yml stop

kill: stopnetwork ## Attempt to kill the ids cluster
	docker-compose -f docker-compose.yml kill

nuke: ## Kill and Remove defined containers
	docker-compose -f docker-compose.yml rm --force --stop

cleanstorage: ## delete storage
	rm -rf ./storage/*

connect: ## Attempt to connect to the app on the development cluster
	docker-compose -f docker-compose.yml exec suricata /bin/sh

logs: ## Watch the logs
	docker-compose -f docker-compose.yml logs -f

.PHONY: help

help: ## Helping devs since 2016
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "For additional commands have a look at the README"

