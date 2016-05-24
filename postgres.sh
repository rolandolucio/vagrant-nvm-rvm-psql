#!/usr/bin/env bash

echo "================================
PostgreSQL 9.4 Dependencies    
================================"

sudo cat >> /etc/apt/sources.list.d/pgdg.list <<EOL
deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
EOL
sudo cat /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update

sudo apt-get install -y postgresql-9.4

echo "================================"
echo "psycopg2 "    
echo "================================"
sudo apt-get -y install python-psycopg2

echo "================================"
echo "libpq-dev"    
echo "================================"
sudo apt-get -y install libpq-dev


echo "================================"
echo "PostgreSQL 9.4 md5 perms "    
echo "================================"

sudo cat > /home/vagrant/dbperms.sh <<EODB
#!/usr/bin/env bash

# Allow only root execution
if [ `id|sed -e s/uid=//g -e s/\(.*//g` -ne 0 ]; then
    echo "This script requires root privileges"
    exit 1
fi

echo "================================
modifying pg_hba.conf    
================================"

sudo cat > /etc/postgresql/9.4/main/pg_hba.conf <<EOP
# Database administrative login by Unix domain socket
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     md5
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5

EOP

sudo service postgresql restart

EODB

sudo chmod +x /home/vagrant/dbperms.sh
sudo ./dbperms.sh

#sudo -u postgres psql
#sudo -u postgres createuser $user -S -D -R -P
#sudo -u postgres createdb $db -O $user
