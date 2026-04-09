API_DIR := services/api
COMPOSE_FILE := compose.yaml
COMPOSE := docker compose -f $(COMPOSE_FILE)
SERVICE := api

.PHONY: build up down logs shell clean lint test test-watch restart

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down --volumes

logs:
	$(COMPOSE) logs --follow

restart:
	$(COMPOSE) restart $(SERVICE)

shell:
	$(COMPOSE) exec $(SERVICE) sh

lint:
	cd $(API_DIR) && yarn lint

test:
	cd $(API_DIR) && yarn test

test-watch:
	cd $(API_DIR) && yarn test:watch

clean:
	rm -rf $(API_DIR)/dist $(API_DIR)/node_modules
	yarn cache clean

replicate:
	bash scripts/replicate-osm-buildings.sh
