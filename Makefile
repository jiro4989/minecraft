TOOL_YML := docker-compose-tool.yml

.PHONY: default
default: up

.PHONY: setup
setup:
	git clone https://github.com/grafana/grafonnet-lib grafana_dashboard/grafonnet-lib
	./minecraft/install_plugins.sh

.PHONY: up
up:
	docker-compose up

.PHONY: tool-image
tool-image:
	docker-compose -f $(TOOL_YML) build

.PHONY: spigot
spigot:
	docker-compose -f $(TOOL_YML) run spigot_builder

.PHONY: dashboard
dashboard:
	docker-compose -f $(TOOL_YML) run grafana_dashboard_builder
