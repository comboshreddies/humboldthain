FROM debian

WORKDIR /root/
RUN apt update -y && \
    apt install -y curl python gpg lsb-release && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-396.0.0-linux-x86_64.tar.gz && \
    tar xzvf google-cloud-cli-396.0.0-linux-x86_64.tar.gz && \
    cd google-cloud-sdk && \
    ./install.sh -q && \
    echo 'PATH=$PATH:/root/google-cloud-sdk/bin' >> /root/.bashrc

RUN /bin/bash -c " source /root/google-cloud-sdk/completion.bash.inc && source /root/google-cloud-sdk/path.bash.inc && gcloud components update && gcloud components install kubectl"

COPY gcp_cnf.tgz.gpg .
COPY setup.sh .

RUN curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
   apt update -y && apt install -y terraform

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

CMD /bin/bash

    
    
   

