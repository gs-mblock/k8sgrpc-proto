
# chmod 777 ./k8s.sh

Basepath=$(cd `dirname $0`; pwd)

# 换环境
cd ~/.kube
cp -p ${Basepath}/../config/config-aliy-test-dev ./config

cd ${Basepath}

kubectl create namespace dev-liam-grpcsv

kubectl apply -f ./k8s -n dev-liam-grpcsv

