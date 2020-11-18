
- [1. docker_cheat_sheet](#1-docker_cheat_sheet)
  - [1.1. Docker build sheet cheat](#11-docker-build-sheet-cheat)
  - [1.2. Helpful Docker commands](#12-helpful-docker-commands)

https://github.com/veggiemonk/awesome-docker
https://github.com/wsargent/docker-cheat-sheet
https://github.com/amirkdv/dockergen
https://gist.github.com/dchapkine/8423980
https://www.youtube.com/watch?v=b1RsNXGLuUk&t=1224s&ab_channel=GOTOConferences
  Squash - attach a debugger to a running container https://github.com/solo-io/squash
  Stern - steam logs from multiple pods at same time https://github.com/wercker/stern
  inlets - expose local cluster to internet https://github.com/inlets/inlets
  ksync - sync local files with files in cluster
  kubefwd - forward cluster ip from cluster to localhost
  okteto & telepresense - rout network traffic from cluster via local machine

https://landscape.cncf.io/  

# 1. docker_cheat_sheet

## 1.1. Docker build sheet cheat

`Dockerfiles/` contains multiple Dockerfile recipes. Build any of these recipes using `docker build --file Dockerfiles/name-of-dockerfile`.  

For example: To play with a conditional Dockerfile, use `docker build --file Dockerfiles/Dockerfile-conditional --build-arg my_arg=1 .`

## 1.2. Helpful Docker commands

`Dockercommands/` contains a few helpful docker commands, together with a brief explanation of each command. If you are using VS Code, you can also just use these commands via `.vscode/tasks.json`. Run `Ctrl + Shift + P`, `Tasks: Run Task`, search for a tasks that starts with `docker: ...`. 

`Dockercompose/` contains simple compose files with a few helpful comments to get you started.
