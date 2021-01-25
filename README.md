# ACL2 Docker Images

This repository contains a number of Docker images that contain an ACL2 environment:

* CCL -- A running version of Clozure Common LISP
* ACL2 -- Pristine ACL2 image built from the [ACL2 Home Page](https://www.cs.utexas.edu/users/moore/acl2/)
* ACL2r -- ACL2(r) image with support for the real numbers
* ACL2-Bridge -- ACL2 (not (r)) image that runs an ACL2::Bridge server. This image is intended for educational use and automatically loads some ACL2s extensions
* ACL2-Jupyter -- A Jupyter server that supports ACL2 notebooks. This automatically includes an internal ACL2 server, so it is entirely self-contained

The scripts directory contains some example commands for running the containers. For example, to run ACL2 you can issue the command

    ACL2_PROJECT_DIR=${ACL2_PROJECT_DIR:=$PWD}

    docker run -it -v "${ACL2_PROJECT_DIR}":/Project rubengamboa/acl2:latest

Notice that the current directory is mapped to the `/Project` directory inside the Docker image. This makes it so that ACL2 can easily `ld` files from the current directory.

## LICENSE

This package is released with the same license as ACL2, the BSD 3-Clause license.
