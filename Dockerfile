FROM publysher/alpine-numpy:1.14.0-python3.6-alpine3.7

RUN apk --no-cache add lapack libstdc++     && apk --no-cache add --virtual .builddeps g++ gcc gfortran musl-dev lapack-dev     && pip install scipy==1.0.0     && apk del .builddeps     && rm -rf /root/.cache
