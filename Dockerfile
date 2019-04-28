FROM conda/miniconda3

ARG KUBECTL_VERSION='1.12.7/2019-03-27'
RUN     apt-get update -y
RUN     apt-get install -y   wget curl jq git bash bash-completion gcc musl-dev openssl  make groff tree vim ca-certificates less apt-transport-https 
RUN     apt-get install -y default-jdk maven

RUN     curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/$KUBECTL_VERSION/bin/linux/amd64/kubectl
RUN     curl -o kubectl.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256
RUN     openssl sha1 -sha256 kubectl
RUN     chmod +x ./kubectl
RUN     cp ./kubectl /usr/local/bin/kubectl 



# RUN     curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -
# RUN     echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list
# RUN     apt-get update
# RUN     apt-get install -y kubectl


RUN conda install -y nb_conda_kernels
RUN conda create -y -n py27 python=2.7 ipykernel
RUN conda create -y -n awscli python=3.6.3 ipykernel
RUN conda create -y -n sceptre python=3.6.3 ipykernel

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN conda init bash
RUN source /root/.bashrc && conda activate awscli && conda install -y -c conda-forge awscli && conda install -y -c conda-forge/label/gcc7 awscli && conda install -y -c conda-forge/label/cf201901 awscli
RUN source /root/.bashrc && conda activate awscli && pip install taskcat
RUN source /root/.bashrc && conda activate sceptre && pip install sceptre

RUN echo "export LC_ALL=C.UTF-8" >> /root/.bashrc
RUN echo "export LANG=C.UTF-8"   >> /root/.bashrc

ADD cheatsheets.md /root/cheatsheets.md

ADD json2yaml /usr/local/bin/json2yaml
RUN chmod +x /usr/local/bin/json2yaml

# INSTALL GO
ARG GO_VERSION=1.11.5
RUN     wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \        
        tar -xvf go$GO_VERSION.linux-amd64.tar.gz 
RUN    mv go/ /usr/local/ && mkdir /root/go_path
RUN echo 'export GOROOT=/usr/local/go' >> /root/.bashrc 
RUN echo 'export GOPATH=/root/go_path' >> /root/.bashrc
RUN echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bashrc
RUN echo 'export GOROOT_BOOTSTRAP=/usr/local/go' >> ~/.bashrc 

ENV TZ=Australia/Sydney
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# INSTALL HELM
ARG HELM_VERSION=v2.12.1
RUN curl --location https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz | tar xz -C /tmp 
RUN mv /tmp/linux-amd64/helm /usr/local/bin/ && chmod +x /usr/local/bin 
RUN helm init --client-only


ARG EKSCTL_VERSION=0.1.18

RUN curl --location "https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
RUN mv /tmp/eksctl /usr/local/bin

RUN wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator 
RUN cp -v aws-iam-authenticator /usr/local/bin/heptio-authenticator-aws && cp -v aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
RUN chmod +x /usr/local/bin/heptio-authenticator-aws && chmod +x /usr/local/bin/aws-iam-authenticator

RUN echo "source /etc/bash_completion" >> /root/.bashrc
RUN echo "complete -C '/usr/local/bin/aws_completer' aws" >> /root/.bashrc
RUN eksctl completion bash > /root/.eksctl_completion && echo "source /root/.eksctl_completion" >> /root/.bashrc 

#Install JX 
ARG JX_VERSION=v2.0.11
RUN mkdir -p ~/.jx/bin
RUN curl -L https://github.com/jenkins-x/jx/releases/download/$JX_VERSION/jx-linux-amd64.tar.gz | tar xzv -C ~/.jx/bin
RUN export PATH=$PATH:/root/.jx/bin
RUN echo 'export PATH=$PATH:/root/.jx/bin' >> /root/.bashrc
RUN echo "source <(kubectl completion bash)" >> /root/.bashrc 


RUN echo "alias k=kubectl" >> /root/.bashrc




WORKDIR "/src"
CMD /bin/bash

# RUN source activate py36

# RUN apt-get install -y vim 
