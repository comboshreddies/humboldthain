#!/bin/bash
set -eEu

EXIT_CODE=0
PROJECT_NAME=$(make project-name)
GO_FILE=$(make go-file)
DOCKER_TAG=$(make docker-tag)

DOCKER_NAME=${PROJECT_NAME}-${GO_FILE}

trap "docker stop ${DOCKER_NAME}; exit ${EXIT_CODE}" ERR 

set +eE
docker stop ${DOCKER_NAME} || true
set -eE 

CURL_HOST=${1:-localhost}

do_test() {
    EXIT_CODE=0
    
    EXPECTED="Hello Stranger"
    URL="${CURL_HOST}:${CURL_PORT}/helloworld"
    echo testing $URL
    RESP1=$(curl -s -m 10 "$URL")
    if [ "$RESP1" != "$EXPECTED" ]; then
    	echo test 1 failed 
    	echo expected $EXPECTED
    	echo got $RESP1
    	EXIT_CODE=1
    else
    	echo test 1 OK, $RESP1, $EXPECTED
    fi
    
    EXPECTED="Hello Ab Cd Ef"
    URL="${CURL_HOST}:${CURL_PORT}/helloworld?name=AbCdEf"
    echo testing "$URL"
    RESP2=$(curl -s -m 10 "$URL")
    if [ "$RESP2" != "$EXPECTED" ]; then
    	echo test 2 failed 
    	echo expected $EXPECTED
    	echo got $RESP2
    	EXIT_CODE=$((EXIT_CODE + 2 ))
    else
    	echo test 2 OK, $RESP2, $EXPECTED
    fi
    
    EXPECTED='{"github_hash":"'"$(git rev-parse HEAD)"'","project_name":"humboldthain"}'
    URL="${CURL_HOST}:${CURL_PORT}/versionz"
    echo testing "$URL"
    RESP3=$(curl -s -m 10 "$URL")
    if [ "$RESP3" != "$EXPECTED" ]; then
    	echo test 3 failed 
    	echo expected $EXPECTED 
    	echo got $RESP3
    	EXIT_CODE=$((EXIT_CODE + 4 ))
    else
    	echo test 3 OK, $RESP3, $EXPECTED
    fi
}


echo "---------------------------------"
echo run with default setup port 8080
DOCKER_PORT_PASS=8080
DOCKER_ENV_PORT=8080
CURL_PORT=8080

docker run --rm -u 1000:1000 -d \
    -p ${DOCKER_PORT_PASS}:${DOCKER_PORT_PASS} \
    -e GIN_MODE=release --name ${DOCKER_NAME} ${DOCKER_TAG}
sleep 3
do_test
docker stop ${DOCKER_NAME}

echo "---------------------------------"
DOCKER_PORT_PASS=8081
DOCKER_ENV_PORT=8081
CURL_PORT=8081

echo run with env port ${DOCKER_ENV_PORT}

docker run --rm -u 1000:1000 -d \
    -p ${DOCKER_PORT_PASS}:${DOCKER_PORT_PASS} \
    -e PORT=${DOCKER_ENV_PORT} \
    -e GIN_MODE=release --name ${DOCKER_NAME} ${DOCKER_TAG}
sleep 3
do_test
docker stop ${DOCKER_NAME}

echo "---------------------------------"
DOCKER_PORT_PASS=8082
DOCKER_CLI_PORT=8082
CURL_PORT=8082

echo run with cli port ${DOCKER_CLI_PORT}

docker run --rm -u 1000:1000 -d \
    -p ${DOCKER_PORT_PASS}:${DOCKER_PORT_PASS} \
    -e GIN_MODE=release --name ${DOCKER_NAME} ${DOCKER_TAG} -port ${DOCKER_CLI_PORT}
sleep 3
do_test
docker stop ${DOCKER_NAME}

echo "---------------------------------"
DOCKER_PORT_PASS=8082
DOCKER_CLI_PORT=8082
DOCKER_ENV_PORT=8081
CURL_PORT=8082

echo run with cli port ${DOCKER_CLI_PORT} and env port ${DOCKER_ENV_PORT}

docker run --rm -u 1000:1000 -d \
    -p ${DOCKER_PORT_PASS}:${DOCKER_PORT_PASS} \
    -e PORT=${DOCKER_ENV_PORT} \
    -e GIN_MODE=release --name ${DOCKER_NAME} ${DOCKER_TAG} -port ${DOCKER_CLI_PORT}
sleep 3
do_test
docker stop ${DOCKER_NAME}


