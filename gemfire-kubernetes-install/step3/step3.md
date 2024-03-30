<br>

Gemfire Cluster를 설치할 Namespace를 생성합니다.
Namespace 명은 `gemfire-cluster`로 설정하였습니다.

`kubectl create namespace gemfire-cluster`{{exec}}

Kubernetes 클러스터 네임스페이스에 대한 이미지 풀 시크릿을 생성합니다.
레지스트리에서 운영자 이미지를 획득하는 데 사용될 사용자 이름(USERNAME) 및 암호(PASSWD) 자격 증명을 VMware Tanzu Network에 액세스할 수 있는 권한이 있는 값으로 설정합니다.

`kubectl create secret docker-registry image-pull-secret --namespace=gemfire-cluster --docker-server=registry.tanzu.vmware.com --docker-username='USERNAME' --docker-password='PASSWD'`

GemFireCluster를 작성합니다.

`vi gemfire-cluster.yaml`{{exec}}

```yaml
apiVersion: gemfire.vmware.com/v1
kind: GemFireCluster
metadata:
  name: gemfire
  namespace: gemfire-cluster
spec:
  image: registry.tanzu.vmware.com/pivotal-gemfire/vmware-gemfire:10.0.0
  security:
    tls: {}
  locators:
    replicas: 1
  servers:
    replicas: 1
```{{copy}}

작성한 yaml 파일을 배포합니다.

`kubectl create -f gemfire-cluster.yaml`{{exec}}

정상적으로 배포되면, 아래와 같이 출력됩니다.

`kubectl -n gemfire-cluster get all -o wide`{{exec}}

```shell
NAME                    READY   STATUS    RESTARTS   AGE     IP             NODE     NOMINATED NODE   READINESS GATES
pod/gemfire-locator-0   1/1     Running   0          4m30s   10.244.2.196   node2    <none>           <none>
pod/gemfire-server-0    1/1     Running   0          48s     10.244.1.29    node1    <none>           <none>
pod/gemfire-server-1    0/1     Pending   0          48s     <none>         <none>   <none>           <none>

NAME                        TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                       AGE     SELECTOR
service/gemfire-locator     ClusterIP   None         <none>        10334/TCP,7070/TCP,4321/TCP   4m30s   gemfire.vmware.com/app=gemfire-locator
service/gemfire-locator-0   ClusterIP   None         <none>        10334/TCP,7070/TCP,4321/TCP   4m30s   statefulset.kubernetes.io/pod-name=gemfire-locator-0
service/gemfire-server      ClusterIP   None         <none>        40404/TCP,7070/TCP,4321/TCP   49s     gemfire.vmware.com/app=gemfire-server
service/gemfire-server-0    ClusterIP   None         <none>        40404/TCP,7070/TCP,4321/TCP   49s     statefulset.kubernetes.io/pod-name=gemfire-server-0
service/gemfire-server-1    ClusterIP   None         <none>        40404/TCP,7070/TCP,4321/TCP   49s     statefulset.kubernetes.io/pod-name=gemfire-server-1

NAME                               READY   AGE     CONTAINERS   IMAGES
statefulset.apps/gemfire-locator   1/1     4m30s   locator      registry.tanzu.vmware.com/pivotal-gemfire/vmware-gemfire:10.0.0
statefulset.apps/gemfire-server    1/2     48s     server       registry.tanzu.vmware.com/pivotal-gemfire/vmware-gemfire:10.0.0
```