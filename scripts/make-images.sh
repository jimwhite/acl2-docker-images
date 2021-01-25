#!/bin/bash

docker image build -f Dockerfiles/ccl context -t ccl:latest
docker image build -f Dockerfiles/acl2 context -t acl2:latest
docker image build -f Dockerfiles/acl2r context -t acl2r:latest
docker image build -f Dockerfiles/acl2-bridge context -t acl2-bridge:latest
docker image build -f Dockerfiles/acl2-jupyter context -t acl2-jupyter:latest
