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

Then the write script should be able to populate the database by inserting new payments every second.

To test the repliciation, run the next commands on replicas multiple times:

```
docker exec -it mysql-s1 mysql -u root -proot -e "SELECT COUNT(*) FROM testdb.payments;"
docker exec -it mysql-s1 mysql -u root -proot -e "SELECT * FROM testdb.payments ORDER BY created_at DESC LIMIT 3;"
```

The new records should be added every second, replicated from the master node.

## Try to remove a column in database on slave node (try to delete last column and column from the middle).

Deleting the last column will cause no errors. Deleting a column in the middle will lead to an error like this:

```
Column 2 of table 'testdb.payments' cannot be converted from type 'decimal(10,2)' to type 'timestamp'
```

### Reason:

Column positioning matters: In row-based replication, MySQL identifies columns by position, not by name.

When you drop a middle column, it shifts all subsequent columns one position to the left, causing misalignment with the primary server.
