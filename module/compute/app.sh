#! /bin/bash
yum update -y
yum -y install curl
yum install -y gcc-c++ make
curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
yum install -y nodejs