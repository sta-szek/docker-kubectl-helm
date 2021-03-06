FROM alpine:3.7

LABEL maintainer="Piotr Joński <p.jonski@pojo.pl>"

ENV \
    BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

RUN apk add --update ca-certificates openssl curl bash git openssh \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && mv kubectl /usr/local/bin \
    && chmod +x /usr/local/bin/kubectl \
    && curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh &> /dev/null \
    && helm init --client-only \
    && helm version --client \
    && rm /var/cache/apk/* \
    && rm -rf /tmp/*

RUN \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

COPY config /root/.kube/config

CMD bash