# PostgreSQL Setup Report – Nautilus Database Server

### Objective

Prepare the Nautilus database server for a new application deployment by configuring PostgreSQL with the required user and database.

---

### Steps Performed

1. **Switched to `postgres` user**

   ```bash
   sudo -i -u postgres
   ```

2. **Accessed PostgreSQL prompt**

   ```bash
   psql
   ```

3. **Created database user**

   ```sql
   CREATE USER kodekloud_roy WITH PASSWORD 'ksH85UJjhb';
   ```

4. **Created database**

   ```sql
   CREATE DATABASE kodekloud_db7;
   ```

5. **Granted privileges to the user**

   ```sql
   GRANT ALL PRIVILEGES ON DATABASE kodekloud_db7 TO kodekloud_roy;
   ```

6. **Verification**

   * List users/roles:

     ```sql
     \du
     ```
   * List databases:

     ```sql
     \l
     ```

7. **Exit PostgreSQL**

   ```sql
   \q
   exit
   ```

---

### Result

* ✅ User `kodekloud_roy` created successfully.
* ✅ Database `kodekloud_db7` created successfully.
* ✅ Full privileges granted to `kodekloud_roy` on `kodekloud_db7`.
* ✅ PostgreSQL server left running without restart (as per requirement).
