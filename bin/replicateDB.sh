#!/bin/bash

if [ $NODE = "Master" ]; then
	pg_dump -C inventory_production | ssh -i ~/.ssh/MasterKeys.pem -C ubuntu@54.213.130.187 "psql inventory_production"
fi

if [ $NODE = "Backup" ]; then
	pg_dump -C inventory_production | ssh -i ~/.ssh/MasterKeys.pem -C ubuntu@54.218.119.184 "psql inventory_production"
fi
