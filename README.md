# hello-nextflow
kubectl create namespace nextflow

kubectl create role nextflow-runner \
--verb=get --verb=list --verb=watch --verb=create --verb=update --verb=patch --verb=delete \
--resource=pods/status,pods,services,deployments \
--namespace=nextflow

kubectl create serviceaccount nextflow-runner

kubectl create rolebinding nextflow-runner-binding --role=nextflow-runner \
--serviceaccount=nextflow-runner --namespace=nextflow

kubectl create serviceaccount  nextflow-runner --namespace=nextflow
