#!/bin/bash
set -e

service postgresql start

# init variables
USER=${DB_USER:-admin}

# random password if needed
if [ "$DB_PASS" = "**Random**" ]; then
    unset DB_PASS
fi
PASS=${DB_PASS:-$(pwgen -s 12 1)}

NEW_USER_CMD="
do 
\$body\$
declare 
  num_users integer;
begin
   SELECT count(*) into num_users FROM pg_user WHERE usename = '$USER';

   IF num_users = 0 THEN
      CREATE ROLE $USER LOGIN PASSWORD '$PASS';
      ALTER USER $USER WITH CREATEDB;
      ALTER USER $USER WITH SUPERUSER;
   END IF;
end
\$body\$
;
"

echo "=> creating postgresql user ${USER} with ${PASS} password"
sudo -u postgres psql -U postgres -d postgres -c "$NEW_USER_CMD"
# sudo -u postgres psql -U postgres -d postgres -c "CREATE USER $USER WITH PASSWORD '$PASS';"
# sudo -u postgres psql -U postgres -d postgres -c "ALTER USER $USER WITH CREATEDB;"
# sudo -u postgres psql -U postgres -d postgres -c "ALTER USER $USER WITH SUPERUSER;"
source /opt/pgadmin4/bin/activate

exec "$@"