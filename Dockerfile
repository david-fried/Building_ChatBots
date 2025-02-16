# Use Anaconda base image
FROM continuumio/anaconda3:latest

# Set working directory
WORKDIR /app

# Copy project files
COPY app /app/

# Install pipreqs for dependency detection
RUN pip install pipreqs

# Auto-generate requirements.txt from imports
RUN pipreqs /app --force

# Convert requirements.txt to environment.yml
RUN echo "name: myenv" > environment.yml && \
    echo "channels:" >> environment.yml && \
    echo "  - defaults" >> environment.yml && \
    echo "dependencies:" >> environment.yml && \
    awk '{print "  - " $0}' /app/requirements.txt >> environment.yml

# Create Conda environment
RUN conda env create -f environment.yml

# Activate the Conda environment and use Bash
SHELL ["conda", "run", "--no-capture-output", "-n", "myenv", "/bin/bash", "-c"]

# Entry point: Run app inside the Conda environment
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "myenv", "python", "/app/app.py"]
