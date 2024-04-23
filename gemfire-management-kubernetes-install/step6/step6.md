<br>

#### Namespace 생성

`kubectl create namespace gemfire-management-console`{{exec}}

#### ImagePullSecret 생성

`kubectl create secret docker-registry image-pull-secret --namespace=gemfire-management-console --docker-server=registry.tanzu.vmware.com --docker-username='USERNAME' --docker-password='PASSWD'`

#### StatefulSet 생성

`vi gmc-deployment.yaml`{{exec}}

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gemfire-management-console
  namespace: gemfire-management-console
  labels:
    app: gemfire-management-console
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gemfire-management-console
  template:
    metadata:
      labels:
        app: gemfire-management-console
    spec:
      containers:
      - name: gemfire-management-console
        image: registry.tanzu.vmware.com/gemfire-management-console/gemfire-management-console:1.1.1
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: data-volume
          mountPath: /opt/gemfire/VMware_GemFire_Management_Console/diskStore
      imagePullSecrets:
      - name: image-pull-secret
      volumes:
        - name: data-volume
          emptyDir: {}
```{{copy}}

#### Service 생성

`vi gmc-service.yaml`{{exec}}

```yaml
apiVersion: v1
kind: Service
metadata:
  name: gemfire-management-console
  namespace: gemfire-management-console
spec:
  selector:
    app: gemfire-management-console
  ports:
  - name: http
    port: 8080
    targetPort: 8080
  type: ClusterIP 
```{{copy}}

배포 완료 시 아래와 같습니다.

`kubectl -n gemfire-management-console get all -o wide`{{exec}}

```shell
NAME                                              READY   STATUS    RESTARTS   AGE     IP             NODE     NOMINATED NODE   READINESS GATES
pod/gemfire-management-console-6bb9f99f9c-x4fzq   1/1     Running   0          2m12s   192.168.1.10   node01   <none>           <none>

NAME                                 TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE   SELECTOR
service/gemfire-management-console   NodePort   10.99.17.82   <none>        8080:31418/TCP   7s    app=gemfire-management-console

NAME                                         READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS                   IMAGES                                                                                  SELECTOR
deployment.apps/gemfire-management-console   1/1     1            1           2m12s   gemfire-management-console   registry.tanzu.vmware.com/gemfire-management-console/gemfire-management-console:1.1.1   app=gemfire-management-console

NAME                                                    DESIRED   CURRENT   READY   AGE     CONTAINERS                   IMAGES                                                                                  SELECTOR
replicaset.apps/gemfire-management-console-6bb9f99f9c   1         1         1       2m12s   gemfire-management-console   registry.tanzu.vmware.com/gemfire-management-console/gemfire-management-console:1.1.1   app=gemfire-management-console,pod-template-hash=6bb9f99f9c
```