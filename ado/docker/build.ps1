# use this url to get the latest version; replace {org} with your Azure DevOps organisation
# https://dev.azure.com/{org}/_apis/distributedtask/packages/agent?$top=1

# build the image locally
$v = '2.211.0'
$imgName = 'linux-devops-agent'
$img = "$($imgName):$v"
$img
docker build -t $img --build-arg AGENT_VERSION=$v -f Dockerfile .

# test the image locally
$org = '{org}'
$url = "https://dev.azure.com/$($org)"
$pat = '***' 
$agentName='zz-linux-agent-001'
docker run -e AZP_URL=$url -e AZP_TOKEN=$pat -e AZP_AGENT_NAME=$agentName $img

# deploy into private Azure Container Registry
$acrName = 'zzacr'
$acr = "$acrName.azurecr.io"
$ns = 'devops'
docker tag $img $acr/$ns/$img
# ensure login into ACR
# az acr login -n $acrName
docker push $acr/$ns/$img

# deploy into docker public registry
$regName = 'docker'
$reg = "$regName.io"
$ns = 'daradu'
$imgName = 'linux-devops-agent'
$v = '2.211.0'
$img = "$($imgName):$($v)"
docker tag $img $reg/$ns/$img
# ensure login into ACR
# docker login
docker push $reg/$ns/$img
