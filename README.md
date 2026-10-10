**This project has been created as part of the 42 curriculum by mrosset**

## Description

Inception is a system administration project from the 42 curriculum. Its objective is to create and configure a small infrastructure using Docker and Docker Compose inside a virtual machine.

The infrastructure includes three main services, each built from a custom Dockerfile using Alpine Linux:

- **NGINX:** A web server configured with TLS to handle secure HTTPS connections.
- **WordPress:** A content management system (CMS) running with PHP-FPM.
- **MariaDB:** A relational database management system used to store WordPress data.

Docker Compose manages the containers, their communication through a dedicated Docker network, and persistent storage using Docker volumes.

### Infrastructure

```text
                  USER
                   |
               HTTPS (443)
                   |
              +---------+
              |  NGINX  |
              |   TLS   |
              +---------+
                   |
               PHP-FPM
                   |
              +-----------+
              | WordPress |
              | Port 9000 |
              +-----------+
                   |
                  SQL
                   |
              +---------+
              | MariaDB |
              |Port 3306|
              +---------+
```

All three containers communicate through a dedicated Docker network. Only NGINX is accessible from outside the Docker infrastructure, through port 443. WordPress and MariaDB are not directly exposed to the host.

### Technical choices and comparisons

#### Virtual Machines vs Docker

**Virtual machines (VMs)** simulate complete computers, including their own operating systems and virtualized hardware. They run through a hypervisor such as VirtualBox.

**Docker containers** share the host operating system's kernel and isolate applications and their dependencies.

Main differences:

- Virtual machines require a complete guest operating system, while containers share the host kernel.
- Containers are generally lighter and faster to start.
- Virtual machines provide stronger isolation through hardware virtualization.
- Docker simplifies application deployment and reproducibility.

**In this project:** A Debian virtual machine is used as the host environment, while Docker containers run the different services.

#### Secrets vs Environment Variables

**Environment variables** configure applications without hardcoding configuration values directly into source code. They are suitable for non-sensitive information such as database names, usernames, and domain names.

**Docker secrets** provide sensitive information, such as passwords, to containers.

Main differences:

- Environment variables are accessible through the container's environment.
- Docker Compose secrets are mounted as files inside containers, typically under `/run/secrets/`.
- Secrets help avoid exposing passwords directly through environment variables.
- Both require appropriate access controls and must be protected from accidental publication.

**In this project:** Environment variables configure the services, while Docker secrets manage sensitive credentials.

#### Docker Network vs Host Network

**Docker networks** allow containers to communicate while maintaining network isolation. With a user-defined bridge network, containers can communicate using their service names.

**Host networking** allows a container to share the host's network namespace directly.

Main differences:

- Bridge networks provide network isolation between containers and the host.
- Host networking uses the host's network interfaces directly.
- Bridge networks allow explicit port publishing.
- Host networking removes the need for port mapping but reduces network isolation.

**In this project:** A dedicated Docker bridge network connects NGINX, WordPress, and MariaDB.

#### Docker Volumes vs Bind Mounts

**Docker volumes** are persistent storage resources managed by Docker.

**Bind mounts** map a specific directory or file from the host filesystem into a container.

Main differences:

- Docker volumes are managed through Docker.
- Bind mounts depend on specific paths on the host.
- Both can preserve data independently of a container's lifecycle.
- Volumes are generally convenient for managing application data.

**In this project:** Docker named volumes are used for MariaDB and WordPress data persistence, with storage paths configured on the host.

---

## Instructions

### Requirements

- A Linux virtual machine (Debian in this project).
- Docker Engine.
- Docker Compose.
- GNU Make.
- A domain name configured to resolve to the virtual machine's IP address.

### Configuration

Before starting the infrastructure, the required configuration files must be present.

The `.env` file contains environment variables used by Docker Compose. The `secrets/` directory contains files used to provide sensitive credentials to the containers.

