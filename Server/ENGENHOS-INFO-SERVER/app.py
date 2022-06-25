import os

import requests
import tensorflow as tf
from firebase_admin import credentials, firestore, initialize_app
from flask import Flask, request, flash
import numpy as np
from keras.preprocessing import image

app = Flask(__name__)

# Initialize Firestore DB
cred = credentials.Certificate('key.json')
default_app = initialize_app(cred)
db = firestore.client()
obj_ref = db.collection('objects')
obj_save = db.collection('objectsFromUsers')

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
        test_image = image.load_img(filename, target_size=(224, 224))
        test_image = np.expand_dims(test_image, axis=0)
        n_result = classifier.predict(test_image)
        result = labels(n_result)
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
        test_image = image.load_img(filename, target_size=(224, 224))
        test_image = np.expand_dims(test_image, axis=0)
        n_result = classifier.predict(test_image)
        result = labels(n_result)
        return 200


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)
