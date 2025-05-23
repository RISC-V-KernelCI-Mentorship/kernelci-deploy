# kci-easy

Get your own KernelCI instance up and running in no time.

## Getting started

### Prerequisites

- git
- Docker (with `compose` plugin, set up for a regular user)
- Python environment with [KernelCI core dependencies](https://github.com/kernelci/kernelci-core/blob/main/requirements.txt) installed
- expect

### Running

Change `ADMIN_PASSWORD` in the `main.cfg`, then run shell scripts from the root directory in their order.

### Mac OSX

From docker-desktop for osx 4.13 onwards the behavior for the creation of the `/var/run/docker.sock` socket changed.
To allow connections to the socket you must got to Docker Client, and then check the option under `Settings > Advanced > Allow the default Docker socket to be used (requires password)`.
