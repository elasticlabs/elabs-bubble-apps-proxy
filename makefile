# Set default no argument goal to help
.DEFAULT_GOAL := help

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# Variables initialization from .env file
DC_PROJECT?=$(shell cat .env | grep COMPOSE_PROJECT_NAME | sed 's/^*=//')
BUBBLE_URL?=$(shell cat .env | grep VIRTUAL_HOST | sed 's/.*=//')
CURRENT_DIR?= $(shell pwd)

# Every command is a PHONY, to avoid file naming confliction -> strengh comes from good habits!
.PHONY: help
help:
	@echo "=============================================================================================="
	@echo "                Building a simple Bubble Apps proxy composition "
	@echo "             https://github.com/elasticlabs/elabs-bubble-apps-proxy"
	@echo " "
	@echo "Hints for developers:"
	@echo "  make up             # With working HTTPS proxy, bring up the Bubble stack"
	@echo "  make down           # Brings the Bubble stack down. "
	@echo "  make update         # Update the whole stack"
	@echo "  make cleanup   # Complete hard cleanup of images, containers, networks, volumes & data"
	@echo "=============================================================================================="

.PHONY: up
up:
	@bash ./.utils/message.sh info "[INFO] Building the Bubble apps proxy stack"
	# Set server_name in reverse proxy
	sed -i "s/changeme/$(BUBBLE_URL)/" ./proxy/bubble-stack.conf
	# Build the stack
	docker-compose -f docker-compose.yml build
	# Run the stack
	docker-compose -f docker-compose.yml up -d

.PHONY: down
down:
	@bash ./.utils/message.sh info "[INFO] Bringing done the Airflow stack"
	docker-compose -f docker-compose.yml down --remove-orphans
	@bash ./.utils/message.sh info "[INFO] Done. See (sudo make cleanup) for containers, images, and static volumes cleanup"

.PHONY: cleanup
cleanup: 
	@bash ./.utils/message.sh info "[INFO] Bringing done the Bubble proxy stack"
	docker-compose -f docker-compose.yml down --remove-orphans
	# 2nd : clean up all containers & images, without deleting static volumes
	@bash ./.utils/message.sh info "[INFO] Cleaning up containers & images"
	docker system prune -a
	docker volume rm -f $(DC_PROJECT)_nginx-configs

.PHONY: pull
pull: 
	docker-compose -f docker-compose.yml pull

.PHONY: update
update: pull up wait
	docker system prune -a

.PHONY: wait
wait: 
	sleep 5