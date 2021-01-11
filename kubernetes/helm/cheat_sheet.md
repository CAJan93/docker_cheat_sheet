# Helm

[Cheat Sheet](https://gist.github.com/tuannvm/4e1bcc993f683ee275ed36e67c30ac49)


## installing

- Provide custom values file `helm install myrealease ./myapp -f custom.yaml`

- using individual key-value pairs `helm install myrelease ./myapp --set some.key=val`

- Advanced `helm install myrelease ./myapp -f staging.yaml -f other_file.yaml --set some.key=val`

- Uninstall `helm delete myrelease`


## status

- get status of installation `helm status`

- list everything that was installed with helm `helm list`

- Upgrade release  `helm upgrade myrelease ./myapp --set some.key=newVal`

- rollback to an old revision `helm rollback myrelease 1`
