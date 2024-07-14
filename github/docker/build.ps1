# build the image locally
$v = '2.298.2'
$imgName = 'linux-github-runner'
$img = "$($imgName):$v"
$img
docker build -t $img --build-arg RUNNER_VERSION=$v -f Dockerfile .

# test the image locally
$org = '{org}'
$url = "https://github.com/$($org)"
$pat = '***' 
$agentName='zz-linux-runner-001'
docker run -e GITHUB_URL=$url -e TOKEN=$pat -e RUNNER_NAME=$agentName $img

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
$imgName = 'linux-github-runner'
$v = '2.298.2'
$img = "$($imgName):$($v)"
docker tag $img $reg/$ns/$img
# ensure login into ACR
# docker login
docker push $reg/$ns/$img

