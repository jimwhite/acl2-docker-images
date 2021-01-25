#!/bin/bash

ACL2_PROJECT_DIR=${ACL2_PROJECT_DIR:=$PWD}

docker run -it -v "${ACL2_PROJECT_DIR}":/Project rubengamboa/acl2:latest
