# Helper

Helper is intended to contain formatters and other helpful tools

## Build all stages

Prettifies your dockerfiles using [dockfmt](https://github.com/jessfraz/dockfmt). 

```
docker build -t helper:dockerpretty --target dockerpretty .
docker build -t helper:dockerpretty --target bashpretty .
```

## Usage dockerpretty

**Build** is via 

```
docker build -t helper:dockerpretty --target dockerpretty .
```

**Use** via 

```
docker run --rm -v $PWD:/src helper:dockerpretty
```

where `$PWD` is your source dir containing the Dockerfiles you want to prettify. All Dockerfiles in the repository will be read, formatted and 
written to `<ORIGINAL_DOCKERFILE_NAME>.clean`. 


# Usage bashpretty

Prettifies your bash files using [beautysh](https://github.com/lovesegfault/beautysh).

**Build** is via 

```
docker build -t helper:bashpretty --target bashpretty .
```

**Use** via 

```
docker run --rm -v $PWD:/src helper:bashpretty
```

where `$PWD` is your source dir containing the bash files you want to prettify. All files ending with `.sh` will be prettified.
