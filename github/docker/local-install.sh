export TARGETARCH='x64'
export RUNNER_VERSION='2.317.0'
# Create a folder
mkdir actions-runner && cd actions-runner
# Download the latest runner package
curl -o actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz
# Optional: Validate the hash
# echo "<SHA>  actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c
# Extract the installer
tar -xf ./actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz

# Create the runner and start the configuration experience
export REPOURL='https://github.com/<user>/<repo>'
export TOKEN=''
./config.sh --url $REPOURL --token $TOKEN
# Last step, run it!
./run.sh
