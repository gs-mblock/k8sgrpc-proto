FROM makeblock/alpine

ARG tmp_api_version=default_value
ENV API_VERSION=$tmp_api_version

ADD ./build /k8sgrpcsv/

WORKDIR /k8sgrpcsv

EXPOSE 7000
EXPOSE 3001
EXPOSE 80

CMD ["./main"]