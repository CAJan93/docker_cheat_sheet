
- [1. docker_cheat_sheet](#1-docker_cheat_sheet)
  - [1.1. Docker build sheet cheat](#11-docker-build-sheet-cheat)
  - [1.2. Helpful Docker commands](#12-helpful-docker-commands)
  - [1.3 Docker tools](#13-docker-tools)
  - [1.4 Running a GUI application in Docker](#14-running-a-gui-application-in-docker)


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

## 1.3 Docker tools

For a longer list of tools, visit [awesome-docker](https://github.com/veggiemonk/awesome-docker).

[Dockerstation](https://github.com/DockStation/dockstation): A control and monitoring tool for docker.

Install via 

```
cd ~/Downloads
wget https://github.com/DockStation/dockstation/releases/download/v1.5.1/dockstation_1.5.1_amd64.deb
sudo dpkg -i  dockstation_1.5.1_amd64.deb
```

[Dive](https://github.com/wagoodman/dive): A tool for exploring a docker image, layer contents, and discovering ways to shrink the size of your Docker/OCI image.

Install and run via

```
docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e DOCKER_API_VERSION=1.37 \
    wagoodman/dive:latest help
```

Inspect an image via
```
docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e DOCKER_API_VERSION=1.37 \
    wagoodman/dive:latest <IMAGE_NAME>
```

Dive will help you to analyze what files changed in which layer of the image

Use

- Use arrows to select the layer you are interested in
- Use `Tab` to switch to the file view
- Use `Ctrl + M` to view only the files that changed
- Use `space` to expand/contract a folder

[zsh](https://github.com/ohmyzsh/ohmyzsh) with [docker plugin](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins#docker)

- Autocompletion for docker commands

## 1.4 Running a GUI application in Docker

Taken from [medium block post](https://medium.com/@SaravSun/running-gui-applications-inside-docker-containers-83d65c0db110).

A basic `Dockerile`:

```
FROM centos
RUN yum install -y <GUI_APPLICATION>
CMD ["/usr/bin/<GUI_APPLICATION>"]
```
Build and run via

```
sudo docker build -t gui-app .
sudo docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" gui-app
```