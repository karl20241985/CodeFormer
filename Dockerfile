FROM python:3.8-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libglib2.0-0 \
    libgcc-s1 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p inputs outputs weights

# Download pretrained models (optional - can be done at runtime)
# RUN python scripts/download_pretrained_models.py facelib
# RUN python scripts/download_pretrained_models.py CodeFormer

# Expose port for web interface
EXPOSE 8000

# Set environment variables
ENV PYTHONPATH=/app
ENV TORCH_HOME=/app/.torch

# Default command
CMD ["python", "inference_codeformer.py", "--help"]

# Alternative commands:
# For web interface (if implemented):
# CMD ["python", "web_interface.py"]
#
# For API server:
# CMD ["python", "api_server.py"]