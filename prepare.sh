#!/bin/bash

cd /opt
virtualenv pgadmin4
cd pgadmin4
source bin/activate

wget https://ftp.postgresql.org/pub/pgadmin3/pgadmin4/v1.1/pip/pgadmin4-1.1-py2-none-any.whl

pip install pgadmin4-1.1-py2-none-any.whl

sed -i "s/DEFAULT_SERVER = 'localhost'/DEFAULT_SERVER = '0.0.0.0'/" /opt/pgadmin4/lib/python2.7/site-packages/pgadmin4/config.py
sed -i "s/SERVER_MODE = True/SERVER_MODE = False/" /opt/pgadmin4/lib/python2.7/site-packages/pgadmin4/config.py

service postgresql start

random_password=$(pwgen -s 10 1)

echo "=> change postgresql user with ${random_password} password"
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password '$random_password';"

source /opt/pgadmin4/bin/activate
python2 /opt/pgadmin4/lib/python2.7/site-packages/pgadmin4/setup.py

service postgresql stop