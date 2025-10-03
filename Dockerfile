FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY src/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ .

# Expose port
EXPOSE 8000

# Set environment variable for Flask
ENV FLASK_APP=app.py
ENV PORT=8000

# Run the application
CMD ["python", "app.py"]