Basepath=$(cd `dirname $0`; pwd)
#echo ${Basepath}
echo "---start---"
##############################

# demo
cd ${Basepath}/demo
protoc --go_out=plugins=grpc:. demo.proto

# user
cd ${Basepath}/user
protoc --go_out=plugins=grpc:. user.proto

# 
echo "---finish---"
# end