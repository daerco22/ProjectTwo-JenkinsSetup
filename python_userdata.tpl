#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y python3.8
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install python3-pip
git clone https://github.com/daerco22/futures-dashboard.git
cd /futures-dashboard
pip install streamlit
pip install pandas
pip install tradingview_ta
pip install python-binance
pip3 install python-dotenv
pip install numpy
pip install plotly-express
pip install openpyxl
pip install streamlit-authenticator
pip install bs4
echo "api_key = ${api_key}" >> /futures-dashboard/.env
echo "api_secret = ${api_secret}" >> /futures-dashboard/.env
streamlit run 1_📈_Dashboard.py &