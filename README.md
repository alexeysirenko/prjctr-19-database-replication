# prjctr-19-database-replication

Setup

```
docker compose up -d
docker exec -it mysql-m ./scripts/init.sh
docker exec -it mysql-s1 ./scripts/init.sh
docker exec -it mysql-s2 ./scripts/init.sh
docker exec -it app python /app/seed.py
docker exec -it app python /app/write_data.py
```

To test the repliciation run multiple times:

```
docker exec -it mysql-s1 mysql -u root -proot -e "SELECT COUNT(*) FROM testdb.payments;"
docker exec -it mysql-s1 mysql -u root -proot -e "SELECT * FROM testdb.payments ORDER BY created_at DESC LIMIT 3;"
```

The new records should be added every second, replicated from the master node.
