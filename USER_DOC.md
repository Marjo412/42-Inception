# User Documentation — Inception

## 1. Services provided

Inception runs a WordPress website inside a Linux virtual machine using Docker Compose. The stack contains three services:

| Service | Purpose | Access |
| --- | --- | --- |
| **NGINX** | Serves the website over secure HTTPS (TLS). | Port **443** on the virtual machine |
| **WordPress (PHP-FPM)** | Runs the website and its administration interface. | Internal Docker network, port **9000** |
| **MariaDB** | Stores WordPress content, users, and settings. | Internal Docker network, port **3306** |

NGINX is the only service exposed to visitors. WordPress communicates with MariaDB over a dedicated Docker network. Docker volumes preserve website and database data across container restarts and recreations, as long as the volumes are retained.

## 2. Start and stop the project

Run these commands **inside the virtual machine**, from the root of the Inception repository.

### Start

```bash
make all
```

This builds the images and starts the containers through Docker Compose. The initial startup may take longer while the images are built and WordPress is configured.

### Stop

```bash
docker compose -f srcs/docker-compose.yml down
```

This stops and removes the containers and Compose network, but **does not delete named volumes** by default.

### Restart

```bash
docker compose -f srcs/docker-compose.yml up -d
```

If configuration files or Dockerfiles have changed, rebuild using:

```bash
make all
```

> **Warning:** Do not run `docker compose down -v` or `docker volume prune` unless you intentionally want to remove stored data. Check the project's Makefile before using any cleanup target such as `make fclean`.

## 3. Access the website

Open a web browser and visit:

- **Website:** `https://mrosset.42.fr/`
- **WordPress administration:** `https://mrosset.42.fr/wp-admin/`

The domain must resolve to the virtual machine's address, and port **443** must be reachable from the browser. If accessing the site from another computer, confirm that the VM network and any port forwarding are configured correctly.

The HTTPS certificate may be self-signed in this educational setup. If the browser displays a certificate warning, verify that you are connecting to your own VM before proceeding.

To log in to the WordPress administration panel, use the **WordPress administrator credentials**, not the MariaDB credentials.

## 4. Locate and manage credentials

The project uses two kinds of configuration:

- **Environment variables:** Non-secret settings (such as the database name, database user, or domain) are configured through the project's `.env` file.
- **Docker secrets:** Passwords are supplied through files referenced in `srcs/docker-compose.yml` and mounted inside the appropriate containers, commonly under `/run/secrets/`.

To find the exact secret file paths used by this project, inspect the `secrets:` definitions in:

```text
srcs/docker-compose.yml
```

Credentials may include the MariaDB root password, the WordPress database user's password, and WordPress administrator credentials. Their exact filenames and creation process depend on the repository configuration.

**Security guidelines:**

1. Never commit `.env` files containing secrets or password files to Git.
2. Restrict access to local credential files.
3. Do not paste passwords into logs, screenshots, or issue reports.
4. Changing a secret file does **not necessarily change a password already stored** in an initialized MariaDB or WordPress installation. Coordinate password changes with the corresponding service and restart or recreate containers as needed.

## 5. Check that the services are running

### Container status

```bash
docker ps
```

You should see three running containers named `nginx`, `wordpress`, and `mariadb` (assuming the names defined in the Compose file have not been changed).

For a Compose-specific overview:

```bash
docker compose -f srcs/docker-compose.yml ps
```

### Service logs

```bash
docker compose -f srcs/docker-compose.yml logs
```

To inspect a particular container:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### HTTPS response

From inside the VM, test the local HTTPS endpoint:

```bash
curl -k -I https://127.0.0.1:443
```

An HTTP response such as `200 OK` or a redirect indicates that the web server is responding; it does **not** by itself prove that every WordPress feature or the database works. The `-k` option skips certificate verification and is intended here only for testing a self-signed certificate.

### Functional checks

1. Open `https://mrosset.42.fr/` and confirm that the WordPress website loads.
2. Open `https://mrosset.42.fr/wp-admin/` and log in.
3. Verify that the WordPress dashboard opens and content can be viewed.
4. Check the logs if any page reports a database connection or gateway error.

### Persistent storage

List Docker volumes:

```bash
docker volume ls
```

The Compose volumes for WordPress and MariaDB should be present. Their full Docker names may include the Compose project prefix (for example, `srcs_wordpress_data` and `srcs_mariadb_data`).

## 6. Basic troubleshooting

| Problem | What to check |
| --- | --- |
| Website does not open | VM running, domain resolution, port 443, NGINX status |
| `502 Bad Gateway` | WordPress/PHP-FPM container status and NGINX logs |
| Database connection error | MariaDB status, database configuration, and logs |
| Admin login fails | WordPress administrator username/password |
| Data seems missing | Docker volume mounts and whether the original volumes still exist |

For further technical details, see the project's `README.md` and `srcs/docker-compose.yml`.
