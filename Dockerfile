# Use official Python 3.11 slim image
FROM public.ecr.aws/docker/library/python:3.11-slim

# Set working directory
WORKDIR /app

# Install OS-level dependencies for building Python packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libffi-dev \
    libssl-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Copy requirements and install them inside the virtual environment
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy all app files
COPY . .

# Create output directory
RUN mkdir -p output

# Run tests with coverage and generate XML report
CMD ["sh", "-c", "coverage run -m pytest && coverage xml -o output/coverage.xml"]