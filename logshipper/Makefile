.DEFAULT_GOAL := help

ORG = lacquerlabs
NAME = service-logshipper
IMAGE = $(ORG)/$(NAME)
VERSION = 0.0.1
PORT_INT = 5044
PORT_EXT = 5044

build: ## Build it
	docker build -t $(IMAGE):latest .

buildnocache: ## Build it without using cache
	docker build --no-cache -t $(IMAGE):latest .

tag: ## Tag it with $(VERSION)
	docker tag $(IMAGE):latest $(IMAGE):$(VERSION)

run: ## run it -v ${PWD}/code:/app/code
	docker run -p $(PORT_EXT):$(PORT_INT) --name $(NAME)_run --rm -it $(IMAGE)

runshell: ## run the container with an interactive shell
	docker run -p $(PORT_EXT):$(PORT_INT) --name $(NAME)_run --rm -it $(IMAGE) /bin/sh

connect: ## connect to it
	docker exec -it $(NAME)_run /bin/sh

watchlog: ## connect to it
	docker logs -f $(NAME)_run

kill: ## kill it
	docker kill $(NAME)_run

release: tag ## Create and push release to docker hub
	@if ! docker images $(IMAGE) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(IMAGE)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

.PHONY: help

help: ## Helping devs since 2016
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "For additional commands have a look at the README"
