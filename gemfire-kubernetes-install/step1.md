<br>

VMware Gemfire For Kubernetes를 설치하기 위한 Cert Manager를 설치합니다. Cert Manager 설치는 생략할 수 없습니다.
제공되는 cert-manager.yaml 파일을 다운로드합니다.

`wget https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml`


다운로드한 cert-manager.yaml 파일을 설치합니다.

`kubectl create -f cert-manager.yaml`
