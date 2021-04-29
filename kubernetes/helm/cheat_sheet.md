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


# Pluralsight class

### Get minikube ingress running and other stuff

- Start minikube using `minikube start --vm-driver virtualbox`
- `k get ingress` get the Address
- `sudo nano /etc/hosts` add the ingress names `frontend.minikube.local 123.0.0.5`
- `minikube addons enable ingress`
- Setup official helm repo `helm repo add stable https://charts.helm.sh/stable`


## General

Repository: https://github.com/phcollignon/helm3 
- Helm Charts are the packages that I install/upgrade using helm
- Helm Charts are installed atomic
- Helm stores version information from the manifest as secrets in K8s

3-way merge
- Does 3-way comparison between old chart, new chart and live state in K8s and updates as good as possible
- This is useful if you want to update helm chart version, but did stuff with kubectl on the cluster

Helm3
- No longer depending on Tiller and instead directly talks to the K8s REST API
- Tiller: Pod that helm is communicating with and that does all the configuration/updates

k get pod ingress-nginx-admission-create-k6xt2 -o yaml -n kube-system


## Chart structure 

```bash 
chart-name/
|- crd/                 # can contain CRDs 
|- Chart.yaml           # metadata can contain dependencies
|- README.md            # docs
|- charts/
|  |- mongodb.tgz       # dependency (alternative uncompressed chart folders)
|- requirements         # dependency (helm 2)
|- templates/
| |- file.yaml
| |- _helpers.tpl       # helper functions
| |- NOTES.txt          # instructions for user. Can be templated
|- values.yaml
|- values.schema.json   # defines schema of values file
|- .helmignore          # tell helm to ignore files
```

## definition
- **Chart**: Definition of application
- **Release**: Installed Chart in cluster/Chart instance
- **Revision**: An update to a Release, by updating the local files. An update to a running release
- **Version**: A change in the charts file structure (e.g. by adding new yamls). Version tracked in Chart.yaml
- **helm upgrade**: Upgrades Installed release to the next revision
- **Umbrella chart**: Chart consisting out of multiple charts

## Updating an application

- Make changes in yamls
- Update the `appVersion` in the `Charts.yaml` file
- `helm list` to get the name of the release
- `helm upgrade <release-name> <chart>`
- `helm status <release-name>` check if the release was updated to the next revision

## Rollback

- `helm history <release-name>`
- `helm rollback <release-name> <history-id>`

## Templating

Helm templating uses [Go templating](https://golang.org/pkg/text/template/).

https://stackoverflow.com/questions/67304643/if-value-exist-loop-over-it

- Overwrite values from `values.yaml` with `helm instsall -set service.label[0]=bar` for an array
- Helm also has build in variables like the `{{ .Release.Name }}`. Good to make Releases independent from each other
- You can also import data from a file
- In an **umbrella chart** each sub-chart will have its own `values.yaml` file. The parent chart can overwrite the values from the child chart using `child_chart_name.path.to.value`
- You can see the values helm generates using `helm get all`
- In an **umbrella chart** `{{ .Values.global.some_value }}` if defined in the parent chart, can be accessed in the child charts
- Test how a manifest would look like using `helm template <chart-name>` and `helm install --dryrun --debug`

### Functions and logic

- Syntax
  - Function syntax: `default default_val value`
  - Pipeline syntax: `value | default default_value`
- List of available functions
  - [Go template package](https://golang.org/pkg/text/template/)
  - [Spring functions project](http://masterminds.github.io/sprig/)
  - [Helm project](https://helm.sh/docs/chart_template_guide/function_list/#logic-and-flow-control-functions) 


- Example funcs 
  - `value | trunc 63` truncate to first 63 letters
  - `value | trimSuffix -` to remove trailing `-` 
  - `printf "some-%s" .Values.val` to print formatted string

- Logic
  - `{{- if and .adminEmail (or .account .otherThing)}}`
  - There are also other functions, e.g. `le` or `gt` for less/equal then or greater then

### With 

- Move to a different scope

```yaml
spec:
    type: {{ .Values.a.b.c }}
    other: {{ .Values.a.b.d }}
```

equivalent to 

```yaml
spec:
    {{ with .Values.a.b }}
    type: {{ .c }}
    other: {{ .d }}
    {{ end }}
```

### White space

- `-` removes all whitespace and ⏎ before/after a line

```yaml
spec:
    {{ with .Values.a.b }}  # Generates extra lines
    type: {{ .c }}
    other: {{ .d }}
    {{ end }}               # Generates extra lines
```

alternative 

```yaml
spec: ⏎
    {{ with .Values.a.b -}} ⏎ # removes return to right
    type: {{ .c }} ⏎
    other: {{ .d }} ⏎
    {{- end }}                # removes return of prev line
```

- Change indentation using `{{ .Values.Something | indent 5 }}` to indent by 5 spaces

### Variables

- Use variables to get parent scope within a loop or with statement

```yaml
{{- $root := . -}}
{{- range $i, $zoneInfo := $root.a.b.c }}

{{- end}}
```

### Helper functions

- Located in `_helpers.tpl`

```yaml
{{- define "myChart.Function" }} # name should be unique, because function is global
# code of the helper snippet
{{- printf "%s-%s" "someValue" "otherValue" }}
{{- end }}
```

- Use with `{{ include myChart.Function . }}`