These files must be configured before starting the services. Sensitive information, including passwords and secrets, must not be committed to the Git repository.

### Build and run

The infrastructure is managed using the Makefile located at the root of the project.

To build the Docker images and start the containers:

```bash
make all
```

To verify that the containers are running:

```bash
docker ps
```

To display the Docker Compose services:

```bash
docker compose -f srcs/docker-compose.yml ps
```

To view the logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

To view the logs of a specific service:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Access the website

Once the infrastructure is running, WordPress can be accessed through the configured domain name using HTTPS:

```text
https://<your-login>.42.fr
```

The browser connects to NGINX through port 443, and NGINX forwards the appropriate requests to WordPress.

### Data persistence

Two Docker volumes are used:

- `mariadb_data`: Stores the MariaDB database files.
- `wordpress_data`: Stores the WordPress website files.

These volumes allow data to persist when containers are stopped, removed, or recreated, provided the volumes and their underlying data are preserved.

### Docker Compose

Docker Compose is a tool used to define and manage multi-container applications. It uses a YAML configuration file, `docker-compose.yml`, to describe the services, networks, volumes, and other settings required by the application.

With a single command, Docker Compose can build, start, stop, and manage the entire infrastructure.

In this project, Docker Compose manages NGINX, WordPress, and MariaDB.

### TLS

**TLS (Transport Layer Security)** is a cryptographic protocol used to secure communications over a computer network.

It provides:

- **Encryption:** Protects data exchanged between the client and server.
- **Authentication:** Allows the client to verify the server's identity through its certificate.
- **Integrity:** Helps detect unauthorized modifications to transmitted data.

In this project, NGINX is configured to accept HTTPS connections using TLS 1.2 and TLS 1.3.

### Dockerfile keywords

A Dockerfile contains instructions used to build a Docker image.

- **FROM:** Defines the base image used to build the Docker image. In this project, Alpine Linux is used.
- **RUN:** Executes commands during the image build process, such as installing packages or configuring services.
- **COPY:** Copies files or directories from the build context into the Docker image.
- **EXPOSE:** Documents the network ports on which the containerized application is expected to listen. It does not automatically publish these ports to the host.
- **ENTRYPOINT:** Defines the executable that runs when the container starts.
- **CMD:** Specifies the default command or arguments executed when the container starts.
- **WORKDIR:** Defines the working directory for subsequent Dockerfile instructions.

### Docker Compose commands

| Command | Description |
|---|---|
| `docker compose up -d` | Start services in the background |
| `docker compose up --build -d` | Build images and start services |
| `docker compose down` | Stop and remove containers and networks |
| `docker compose ps` | Display the status of services |
| `docker compose logs` | Display service logs |
| `docker volume ls` | List Docker volumes |
| `docker network ls` | List Docker networks |
| `docker images` | List available Docker images |

Docker Compose commands must be executed from the directory containing `docker-compose.yml`, or with the `-f` option to specify its location.

---

## Ressources

Several resources were used to understand the technical concepts and implementation of this project.

### Official documentation

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/docs/)
- [WordPress documentation](https://wordpress.org/documentation/)
- [Debian documentation](https://www.debian.org/doc/)

### Learn Docker :
    - https://www.youtube.com/playlist?list=PLpLG--nxBMd-wO_MAWh3gzqCcFh4qNMvP

### Docker commands:
    - https://www.hostinger.com/fr/tutoriels/cheat-sheet-docker/

### Inception tutorials :
    - https://inception.cluzet.fr/
    - https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok

### Debian :
    - https://www.debian.org/releases/index.fr.html

### AI:

AI tools were used as educational support throughout this project. They helped clarify technical concepts, explain Docker and networking mechanisms, understand configuration files, and interpret technical documentation.

AI was also used to assist with troubleshooting and improve the clarity of documentation. The infrastructure was configured, tested, and validated through practical implementation and reference to technical resources.
