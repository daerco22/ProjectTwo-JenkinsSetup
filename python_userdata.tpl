#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y python3.8
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install python3-pip
git clone https://github.com/daerco22/futures-dashboard.git
cd /futures-dashboard
yes | pip3 install -r requirements.txt
echo "api_key = ${api_key}" >> /futures-dashboard/.env
echo "api_secret = ${api_secret}" >> /futures-dashboard/.env
streamlit run 1_📈_Dashboard.py &