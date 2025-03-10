FROM python:3.14-rc

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY write_data.py .
COPY seed.py .

CMD ["sleep", "infinity"]

