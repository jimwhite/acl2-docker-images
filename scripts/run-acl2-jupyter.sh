#!/bin/bash

ACL2_PROJECT_DIR=${ACL2_PROJECT_DIR:=$PWD}

docker run -it -p 8888:8888 -v "${ACL2_PROJECT_DIR}":/home/jovyan/work rubengamboa/acl2-jupyter:latest
