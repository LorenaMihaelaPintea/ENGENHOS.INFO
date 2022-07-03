import json
import os

import flask
import tensorflow as tf
from firebase_admin import credentials, firestore, initialize_app, storage
from flask import Flask, request, flash, jsonify, send_file, Response
import numpy as np
from keras.preprocessing import image
# from google.cloud import storage

app = Flask(__name__)



# Initialize Firestore DB
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "engenhos-info-1b04a38ef172.json"
cred = credentials.Certificate('key.json')
default_app = initialize_app(cred)
db = firestore.client()
obj_ref = db.collection('objects')
obj_save = db.collection('objectsFromUsers')
img_store = storage.bucket('engenhos-info.appspot.com')
classifier = tf.keras.models.load_model('model.h5')


def labels(result):
    if result[0][0] == 1:
        return "AP Mine"
    elif result[0][1] == 1:
        return "AV Mine"
    elif result[0][2] == 1:
        return "Grenade"
    elif result[0][3] == 1:
        return "Mortar Round"
    elif result[0][4] == 1:
        return "Naval Ordnance"
    elif result[0][5] == 1:
        return "Projectile"
    elif result[0][6] == 1:
        return "Pyrotechnic or Flare"
    else:
        return "We cannot identify this object!"


@app.route('/formImage', methods=['POST', 'GET'])
def post_formimage():
    dataForm = request.form.to_dict()
    # print(dataForm)
    # file = request.files['file']
    if 'file' not in request.files:
        flash('File missing!')
        message = {
            'status': 404,
            'message': 'File missing! Not Found.',
        }
        return json.dumps(message)

    file = request.files['file']
    if file.filename == '':
        flash('File missing!')
        message = {
            'status': 404,
            'message': 'File missing! Not Found.',
        }

        return json.dumps(message)

    if file:
        filename = file.filename
        filePath = './imagesForm/' + filename
        file.save(os.path.join('./imagesForm', filename))
        imageBlob = img_store.blob('imagesFromUsers/' + filename)
        imageBlob.upload_from_filename(filePath)
        test_image = image.load_img(filePath, target_size=(224, 224))
        test_image = np.expand_dims(test_image, axis=0)
        n_result = classifier.predict(test_image)
        result = labels(n_result)
        dataForm['result'] = result
        dataForm['imgName'] = filename
        obj_save.add(dataForm)
        return jsonify(dataForm)


@app.route('/image', methods=['POST', 'GET'])
def post_image():
    data = request.form.to_dict()
    print(data)
    # obj_save.add(data)
    # file = request.files['file']
    if 'file' not in request.files:
        flash('File missing!')
        message = {
            'status': 404,
            'message': 'File missing! Not Found.',
        }
        return json.dumps(message)

    file = request.files['file']
    if file.filename == '':
        flash('File missing!')
        message = {
            'status': 404,
            'message': 'File missing! Not Found.',
        }
        return json.dumps(message)

    if file:
        filename = file.filename
        filePath = './images/' + filename
        file.save(os.path.join('./images', filename))
        imageBlob = img_store.blob('imagesFromUsers/' + filename)
        imageBlob.upload_from_filename(filePath)
        test_image = image.load_img(filePath, target_size=(224, 224))
        test_image = np.expand_dims(test_image, axis=0)
        n_result = classifier.predict(test_image)
        result = labels(n_result)
        data['result'] = result
        data['imgName'] = filename
        obj_save.add(data)
        return jsonify(data)



if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)
