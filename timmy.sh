#!/bin/bash

identify=${1:-"/root/.ssh/id_rsa"}

curl -s "http://127.0.0.1:8000/api/nodes/?cluster_id=1" | python -mjson.tool | awk -videntify=$identify -W posix '/^    },?/ {role=""} /^[ ]{8}"ip":/ {gsub("[\",]", "", $2); ip=$2} /"roles": / {m=1;next} (m == 1 && /"(compute|controller)"/) { if ($1 ~ /compute/) { compute++; role="compute"compute  } else { controller++; role="controller"controller } printf("Host %s\n\tUser root\n\tHostName %s\n\tIdentityFile %s\n", role, ip, identify) 	}' > ssh_config

