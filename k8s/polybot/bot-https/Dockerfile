FROM python:3.9-slim
RUN pip install --upgrade pip
COPY k8s/polybot/bot-https/requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python3", "app.py"]
