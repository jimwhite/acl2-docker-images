# ACL2 Docker Images

This repository contains a number of Docker images that contain an ACL2 environment:

* CCL -- A running version of Clozure Common LISP
* ACL2 -- Pristine ACL2 image built from the [ACL2 Home Page](https://www.cs.utexas.edu/users/moore/acl2/)
* ACL2r -- ACL2(r) image with support for the real numbers
* ACL2-Bridge -- ACL2 (not (r)) image that runs an ACL2::Bridge server. This image is intended for educational use and automatically loads some ACL2s extensions
* ACL2-Jupyter -- A Jupyter server that supports ACL2 notebooks. This automatically includes an internal ACL2 server, so it is entirely self-contained

## LICENSE

This package is released with the same license as ACL2, the BSD 3-Clause license.
