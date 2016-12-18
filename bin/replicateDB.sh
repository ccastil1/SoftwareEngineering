#!/bin/bash

if [ $NODE = "Master" ]; then
        ssh -i ~/.ssh/MasterKeys.pem -C ubuntu@54.213.130.187 "psql -d inventory_production -c 'DROP TABLE se_files;'"
        ssh -i ~/.ssh/MasterKeys.pem -C ubuntu@54.213.130.187 "psql -d inventory_production -c 'DROP TABLE se_files_id_seq;'"
        ssh -i ~/.ssh/MasterKeys.pem -C ubuntu@54.213.130.187 "psql -d inventory_production -c 'DROP TABLE file_nodes_id_seq;'"
        ssh -i ~/.ssh/MasterKeys.pem -C ubuntu@54.213.130.187 "psql -d inventory_production -c 'DROP TABLE file_nodes_se_files;'"
	pg_dump -C inventory_production | ssh -i ~/.ssh/MasterKeys.pem -C ubuntu@54.213.130.187 "psql inventory_production"
fi

