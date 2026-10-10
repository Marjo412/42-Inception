# Developer Documentation — Inception

## 1. Overview

This document explains how to configure, build, run, inspect, and maintain the Inception infrastructure.

The stack contains three services, each built from its own Dockerfile:

- **NGINX:** the HTTPS entry point, listening on port 443 and forwarding PHP requests to WordPress.
- **WordPress:** the website, served through PHP-FPM on port 9000 inside the Docker network.
- **MariaDB:** the WordPress database, listening on port 3306 inside the Docker network.

The containers communicate through a dedicated Docker network. Only NGINX publishes a port to the host.

## 2. Prerequisites

Prepare a Linux virtual machine (Debian is used for this project) with:

- Docker Engine and the Docker Compose plugin.
- GNU Make.
- Git, to retrieve the repository.
- Permission to run Docker commands (or use `sudo` where appropriate).
- Port **443** available on the virtual machine.

Check the tools:

```bash
docker --version
docker compose version
make --version
git --version
```

Clone the repository and enter it:

```bash
git clone git@github.com:Marjo412/42-Inception.git inception
cd inception
```

The SSH clone command requires an SSH key authorized for the repository. Alternatively, clone using its HTTPS URL.

## 3. Configuration files and secrets

The Makefile expects the Compose file and environment file at:

```text
srcs/docker-compose.yml
srcs/.env
```

Review `srcs/docker-compose.yml` to identify the variables and secrets required by the current version of the project. Create `srcs/.env` with the **non-sensitive** configuration values referenced by Compose, such as the domain name, database name, and database user. The exact variable names must match those in the Compose file.

Store passwords in the secret files referenced by the Compose `secrets:` section. For example, if the Compose configuration references `db_root_password` and `db_password`, create the corresponding files at the **exact host paths** declared under the top-level `secrets:` definitions.

Each secret file should contain only the credential value. Do not commit real credentials, secret files, or a populated `.env` file to Git. If the repository provides example configuration files, copy them and fill in the required values locally.

Check the resolved Compose configuration before starting:

```bash
docker compose --env-file srcs/.env -f srcs/docker-compose.yml config
```

**Security note:** This command can print configuration values. Do not share its output if it contains sensitive information.

Configure the virtual machine's name resolution so that `mrosset.42.fr` resolves to the VM's IP address (for example, through the appropriate `hosts` file). The VM must be reachable from the browser used for testing.

## 4. Build and launch

Run all Make commands from the repository root.

The project's Makefile uses:

```makefile
COMPOSE = docker compose --env-file srcs/.env -f srcs/docker-compose.yml
```

Create the persistent-data directories, build the images, and start the services in the background:

```bash
make all
```

The `all` target depends on `prepare`, which creates the data directories before Docker Compose starts the services.

To stop and remove the containers and their Compose network:

```bash
make down
```

The `clean` target also invokes `down`:

```bash
make clean
```

To start again:

```bash
make all
```

**Important:** Inspect the current Makefile before using `make fclean` or `make re`: cleanup targets may remove images, volumes, or stored data depending on their implementation.

## 5. Manage and inspect containers

The commands below can be run from the repository root.

Show running containers:

```bash
docker ps
```

Show the Compose services, including stopped ones:

```bash
docker compose --env-file srcs/.env -f srcs/docker-compose.yml ps -a
```

Read service logs:

```bash
docker compose --env-file srcs/.env -f srcs/docker-compose.yml logs
```

Follow logs live:

```bash
docker compose --env-file srcs/.env -f srcs/docker-compose.yml logs -f
```

Read logs for a specific container:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Restart a service without rebuilding its image:

```bash
docker compose --env-file srcs/.env -f srcs/docker-compose.yml restart nginx
```

Rebuild images and recreate services after changing a Dockerfile or build-time configuration:

```bash
make all
```

List Docker images and networks:

```bash
docker images
docker network ls
```

Open a shell in a running container, when a shell is available:

```bash
docker exec -it nginx sh
```

## 6. Persistent data and Docker volumes

The Makefile prepares these host directories:

```text
/home/mrosset/data/mariadb
/home/mrosset/data/wordpress
```

The infrastructure uses two named Docker volumes:

| Volume | Container path | Purpose |
| --- | --- | --- |
| `mariadb_data` | `/var/lib/mysql` | Database files |
| `wordpress_data` | WordPress installation directory (check Compose) | WordPress files, themes, plugins, and uploads |

Docker Compose normally prefixes volume names with the Compose project name; for example, `srcs_mariadb_data` and `srcs_wordpress_data`, unless an explicit volume name is configured.

Inspect the actual volumes and their storage locations:

```bash
docker volume ls
docker volume inspect srcs_mariadb_data
docker volume inspect srcs_wordpress_data
```

**Check the `Mountpoint` field** in the inspection output. The exact location depends on the Compose volume definitions and the Docker volume driver configuration. If the project uses local-driver options to map named volumes to `/home/mrosset/data/...`, those directories hold the persistent data. Do not assume that the directories are being used without verifying the volume configuration.

Data survives a normal container restart, recreation, or `docker compose down` because the volumes are managed separately from the containers. It does **not** survive deletion of the underlying volumes or their backing directories.

**Avoid** `docker compose down -v`, `docker volume rm`, or destructive Makefile cleanup targets unless you explicitly intend to remove stored data. Back up the database and WordPress files before deleting or migrating storage.

## 7. Verify the deployment

After `make all`:

1. Run `docker ps` and confirm that **nginx**, **wordpress**, and **mariadb** are running.
2. Confirm that NGINX publishes host port **443**, while WordPress and MariaDB remain internal to the Docker network.
3. Check `docker logs` for errors or repeated restarts.
4. From the VM, test the HTTPS endpoint:

   ```bash
   curl -k -I https://mrosset.42.fr
   ```

   `-k` skips certificate validation and is useful only for testing a self-signed development certificate. It does not prove certificate trust.
5. Open `https://mrosset.42.fr` in a browser with working VM network access and name resolution.
6. Confirm that the WordPress administration page is accessible at `https://mrosset.42.fr/wp-admin/` with the configured administrator credentials.
7. Restart the stack and confirm that previously created WordPress content is still present.

If the site is unreachable, verify the VM network, DNS/hosts configuration, port mapping, TLS configuration, and the logs of all three services.

## 8. Development workflow

For routine changes:

1. Modify the relevant Dockerfile, configuration file, or initialization script.
2. Validate the Compose configuration.
3. Run `make all` to rebuild and recreate services as needed.
4. Check container status and logs.
5. Test the website and verify data persistence.

Initialization scripts may be designed to run only when the data directory is empty. Rebuilding a container does not automatically reset an existing MariaDB database or WordPress installation. Never delete persistent data merely to force an initialization script to run without first making a backup.
