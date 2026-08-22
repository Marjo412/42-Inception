## Developer documentation

                    Internet / navigateur
                            │
                            │ HTTPS : 443
                            ▼
                      ┌───────────┐
                      │   NGINX   │
                      │ container │
                      └─────┬─────┘
                            │
                         FastCGI
                            │
                            ▼
                    ┌─────────────┐
                    │  WordPress  │
                    │  + PHP-FPM  │
                    │  container  │
                    └──────┬──────┘
                           │
                          SQL
                           │
                           ▼
                    ┌─────────────┐
                    │   MariaDB   │
                    │  container  │
                    └─────────────┘

Inception/
├── Makefile
├── secrets/
├── srcs/
│   ├── .env
│   ├── docker-compose.yml
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   ├── conf/
│       │   └── tools/
│       │
│       ├── nginx/
│       │   ├── Dockerfile
│       │   ├── conf/
│       │   └── tools/
│       │
│       └── wordpress/
│           ├── Dockerfile
│           ├── conf/
│           └── tools/
│
├── README.md
├── USER_DOC.md
└── DEV_DOC.md