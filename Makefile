NAME = inception

## Build and start all Docker containers in the background
all:
	docker compose -f srcs/docker-compose.yml up --build -d
## programm's name, file, path, create and start the infrastructure, construction, detached mode

clean:

fclean: clean

re: fclean all

.PHONY all clean fclean re