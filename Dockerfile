FROM python:3.9.13-slim-bullseye AS runtime
ARG USER_NAME
ARG USER_ID

LABEL author="Nilanjan Roy"
LABEL email="nilanjan1.roy@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV HOME_DIR /home/${USER_NAME}
ENV PATH ${HOME_DIR}/.local/bin:${PATH}
ENV NPM_VERSION 9.6.5
ENV TERRAFORM_VERSION 1.4.2

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y  sshpass gettext-base jq sudo python-is-python3 curl wget groff git gettext-base apt-transport-https ca-certificates libcap2 unzip openssl \
    && wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_$(dpkg --print-architecture).zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/terraform \
    && mkdir -m 755 -p ${HOME_DIR} \
    && useradd -u ${USER_ID} -s /bin/bash -d ${HOME_DIR} ${USER_NAME}  \
    && chown -R ${USER_NAME} ${HOME_DIR} 

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

RUN npm install --location=global npm@${NPM_VERSION} \
    && npm install --global cdktf-cli@latest \
    && npm install --global aws-cdk@latest \
    && npm cache clean --force

USER ${USER_NAME}
WORKDIR ${HOME_DIR}

RUN pip3 install --upgrade pip \
    && pip3 install ansible \
    && ansible-galaxy collection install community.general 

WORKDIR ${HOME_DIR}

CMD ["/bin/bash"]
    
