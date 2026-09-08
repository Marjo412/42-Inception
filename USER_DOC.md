## User documentation

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