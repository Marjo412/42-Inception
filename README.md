**This project has been created as part of the 42 curriculum by mrosset**

## Description
 Virtual Machines vs Docker
◦ Secrets vs Environment Variables
◦ Docker Network vs Host Network
◦ Docker Volumes vs Bind Mounts

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
Several websites were used to understand the different technical aspects of the project.

### Learn Docker :
    - https://www.youtube.com/playlist?list=PLpLG--nxBMd-wO_MAWh3gzqCcFh4qNMvP

### Docker commands:
    - https://www.hostinger.com/fr/tutoriels/cheat-sheet-docker/

### Inception tuto :
    - https://inception.cluzet.fr/
    - https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok

### Debian :
    - https://www.debian.org/releases/index.fr.html

### AI:
AI was used in this project as an educational support to better understand concepts and clarify technical documentation, or for more detailed explanations.