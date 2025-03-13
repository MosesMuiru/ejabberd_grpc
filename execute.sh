#!/bin/bash

echo "waiting for postgres to connect"
sleep 5

# change pg to executable format
chmod +x ./pg.sql

# enhe!! yes then run the command to execute the tables
sudo -u postgres psql -d ejabberd -h db pg.sql

echo "scripts executed done"