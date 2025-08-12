#!/bin/sh

# Saved April 20, 2020  14:43:33

(nohup /usr/local/bin/start-notebook.sh 2>&1 >> /home/jovyan/notebook-output.log & )

(nohup "/opt/acl2/bin/acl2" -e "(acl2::acl2-default-restart)" "$@" 2>&1 >> /home/jovyan/acl2-output.log & )

touch /home/jovyan/notebook-output.log /home/jovyan/acl2-output.log

exec tail -f /home/jovyan/notebook-output.log /home/jovyan/acl2-output.log
