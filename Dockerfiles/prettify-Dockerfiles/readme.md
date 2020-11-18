# Prettify Dockerfile

Prettify your Dockerfiles using a Docker container. This container is based on [dockfmt](https://github.com/jessfraz/dockfmt). 

## Usage

Build is via 

```
docker build -t dockerpretty .
```

Use via 

```
docker run --rm -v $PWD:/src dockerpretty
```

where `$PWD` is your source dir containing the Dockerfiles you want to prettify. All Dockerfiles in the repository will be read, formatted and 
written to `<ORIGINAL_DOCKERFILE_NAME>.clean`. 
