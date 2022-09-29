#!/bin/bash
git clone https://github.com/daerco22/futures-dashboard.git
sudo bash -c 'cd futures-dashboard'
sudo bash -c 'pip install -r requirements.txt'
sudo bash -c 'streamlit run 1_📈_Dashboard.py'