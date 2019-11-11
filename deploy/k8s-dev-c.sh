# 这文档是手工操作的，没了解 k8s的不要用
# chmod 777 ./k8s-test.sh
# ./k8s-test.sh

# 当不存在此 namespace 时：
# kubectl create namespace dev-mblock
# kubectl label namespace dev-mblock istio-injection=enabled


Basepath=$(cd `dirname $0`; pwd)
echo ${Basepath}

# 换环境
cd ~/.kube
cp -p ${Basepath}/config/config-aliy-test-dev ./config


# 发布

#kustomize build ${Basepath}/kubernetes/overlays/dev
#kustomize build ${Basepath}/kubernetes/overlays/dev | kubectl apply -f -

# other
cd ${Basepath} 
APP_NAME=`node -p "require('../package.json').name"`
APP_VERSION=`node -p "require('../package.json').version"`
IMAGE_PREFIX="liam1803/${APP_NAME}:v${APP_VERSION}"
NewImage="${APP_NAME}=${IMAGE_PREFIX}"
echo ${NewImage}

cd ${Basepath}/kubernetes/base
#kustomize edit set image mbcontentplatform=registry.cn-hangzhou.aliyuncs.com/makeblock/mbcontentplatform:1.29.3
kustomize edit set image $NewImage
#kustomize build ${Basepath}/kubernetes/overlays/dev
kustomize build ${Basepath}/kubernetes/overlays/dev | kubectl apply -f -
