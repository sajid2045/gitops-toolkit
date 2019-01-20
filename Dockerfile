FROM python:2.7
ENV AWS_PROFILE=default
RUN pip install awscli

ARG GO_VERSION=1.11
# KUBECTL_SOURCE: Change to kubernetes-dev/ci for CI
ARG KUBECTL_SOURCE=kubernetes-release/release
ARG KUBECTL_VERSION=v1.11.5


# KUBECTL_TRACK: Currently latest from KUBECTL_SOURCE. Change to latest-1.3.txt, etc. if desired.
ARG KUBECTL_TRACK=stable.txt
# ARG EKSCTL_VERSION=0.1.18
ARG EKSCTL_VERSION=latest_release
ARG KUBECTL_ARCH=linux/amd64
ARG HELM_VERSION=v2.12.1
RUN     apt-get update 
RUN     apt-get install -y   wget curl jq git bash bash-completion gcc musl-dev openssl  make && \
        apt-get install -y  vim ca-certificates && \
        apt-get install -y less 

RUN     wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz && \        
        tar -xvf go1.10.3.linux-amd64.tar.gz 

RUN     ls -la go/
RUN     mv go /usr/local/ && mkdir /root/go_path && \
        export GOROOT=/usr/local/go && \
        export export GOPATH=/root/go_path && \
        export PATH=$GOPATH/bin:$GOROOT/bin:$PATH && \
        export GOROOT_BOOTSTRAP="$(go env GOROOT)" && \
        echo $GOROOT_BOOTSTRAP


RUN     echo "will try to get kubectl from : https://storage.googleapis.com/${KUBECTL_SOURCE}/${KUBECTL_VERSION}/bin/${KUBECTL_ARCH}/kubectl"        

RUN     curl -SsL --retry 5 "https://storage.googleapis.com/${KUBECTL_SOURCE}/${KUBECTL_VERSION}/bin/${KUBECTL_ARCH}/kubectl" > /usr/bin/kubectl && \
        chmod +x /usr/bin/kubectl 

RUN     kubectl version --client=true
        
RUN  chmod +x /usr/local/go/bin/*
ENV  PATH "$PATH:/root/go_path:/usr/local/go/bin"
ENV TZ=Australia/Sydney
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN curl --location https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz | tar xz -C /tmp 
RUN mv /tmp/linux-amd64/helm /usr/local/bin/ && chmod +x /usr/local/bin 


ARG EKSCTL_VERSION=0.1.18

RUN curl --location "https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
RUN mv /tmp/eksctl /usr/local/bin

RUN wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator && cp -v aws-iam-authenticator /usr/local/bin/heptio-authenticator-aws && cp -v aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

RUN rm -rf aws-iam-authenticator
RUN chmod +x /usr/local/bin/heptio-authenticator-aws

ADD requirements.txt /root/requirements.txt 
RUN pip install -r /root/requirements.txt 

RUN echo "source /etc/bash_completion" >> /root/.bashrc
RUN echo "complete -C '/usr/local/bin/aws_completer' aws" >> /root/.bashrc
RUN eksctl completion bash > /root/.eksctl_completion && echo "source /root/.eksctl_completion" >> /root/.bashrc 
#TODO: better way ?
RUN echo 'export GOROOT=/usr/local/go' >> /root/.bashrc 
RUN echo 'export GOPATH=/root/go_path' >> /root/.bashrc

WORKDIR "/src"

CMD /bin/bash
