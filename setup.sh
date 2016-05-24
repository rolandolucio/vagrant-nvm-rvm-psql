#!/usr/bin/env bash



#Set the SWAP mem

echo "================================"
echo "~~~~~~~      SWAP      ~~~~~~~"
echo "================================"

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

sudo cat >> /etc/fstab <<EOL
/var/swap.1 swap swap defaults 0 0
EOL
sudo cat /etc/fstab 

echo "================================"
echo "CURL"    
echo "================================"

#sudo apt-get install -y git-core curl


echo "================================"
echo "PostgreSQL 9.4 Dependencies"    
echo "================================"

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
echo "essentials "
echo "================================"

sudo apt-get -y install build-essential


echo "================================"
echo "Expect  "
echo "================================"

sudo apt-get -y install expect

echo "================================"
echo " Git "
echo "================================"
#install git
sudo apt-get -y install git




echo "================================"
echo "Copying steps" 
echo "================================"

echo "step 1"
sudo cat > /home/vagrant/step1.sh <<EOF
#!/usr/bin/env bash

echo "================================"
echo "PostgreSQL 9.4 perms sh"    
echo "================================"

sudo cat > /home/vagrant/dbperms.sh <<EODB
#!/usr/bin/env bash

# Allow only root execution
if [ `id|sed -e s/uid=//g -e s/\(.*//g` -ne 0 ]; then
    echo "This script requires root privileges"
    exit 1
fi

echo "================================"
echo "PostgreSQL 9.4 pg_hba.conf"    
echo "================================"

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

echo "================================"
echo "RVM versions  1.9.3 default  "
echo "================================"

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby

echo "================================"
echo "NVM  "    
echo "==============================="

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash


echo "
=======================================
***************************************


execute on reboot: ./step2.sh
-----note: no sudo


***************************************
=======================================
"


sudo reboot

EOF

echo "step 2"
sudo cat > /home/vagrant/step2.sh <<EOF
#!/usr/bin/env bash

echo "================================"
echo "RVM versions  1.9.3 default  "
echo "================================"

rvm install ruby-1.9.3-p551


echo "================================
NVM version
================================

Need Node.Js?

Manually Execute the following commands:
*********************************************

nvm install 0.10 \
nvm alias default 0.10 \
nvm use default

*********************************************


after its done Run your deployment script

sync folfer perms error? run:
sudo chown -R :vagrant sync
"

EOF


echo "================================"
echo "perms  "    
echo "==============================="

sudo chown vagrant:vagrant *
sudo chmod +x step*

echo "
=======================================
***************************************


execute on boot: ./step1.sh
-----note: no sudo



***************************************
=======================================
"

#sudo -u postgres psql
#sudo -u postgres createuser $user -S -D -R -P
#sudo -u postgres createdb $db -O $user

