
# cd deploy && sh docker-build.sh 
# sh docker-build.sh


Number=v1.0.0

Mypassword=1234qwer
Myusername=liam1803

Versionhub=liam1803/k8sgrpcsv:${Number}
# ali
#Versionali=registry.cn-hangzhou.aliyuncs.com/makeblock/k8shtml:${Number}

Basepath=$(cd `dirname $0`; pwd)

cd ${Basepath}/docker

rm -rf ./build
mkdir ./build
mkdir ./build/log
#cp ../../configs/application.toml ./build/configs/

#CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./build/main ../../main.go
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-w -s' -o ./build/main ../../main.go 

# rm
docker rmi ${Versionhub}
#docker rmi ${Versionali}

docker build -t ${Versionhub} -f Dockerfile .

# hub
docker login --username=${Myusername} -p ${Mypassword}
docker push ${Versionhub}

# ali
# docker tag ${Versionhub} ${Versionali}
# docker login --username=makeblockcom -p P@ssw0rdmakeblock registry.cn-hangzhou.aliyuncs.com
# docker push ${Versionali}

docker rmi ${Versionhub}
# docker rmi ${Versionali}

cd ../
