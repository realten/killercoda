<br>

설치된 pod 중 gemfire-locator-0에 접속합니다.

`kubectl -n gemfire-cluster exec -it gemfire-locator-0 -- gfsh`{{exec}}

```shell
Defaulted container "locator" out of: locator, gemfire-init (init)
    _________________________     __
   / _____/ ______/ ______/ /____/ /
  / /  __/ /___  /_____  / _____  / 
 / /__/ / ____/  _____/ / /    / /  
/______/_/      /______/_/    /_/    10.0.0

Monitor and Manage VMware GemFire
gfsh>
```

접속 후 Gemfire Cluster에 연결합니다.

`connect --locator=gemfire-locator-0.gemfire-locator.gemfire-cluster.svc.cluster.local[10334]`{{exec}}

연결 성공 시 아래와 같이 출력됩니다.

```shell
Connecting to Locator at [host=gemfire-locator-0.gemfire-locator.gemfire-cluster.svc.cluster.local, port=10334] ..
Connecting to Manager at [host=gemfire-locator-0.gemfire-locator.gemfire-cluster.svc.cluster.local, port=1099] ..
Successfully connected to: [host=gemfire-locator-0.gemfire-locator.gemfire-cluster.svc.cluster.local, port=1099]

You are connected to a cluster of version 10.0.0.

gfsh>
```