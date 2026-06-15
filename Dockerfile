FROM python:3.11-slim

WORKDIR /code

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY movie-rec-main/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files (including pkl datasets)
COPY movie-rec-main/ .

# Copy env template (Secrets will be read from Hugging Face environment settings)
ENV API_BASE=http://127.0.0.1:8000

# Expose Streamlit port
EXPOSE 7860

# Start FastAPI backend in the background on port 8000, and Streamlit on port 7860
CMD uvicorn main:app --host 0.0.0.0 --port 8000 & streamlit run app.py --server.port 7860 --server.address 0.0.0.0
