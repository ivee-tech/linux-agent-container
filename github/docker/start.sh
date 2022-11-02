#!/bin/bash
set -e

if [ -z "$GITHUB_URL" ]; then
  echo 1>&2 "error: missing URL environment variable"
  exit 1
fi

if [ -z "$TOKEN_FILE" ]; then
  if [ -z "$TOKEN" ]; then
    echo 1>&2 "error: missing TOKEN environment variable"
    exit 1
  fi

  TOKEN_FILE=/actions-runner/.token
  echo -n $TOKEN > "$TOKEN_FILE"
fi

unset TOKEN

if [ -n "$RUNNER_WORK" ]; then
  mkdir -p "$RUNNER_WORK"
fi

export RUNNER_ALLOW_RUNASROOT="1"

cleanup() {
  if [ -e config.sh ]; then
    print_header "Cleanup. Removing GitHub runner..."

    # If the runner has some running jobs, the configuration removal process will fail.
    # So, give it some time to finish the job.
    while true; do
      ./config.sh remove --unattended --auth PAT --token $(cat "$TOKEN_FILE") && break

      echo "Retrying in 30 seconds..."
      sleep 30
    done
  fi
}

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

source ./env.sh

print_header "1. Configuring GitHub runner..."

./config.sh --unattended \
  --name "${RUNNER_NAME:-$(hostname)}" \
  --url "$GITHUB_URL" \
  --token $(cat "$TOKEN_FILE") \
  --runnergroup "${RUNNER_GROUP:-Default}" \
  --work "${RUNNER_WORK:-_work}" \
  --labels "$RUNNER_LABELS" \
  --replace  & wait $!

print_header "2. Running GitHub runner..."

trap 'cleanup; exit 0' EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# To be aware of TERM and INT signals call run.sh
# Running it with the --once flag at the end will shut down the agent after the build is executed
./run.sh "$@"