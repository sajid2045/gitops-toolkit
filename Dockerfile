FROM conda/miniconda3

RUN     apt-get update 
RUN     apt-get install -y   wget curl jq git bash bash-completion gcc musl-dev openssl  make groff tree ca-certificates less vim

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

# ADD requirements.txt /root/requirements.txt 
# ADD json2yaml /usr/local/bin/json2yaml
# RUN chmod +x /usr/local/bin/json2yaml
# RUN pip install -r /root/requirements.txt 


# RUN pip install --upgrade pip
# RUN pip install sceptre




# ARG GO_VERSION=1.11.5
# RUN     wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \        
#         tar -xvf go$GO_VERSION.linux-amd64.tar.gz 
# RUN     ls -la go/
# RUN     mv go /usr/local/ && mkdir /root/go_path && \
#         echo export GOROOT=/usr/local/go >> ~/.bashrc && \
#         echo export export GOPATH=/root/go_path >> ~/.bashrc && \
#         echo export PATH=$GOPATH/bin:$GOROOT/bin:$PATH >> ~/.bashrc && \
#         echo export GOROOT_BOOTSTRAP='"$(go env GOROOT)"' >> ~/.bashrc 

# RUN source activate py36

# RUN apt-get install -y vim 