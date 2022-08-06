#!/bin/bash
set -eu

trap "make docker-stop-release" EXIT

CURLHOST=${1:-localhost}

make docker-run-release

sleep 3

EXITCODE=0

EXPECTED="Hello Stranger"
RESP1=$(curl -s ${CURLHOST}:8080/helloworld)
if [ "$RESP1" != "$EXPECTED" ]; then
	echo test 1 failed 
	echo expected $EXPECTED
	echo got $RESP1
	EXITCODE=1
else
	echo test 1 OK
fi

EXPECTED="Hello Ab Cd Ef"
RESP2=$(curl -s ${CURLHOST}:8080/helloworld?name=AbCdEf)
if [ "$RESP2" != "$EXPECTED" ]; then
	echo test 2 failed 
	echo expected $EXPECTED
	echo got $RESP2
	EXITCODE=$((EXITCODE + 2 ))
else
	echo test 2 OK
fi

EXPECTED='{"github_hash":"'"$(git rev-parse HEAD)"'","project_name":"humboldthain"}'
RESP3=$(curl -s ${CURLHOST}:8080/versionz)
if [ "$RESP3" != "$EXPECTED" ]; then
	echo test 3 failed 
	echo expected $EXPECTED 
	echo got $RESP3
	EXITCODE=$((EXITCODE + 4 ))
else
	echo test 3 OK
fi

exit $EXITCODE

