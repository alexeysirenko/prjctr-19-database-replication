FROM python:3.14

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY write_data.py .
COPY seed.py .

CMD ["python", "/app/write_data.py"]
