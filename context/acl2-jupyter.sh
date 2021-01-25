#!/bin/sh

# Saved April 20, 2020  14:43:33

(nohup /usr/local/bin/start-notebook.sh 2>&1 >> /home/jovyan/notebook-output.log & )

export CCL_DEFAULT_DIRECTORY="/usr/local/src/ccl"
(nohup "/usr/local/src/ccl/lx86cl64" -I "/usr/local/src/acl2-8.3/saved_acl2.lx86cl64" -Z 64M -K ISO-8859-1 -e "(acl2::acl2-default-restart)" "$@" 2>&1 >> /home/jovyan/acl2-output.log & )

touch /home/jovyan/notebook-output.log /home/jovyan/acl2-output.log

exec tail -f /home/jovyan/notebook-output.log /home/jovyan/acl2-output.log