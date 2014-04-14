#!/bin/sh

wait_for_success() {
    cmd=$1
    refresh_sec=${2:-5}
    timeout_sec=${3:-300}
    echo "waiting_for: ${cmd} refresh: $refresh_sec} timeout: ${timeout_sec}" > /dev/stderr

    started=`date "+%s"`

    eval $cmd > /dev/null
    exit_code=$?

    while [ ${exit_code} -ne 0 ]; do
        sleep ${refresh_sec}

        eval $cmd > /dev/null
        exit_code=$?

        running=$((`date +%s` - ${started}))

        echo "waiting_for ${cmd} running: ${running} timeout: ${timeout_sec}" > /dev/stderr
        [ ${running} -gt ${timeout_sec} ] && break

    done

    echo "waiting_for '${cmd}' code: ${exit_code}" > /dev/stderr
    return ${exit_code}
}

waiting_for_background_jobs() {
	background_pids=$*
	#echo "Waiting for pids: $background_pids"
	while [ -n "`echo $background_pids | sed -r 's/  +//g'`" ]; do
	    echo "Waiting for pids: $background_pids"
	    for pid in $background_pids; do
	        ps -P ${pid} >/dev/null 2>&1 || {
                    background_pids=`echo $background_pids | sed -r 's/(^| )'${pid}'($| )/ /g'`
                    echo ${pid} done
                }
	    done
	    sleep 1
	done
}

tmpdir=`date "+%s" | md5sum -`

for host in `egrep -i ^Host $1 | awk '{print $2}'`; do
     # parralel jobs
     pids="${pids} `find hosts/${host} -type l 2>/dev/null| xargs -P20 -I% ./run_cmd $1 ${host} %`"
done
# sequence jobs
pids="${pids} `find hosts/* -mindepth 2 | xargs -P20 -I% ./run_cmd $1 ${host} %`"

waiting_for_background_jobs $pids
