#!/bin/sh

kubectl delete -f ui-service.yaml
kubectl delete -f ui.yaml
kubectl delete -f php-service.yaml
kubectl delete -f php.yaml
kubectl delete -f mysql-service.yaml
kubectl delete -f mysql.yaml
kubectl delete -f dbclaim.yaml
kubectl delete -f dbinit.yaml
kubectl delete -f pv.yaml

