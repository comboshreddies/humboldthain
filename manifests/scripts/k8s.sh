#!/bin/bash
set -x

source /root/setup.sh

NAMESPACE=go03
ls /
ls /manifests
ls /manifests/K8s

cd /manifests/K8s

if [ "$1" == "deploy" ] ; then
	LIST=$(ls *.yaml | sort -n)
	for i in $LIST ; do
	   echo apply $i
	   kubectl apply -f $i
	done

        kubectl -n $NAMESPACE get all
fi

if [ "$1" == "delete" ] ; then
	LIST=$(ls *.yaml | sort -nr)
	for i in $LIST ; do
	   echo deleting $i
	   kubectl delete -f $i
	done

        kubectl -n $NAMESPACE get all
fi

if [ "$1" == "getAll" ] ; then
        kubectl -n $NAMESPACE get all
fi


