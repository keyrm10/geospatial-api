.PHONY: build up down logs shell clean lint test test-watch restart

COMPOSE=docker compose -f compose.yaml

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down --volumes

logs:
	$(COMPOSE) logs --follow

shell:
	$(COMPOSE) exec api sh

clean:
	rm -rf dist node_modules && yarn cache clean

lint:
	yarn lint

test:
	yarn test

test-watch:
	yarn test:watch

restart:
	$(COMPOSE) restart api
