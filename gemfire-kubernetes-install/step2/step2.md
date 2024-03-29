<br>

GemFire Cluster Operator를 설치할 Namespace를 생성합니다.

`kubectl create namespace gemfire-system`

Kubernetes 클러스터 네임스페이스에 대한 이미지 풀 시크릿을 생성합니다.
레지스트리에서 운영자 이미지를 획득하는 데 사용될 사용자 이름(USERNAME) 및 암호(PASSWD) 자격 증명을 VMware Tanzu Network에 액세스할 수 있는 권한이 있는 값으로 설정합니다.

`kubectl create secret docker-registry image-pull-secret --namespace=gemfire-system --docker-server=registry.tanzu.vmware.com --docker-username='USERNAME' --docker-password='PASSWD'`

Gemfire Cluster Operator 설치를 완료하기 위해 `Helm`이나 `Carvel`을 이용할 수 있는데 이 문서에서는 `Helm`을 이용해 설치하는 방법을 설명합니다.

Helm이 설치되어 있지 않은 경우 아래와 같이 설치를 진행합니다.

`curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3`

`chmod 700 get_helm.sh`

`./get_helm.s`

설치가 정상적으로 됐는지 버전을 확인합니다.

`helm version`

Helm에 `registry.tanzu.vmware.com` 의 인증 정보를 등록합니다.

`helm registry login -u 'USERNAME' registry.tanzu.vmware.com`

Helm을 통해 CRD(Custom Resource Definition) 및 GemFire Cluster Operator를 설치합니다.
Cert Manager가 `cert-manager` Namespace가 아닌 곳에 설치된 경우 helm install 명령에 `--set certManagerNamespace=<namespace>`를 추가하여 해당 네임스페이스를 지정합니다.

CRD 설치는 아래 명령어를 입력합니다.

`helm install gemfire-crd oci://registry.tanzu.vmware.com/tanzu-gemfire-for-kubernetes/gemfire-crd --version 2.3.0 --namespace gemfire-system --set operatorReleaseName=gemfire-operator --plain-http`

정상적으로 설치 시 아래와 같이 출력됩니다.

```shell
Pulled: registry.tanzu.vmware.com/tanzu-gemfire-for-kubernetes/gemfire-crd:2.3.0
Digest: sha256:3ded4f8ff3490717a7d05363670336bf0d1ba771602ff57f18d744823e60d9d7
NAME: gemfire-crd
LAST DEPLOYED: Thu Dec  7 20:47:59 2023
NAMESPACE: gemfire-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

Operator 설치는 아래 명령어를 입력합니다.

`helm install gemfire-operator oci://registry.tanzu.vmware.com/tanzu-gemfire-for-kubernetes/gemfire-operator --version 2.3.0 --namespace gemfire-system --plain-http`

정상적으로 설치 시 아래와 같이 출력됩니다.

```shell
Pulled: registry.tanzu.vmware.com/tanzu-gemfire-for-kubernetes/gemfire-operator:2.3.0
Digest: sha256:33493c9a756e5a8b7c7aa550ac963c2124adc1eb09b45abe5e37a5a25e392d03
NAME: gemfire-operator
LAST DEPLOYED: Thu Dec  7 20:55:01 2023
NAMESPACE: gemfire-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

VMware GemFire CRD 와 Gemfire Cluster Operator가 성공적으로 배포되었는지 확인합니다

`kubectl get crd gemfireclusters.gemfire.vmware.com`

VMware GemFire CRD가 정상적으로 배포되면, 아래와 같이 출력됩니다.

```shell
NAME                                 CREATED AT
gemfireclusters.gemfire.vmware.com   yyyy-MM-ddTHH:mm:ssZ
```

`kubectl get pods --namespace gemfire-system`

Gemfire Cluster Operator가 정상적으로 배포되면, 아래와 같이 출력됩니다.

```shell
NAME                                                  READY   STATUS    RESTARTS   AGE
gemfire-operator-controller-manager-xxxxxxxxx-xxxxx   1/1     Running   0          ##m
```