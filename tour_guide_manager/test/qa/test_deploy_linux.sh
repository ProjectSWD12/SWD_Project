#!/bin/bash

echo "🛠️ Testing deployment to Linux environment..."

# Simulate setting up virtual environment
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt

# Run tests
pytest tests/

echo "✅ Deployment passed if all tests succeed"
