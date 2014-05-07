#!/bin/sh

curl -s "http://$1:8000/api/nodes/?cluster_id=2" | python -mjson.tool | awk -W posix '/^    },?/ {role=""} /^[ ]{8}"ip":/ {gsub("[\",]", "", $2); ip=$2} /"roles": / {m=1;next} (m == 1 && /"(compute|controller)"/) {printf("%s %s\n", $1, ip)}' > ssh_config
#curl -s 'localhost:8000/api/nodes/?cluster_id=2' | python -mjson.tool | awk -W posix '/^    },?/ {role=""} /^[ ]{8}"ip":/ {gsub("[\",]", "", $2); ip=$2} /"roles": / {m=1;next} (m == 1 && /"(compute|controller)"/) {printf("%s %s\n", $1, ip)}'
#./collect.sh ssh_config
