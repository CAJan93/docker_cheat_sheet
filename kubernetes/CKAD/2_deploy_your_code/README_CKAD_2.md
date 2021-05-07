- [1. Kubectl `apply`](#1-kubectl-apply)
  - [1.1. What is the difference between `apply` and `create`?](#11-what-is-the-difference-between-apply-and-create)
  - [1.2. How does K8s know what to update when running `k apply`?](#12-how-does-k8s-know-what-to-update-when-running-k-apply)
- [2. Deployments](#2-deployments)
  - [2.1. Scale a deployment](#21-scale-a-deployment)
  - [2.2. Kinds of deployments](#22-kinds-of-deployments)
    - [2.2.1. What different versions of deployments/updates are there?](#221-what-different-versions-of-deploymentsupdates-are-there)
    - [2.2.2. When doing a rolling update, how can I slow down this process X](#222-when-doing-a-rolling-update-how-can-i-slow-down-this-process-x)
    - [2.2.3. What do `maxSurge` and `maxUnavailable` do in a rolling update?](#223-what-do-maxsurge-and-maxunavailable-do-in-a-rolling-update)
    - [2.2.4. How do services tie in with canary deployments?](#224-how-do-services-tie-in-with-canary-deployments)
  - [2.3. Blue-green deployment basics](#23-blue-green-deployment-basics)
    - [2.3.1. How do you setup a blue-green deployment](#231-how-do-you-setup-a-blue-green-deployment)
  - [2.4. How can I see how my `local file` is different from `live object`?](#24-how-can-i-see-how-my-local-file-is-different-from-live-object)
  - [2.5. How do you monitor the progress of a deployment update? X](#25-how-do-you-monitor-the-progress-of-a-deployment-update-x)
  - [2.6. How do you rollback a deployment rollout? X](#26-how-do-you-rollback-a-deployment-rollout-x)
  - [2.7. How do you save a deployment to your history? X](#27-how-do-you-save-a-deployment-to-your-history-x)
- [Jobs](#jobs)
  - [How do you define if a job should restart on fail? X](#how-do-you-define-if-a-job-should-restart-on-fail-x)
- [Cronjob](#cronjob)
  - [Cron format](#cron-format)
  - [Decide if two of the same cronjobs can run at the same time](#decide-if-two-of-the-same-cronjobs-can-run-at-the-same-time)
- [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)
  - [Install Prometheus and Grafana](#install-prometheus-and-grafana)

# 1. Kubectl `apply`

## 1.1. What is the difference between `apply` and `create`?

- `apply` will update the yaml if it is already exists
- `create` will throw and error if it already exists
- `create` is imperative, just like `replace`. `apply` is declarative. This is because `apply` saves the `last applied configuration`


## 1.2. How does K8s know what to update when running `k apply`? 

- There are three things to compare
  - The `live object` living in K8s (see `k get deployment <name> -o yaml`)
  - The `local file` that you want to `apply`
  - The `last applied configuration` file in the metadata of the deployment
- Field `f` will be ignored during apply if
  - `f` in `live object` AND
  - `f` not in `local file` AND
  - `f` not in `last applied configuration`
- Field `f` will be added during apply if
  - `f` in `local file` AND 
  - `f` not in `live object`
- Filed `f` will be removed during apply if
  - `f` in `last applied configuration`
  - `f` not in `local file`
- `Last applied configuration` and `live object` can be different, since you can update the `live object` without applying (e.g. manually using `kubectl` or with a mutating web hook)
- Apply autoamtically `saves` config. With `create` you need to pass a param to do this
- Be aware that the performed action may vary, based on the type of field. E.g. Strings will be replaced, but maps will be merged
# 2. Deployments

## 2.1. Scale a deployment

- Update the yaml in `Deployment.spec.replicas`
- Use `k scale --replicas=3 <name>`

## 2.2. Kinds of deployments

### 2.2.1. What different versions of deployments/updates are there?

- rolling update
  - Gradually change old version to new version, by replacing pods
- Blue-greed deployment
  - Run both versions simultaneously
  - Switch over to the new service all at once after you tested it
  - Ideally use feature toggles to turn of the new feature if necessary
- Canary deployment
  - From the canary in the cole mine: Test stuff, before you rely on it
  - Small subset of pods is new version
  - If there is a problem it will only affect small number of users



### 2.2.2. When doing a rolling update, how can I slow down this process X

- Usually one of the old pods is deleted as soon as the new one is up
- Use `.spec.MinReadySeconds` to tell K8s that it should wait for seconds until the new pod is considered up
  - You may need to set `.spec.progressDeadlineSeconds`. Deployment will abort if it does not receive 
- You could also do this with probes


### 2.2.3. What do `maxSurge` and `maxUnavailable` do in a rolling update? 

- `.spec.Strategy.rollingUpdate.maxSurge` says that at most x number of pods **more** should be there than there are defined in `.spec.replicas`. This includes old and new version pods
- `.spec.Strategy.rollingUpdate.maxUnavailable` says that at most x number of pods **less** should be there than there are defined in `.spec.replicas`


### 2.2.4. How do services tie in with canary deployments?

- Canary deployment has two versions of your app run in parallel
- You want your service to primarily rout to the stable version and only occasionally route to the canary version
- The service is not aware of this. The service round-robins to the pods that match its selectors
- You have a stable and a canary deployment with different replicas
- Stable.replicas > canary.replicas
- This way you primarily route to stable


## 2.3. Blue-green deployment basics

- Check the feasibility of a deployment before it is publicly available
- You have both services running simultaneously
- New version is for internal use only
- You switch over to new version all at once
- Both old and new versions are just like they are in production
- Blue is Old/stable
- Green is new/unstable
- Both blue and green run in production. Be aware that this may impact green, if not enough resources

### 2.3.1. How do you setup a blue-green deployment

- Two services, two deployments
- Green service exported on different port
- Once you are sure that the green deployment is good, you remove the blue service/deployment and make the green one public
- You can also have a test-service, which is not publicly available and points to blue. You use a port != 80 for testing if this is a web app
- Switch in practice works by having two deployments run in parallel. On your public service, you simply change the selector from green to blue to switch over

## 2.4. How can I see how my `local file` is different from `live object`? 

- `k diff -f <file.yaml>`


## 2.5. How do you monitor the progress of a deployment update? X

- `k rollout status deployment <name>`

## 2.6. How do you rollback a deployment rollout? X

- You first need to save deployments `k apply -f <file.yaml> --record`
- Use `k rollout status <name>` to view rollout status
  - Use `k rollout history deployment <name> --revision=<number>` to look into a revision
- `k rollout history deployment <name>` Get all revisions from this deployment
  - Or do this via `k rollout history -f <file.yaml>`
- Look into a specific revision in the history `k rollout history deployment <name> --revision=1`
- Rollback using `k rollout undo deployment <name> --to-revision=1`


## 2.7. How do you save a deployment to your history? X

- `k apply -f <file.yaml> --record`


# Jobs

- Definition: Tasks that run one time
- Job can spawn multiple number of pods

## How do you define if a job should restart on fail? X

- `spec.spec.restartPolicy`

# Cronjob

- Creates job based on a schedule

## Cron format

```
* * * * *
| | | | |
| | | | day of week (0 - 6), 0 is Sunday
| | | |
| | | month (1 - 12)
| | |
| | day of month (1 - 31)
| |
| hour(0 - 23)
|
min(0 - 59)
```

- 23:30 every monday `30 23 * * 1`
- One min after midnight first day of month `1 0 1 * *`
- Every hour `0 * * * *`
- Every minute `/1 * * * *`
  - `/` is a step value

For more examples see [crontab guru](https://crontab.guru)

## Decide if two of the same cronjobs can run at the same time

- `spec.concurrencyPolicy`
- Possible values are `Allow`, `Forbid` or `Replace` (replace old job with new job)


# Monitoring and Troubleshooting

## Install Prometheus and Grafana

- View Grafana Dashboards [here](https://grafana.com/grafana/dashboards)

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create ns prom
helm install prometheus prometheus-community/kube-prometheus-stack -n prom
```

Access prometheus `kubectl port-forward -n prom prometheus-prom-kube-prometheus-stack-prometheus-0 9090`

Access Grafana `kubectl port-forward -n prom prom-grafana-6c578f9954-rjdmk 3000`
admin prom-operator

Uninstall `helm uninstall prom -n prom`

Connect influxDB

Install influxDB

Connect via cm `k get cm prometheus-kube-prometheus-grafana-datasource -n prom  -o yaml > tmp.yaml`


```yaml
    - name: influx
      type: influxdb
      url: http://my-release-influxdb.default.svc.cluster.local:8086/api/v2/query
      jsonData:
        editable: false
        version: Flux
        defaultBucket: covid19
        organization: non-empty
      secureJsonData:
        token: admin:<pwd>
```

Get pwd via `export INFLUXDB_ADMIN_PASSWORD=$(kubectl get secret --namespace default my-release-influxdb -o jsonpath="{.data.admin-user-password}" | base64 --decode)`
