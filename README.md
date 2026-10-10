**This project has been created as part of the 42 curriculum by mrosset**

## Description

Inception is a system administration project from the 42 curriculum. Its objective is to create and configure a small infrastructure using Docker and Docker Compose inside a virtual machine.

The infrastructure includes three main services, each built from a custom Dockerfile using Alpine Linux:

- **NGINX:** A web server configured with TLS to handle secure HTTPS connections.
- **WordPress:** A content management system (CMS) running with PHP-FPM.
- **MariaDB:** A relational database management system used to store WordPress data.

Docker Compose manages the containers, their communication through a dedicated Docker network, and persistent storage using Docker volumes.

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
