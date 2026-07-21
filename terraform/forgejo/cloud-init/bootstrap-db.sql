DO
$do$
BEGIN
   IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'forgejo') THEN
      ALTER USER forgejo WITH PASSWORD '__DB_PASSWORD__';
   ELSE
      CREATE USER forgejo WITH PASSWORD '__DB_PASSWORD__';
   END IF;
END
$do$;
