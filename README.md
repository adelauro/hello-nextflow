# hello-nextflow
kubectl create role nextflow-runner --verb=get --verb=list --verb=watch --verb=create --verb=update --verb=patch --verb=delete --resource=pods/status,pods,services,deployments --namespace=default
kubectl create serviceaccount nextflow-runner
kubectl create rolebinding nextflow-runner-binding --role=nextflow-runner --serviceaccount=default:nextflow-runner --namespace=default

KUBECONFIG=~/.kube/iapdev-use1-bpe-tes-blue ./launch.sh kuberun https://github.com/adelauro/hello-nextflow -r main -v nextflow-pvc:/mount/path
