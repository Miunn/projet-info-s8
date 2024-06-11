import time
from sys import argv
from flask import Flask, send_file, jsonify, request, render_template
 
app = Flask(__name__)
 
@app.route("/")
def hello_world():
    return render_template("index.html")
 
@app.route('/download/<platform>', methods=['GET'])
def getFiles(platform:str):
    if platform == 'ios':
        return send_file('static\\images\\cry-car.gif')
    elif platform == 'android':
        return send_file('downloads\\app-release.apk')
    else:
        return "Error: Invalid OS type", 404
 
if __name__ == "__main__":
 
    #TODO: Clean data and make sure chunk sizes are around 1000 (keep single newlines for paragraph splits)
    #NOTE: Remove single newline replacements in json_parse
    #TODO: Chunk sizes are throttling the model memory, need to find a way to reduce memory usage
 
    app.run(host='127.0.0.1', port=34197)