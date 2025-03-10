# prjctr-19-database-replication

```
docker compose up -d
docker exec -it mysql-m ./scripts/init.sh
docker exec -it mysql-s1 ./scripts/init.sh
docker exec -it mysql-s2 ./scripts/init.sh
docker exec -it app python /app/seed.py
docker exec -it app python /app/write_data.py
```
