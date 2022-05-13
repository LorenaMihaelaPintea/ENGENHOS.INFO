import os

from firebase_admin import credentials, firestore, initialize_app
from flask import Flask, request, flash

app = Flask(__name__)

# Initialize Firestore DB
cred = credentials.Certificate('key.json')
default_app = initialize_app(cred)
db = firestore.client()
obj_ref = db.collection('objects')
obj_save = db.collection('objectsFromUsers')


@app.route('/formImage', methods=['POST'])
def post_formimage():
    dataForm = request.form.to_dict()
    print(dataForm)
    # obj_save.add(dataForm)

    if 'file' not in request.files:
        flash('File missing!')
        return 400

    file = request.files['file']
    if file.filename == '':
        flash('File missing!')
        return 400
    if file:
        filename = file.filename
        file.save(os.path.join('./imagesForm', filename))
        return 200


@app.route('/image', methods=['POST'])
def post_image():
    data = request.form.to_dict()
    print(data)
    # obj_save.add(data)

    if 'file' not in request.files:
        flash('File missing!')
        return 400

    file = request.files['file']
    if file.filename == '':
        flash('File missing!')
        return 400
    if file:
        filename = file.filename
        file.save(os.path.join('./images', filename))
        return 200


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)
