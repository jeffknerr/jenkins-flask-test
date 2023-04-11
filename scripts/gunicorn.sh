#!/bin/bash

source ./venv/bin/activate
pip install gunicorn

echo "$USER"
echo "$PWD"

sudo systemctl start gunicorn

echo "Gunicorn has started."

sudo systemctl enable gunicorn

echo "Gunicorn has been enabled."

sudo systemctl status gunicorn
