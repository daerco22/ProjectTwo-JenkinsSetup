#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y python3.8 python3-pip
git clone https://github.com/daerco22/futures-dashboard.git
cd /futures-dashboard
pip install -r requirements.txt
streamlit run 1_📈_Dashboard.py