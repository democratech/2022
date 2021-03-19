#!/bin/bash

PIP_ANSIBLE_VERSION='2.9.0'
PIP_JMESPATH_VERSION='0.9.3'
PIP_NETADDR_VERSION='0.8.0'

apt-get update && apt-get install -y python3-pip

pip3 install \
    ansible==${PIP_ANSIBLE_VERSION} \
    jmespath==${PIP_JMESPATH_VERSION} \
    netaddr==${PIP_NETADDR_VERSION}
