# check current context
kubectl config current-context

# merge AKS cluster credentials
$rg = 'zz-dev'
$aksName = 'zz-dev-aks'
az aks get-credentials -g $rg -n $aksName

# configure current context
kubectl config use-context $aksName

# create the namespace for DevOps agents
$ns = 'github'
kubectl create namespace $ns

# create secret for PAT (generate your own PAT for your org)
$pat = '***'
kubectl create secret generic github-runner-secret --from-literal=pat=$pat -n $ns

# deploy agent manifest (ensure replicas and organization are properly configured in the Yaml file)
kubectl apply -f .\deployment.yaml -n $ns

# scale deployment to N replicas
$deploymentName = 'zz-linux-runner'
$replicas = 3
kubectl scale deployment/$deploymentName --replicas=$replicas -n $ns

