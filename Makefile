NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

DATA_PATH = /home/mrosset/data
MARIADB_DATA = $(DATA_PATH)/mariadb
WORDPRESS_DATA = $(DATA_PATH)/wordpress

# Prepare directories for persistent data
prepare:
	mkdir -p $(MARIADB_DATA)
	mkdir -p $(WORDPRESS_DATA)

# Prepare, build and start the infrastructure
all: prepare
	$(COMPOSE) up --build -d

# Stop and remove containers and network
down:
	$(COMPOSE) down

# Stop the infrastructure
clean: down

# Remove the whole infrastructure and persistent data
fclean: clean
	$(COMPOSE) down --rmi all -v
	rm -rf $(MARIADB_DATA)
	rm -rf $(WORDPRESS_DATA)

# Completely rebuild the infrastructure
re: fclean all

.PHONY: all prepare down clean fclean re