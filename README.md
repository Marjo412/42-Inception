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

### Docker-Compose :
Docker Compose is a tool developed to help define and share multi-container applications.
With Compose, we can create a YAML file to define services and, with a single command, start or stop everything.

### TLS :
"Transport Layer Security" is a protocol for securing exchanges over computer networks, particularly over the Internet.

### Dockerfile keywords :
    - FROM -> This tells Docker which operating system your virtual machine should run on.
                It's the first keyword in your Dockerfile and is mandatory.
    - RUN -> Allows you to run a command on your virtual machine
    - COPY -> This allows you to copy a file. You simply specify the location of the file you
                want to copy from the directory containing your Dockerfile, and then the location
                where you want to copy it within your virtual machine.
    - EXPOSE -> Informs Docker that the container is listening on the specified network ports at
                runtime and makes it available only for communication between containers.
                **Note:** For the WordPress server to communicate with the MariaDB container, it is important
                that both containers run in the same Docker network.
    - ENTRYPOINT -> This instructs the container to execute a specific command when it starts. Simply specify your
                    command, argument by argument.

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
