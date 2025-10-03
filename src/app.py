from flask import Flask, jsonify
import os
import socket
import datetime

app = Flask(__name__)

@app.route('/')
def home():
    """Main endpoint returning service information"""
    return jsonify({
        'message': 'Hello from Container App with Application Gateway!',
        'service': 'Python Flask API',
        'hostname': socket.gethostname(),
        'timestamp': datetime.datetime.now().isoformat(),
        'version': '1.0.0'
    })

@app.route('/health')
def health():
    """Health check endpoint for Application Gateway probe"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.datetime.now().isoformat()
    }), 200

@app.route('/api/info')
def api_info():
    """API information endpoint"""
    return jsonify({
        'api': 'Container App Demo API',
        'endpoints': [
            {'path': '/', 'method': 'GET', 'description': 'Home page'},
            {'path': '/health', 'method': 'GET', 'description': 'Health check'},
            {'path': '/api/info', 'method': 'GET', 'description': 'API information'},
            {'path': '/api/data', 'method': 'GET', 'description': 'Sample data'}
        ],
        'environment': os.environ.get('ENVIRONMENT', 'development'),
        'container_revision': os.environ.get('CONTAINER_APP_REVISION', 'unknown')
    })

@app.route('/api/data')
def get_data():
    """Sample data endpoint"""
    sample_data = [
        {'id': 1, 'name': 'Azure Container Apps', 'type': 'Serverless Container Platform'},
        {'id': 2, 'name': 'Application Gateway', 'type': 'Load Balancer'},
        {'id': 3, 'name': 'Workload Profiles v2', 'type': 'Dedicated Compute'}
    ]
    
    return jsonify({
        'data': sample_data,
        'count': len(sample_data),
        'served_by': socket.gethostname(),
        'timestamp': datetime.datetime.now().isoformat()
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8000))
    app.run(host='0.0.0.0', port=port, debug=False)