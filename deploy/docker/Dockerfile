FROM makeblock/alpine

ARG tmp_api_version=default_value
ENV API_VERSION=$tmp_api_version

ADD ./build /hellogrpc3/

WORKDIR /hellogrpc3

EXPOSE 7000

CMD ["./main"]