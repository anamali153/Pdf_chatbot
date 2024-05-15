# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.10-slim

# Set environment variables to avoid any prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Create and set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements.txt first, for better caching
COPY requirements.txt .

# Install the dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port streamlit will run on
EXPOSE 8501

# Expose the port gradio will run on (default is 7860)
EXPOSE 7860

# Streamlit specific commands to avoid the sharing prompt.
ENV STREAMLIT_TELEMETRY=False
ENV STREAMLIT_SERVER_PORT=8501

# Set the entrypoint for the container to streamlit
ENTRYPOINT ["streamlit", "run"]

# Set the default command to the provided Python script
CMD ["RAG chatbot.ipynb"]
