from keras.optimizer_v2.rmsprop import RMSprop
from matplotlib import pyplot as plt
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import tensorflow as tf
import numpy as np
# from keras.preprocessing import image
from keras_tuner.tuners import RandomSearch
from sklearn import metrics
# from keras_tuner.engine.hyperparameters import HyperParameters


def build_model(hp):
    model = tf.keras.models.Sequential([
        tf.keras.layers.Conv2D(hp.Int('input_units', min_value=1, max_value=16, step=1),
                               (3, 3), padding='same', activation='relu', input_shape=(224, 224, 3)),
        tf.keras.layers.MaxPooling2D(2, 2),
        tf.keras.layers.Conv2D(hp.Int('conv_1_units', min_value=16, max_value=32, step=1),
                               (3, 3), padding='same', activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        tf.keras.layers.Conv2D(hp.Int('conv_2_units', min_value=32, max_value=64, step=1),
                               (3, 3), padding='same', activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        tf.keras.layers.Conv2D(hp.Int('conv_3_units', min_value=32, max_value=64, step=1),
                               (3, 3), padding='same', activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        tf.keras.layers.Conv2D(hp.Int('conv_4_units', min_value=64, max_value=128, step=1),
                               (3, 3), padding='same', activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        tf.keras.layers.Conv2D(hp.Int('conv_5_units', min_value=64, max_value=128, step=1),
                               (3, 3), padding='same', activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        tf.keras.layers.Conv2D(hp.Int('conv_6_units', min_value=64, max_value=128, step=1),
                               (3, 3), padding='same', activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        tf.keras.layers.Flatten(),
        tf.keras.layers.Dense(hp.Int('conv_7_units', min_value=128, max_value=256, step=1),
                              activation='relu'),
        tf.keras.layers.Dense(7, activation='softmax')
    ])

    model.compile(loss='categorical_crossentropy',
                  optimizer=RMSprop(learning_rate=0.001),
                  metrics=['accuracy'])

    return model


batch_size = 32
epochs = 50

# Image normalization (0-1)
# Image Augmentation accuracy: 58%
# generator = ImageDataGenerator(rotation_range=40, width_shift_range=0.2, height_shift_range=0.2, rescale=1./255,
#                                shear_range=0.2, zoom_range=0.2, horizontal_flip=True, fill_mode='nearest',
#                                validation_split=0.09)

generator = ImageDataGenerator(rescale=1./255, validation_split=0.09)
# Flow training images using train_datagen generator
train_generator = generator.flow_from_directory(
    'dataset',
    target_size=(224, 224),
    batch_size=batch_size,  #32
    classes=['AP Mine', 'AV Mine', 'Grenade', 'Mortar Round', 'Naval Ordnance', 'Projectile',
             'Pyrotechnic or Flare'],
    class_mode='categorical', subset='training', shuffle=True)

validation_generator = generator.flow_from_directory(
    'dataset',
    target_size=(224, 224),
    batch_size=batch_size,  #32
    classes=['AP Mine', 'AV Mine', 'Grenade', 'Mortar Round', 'Naval Ordnance', 'Projectile',
             'Pyrotechnic or Flare'],
    class_mode='categorical', subset='validation', shuffle=True)


tuner = RandomSearch(build_model, objective='val_accuracy', max_trials=100)
tuner.search(train_generator, epochs=epochs, batch_size=batch_size, validation_data=validation_generator)

tuner.results_summary()
print(tuner.get_best_hyperparameters()[0].values)

total_sample = train_generator.n

best_model = tuner.get_best_models()[0]

best_model.save('model.h5')

history = best_model.fit(train_generator, validation_data=validation_generator,
                         steps_per_epoch=int(total_sample/batch_size), epochs=epochs, verbose=1)

acc = history.history['accuracy']
val_acc = history.history['val_accuracy']
loss = history.history['loss']
val_loss = history.history['val_loss']
epochs = range(len(acc))
plt.plot(epochs, acc, 'r', label='Training acc')
plt.plot(epochs, val_acc, 'b', label='Validation acc')
plt.title('Training and validation accuracy')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.legend()
plt.figure()
plt.plot(epochs, loss, 'r', label='Training loss')
plt.plot(epochs, val_loss, 'b', label='Validation loss')
plt.title('Training and validation loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend()
plt.show()

test_generator = ImageDataGenerator()
test_data_generator = test_generator.flow_from_directory(
    'test_data',
    target_size=(224, 224),
    batch_size=32,
    shuffle=False)

test_steps_per_epoch = np.math.ceil(test_data_generator.samples / test_data_generator.batch_size)
predictions = best_model.predict_generator(test_data_generator, steps=test_steps_per_epoch)

predicted_classes = np.argmax(predictions, axis=1)

true_classes = test_data_generator.classes
class_labels = list(test_data_generator.class_indices.keys())

report = metrics.classification_report(true_classes, predicted_classes, target_names=class_labels)
print(report)


# test_image_ap = image.load_img(path='AP Mine - 1.jpg', target_size=(224, 224))
# test_image_ap1 = image.load_img(path='AP Mine - 2.jpg', target_size=(224, 224))
# test_image_av = image.load_img(path='AV Mine - 1.jpg', target_size=(224, 224))
# test_image_av1 = image.load_img(path='AV Mine - 2.jpg', target_size=(224, 224))
# test_image_g = image.load_img(path='grenade-1.jpeg', target_size=(224, 224))
# test_image_g1 = image.load_img(path='grenade-2.jpg', target_size=(224, 224))
# test_image_mr = image.load_img(path='Mortar Round - 1.jpg', target_size=(224, 224))
# test_image_mr1 = image.load_img(path='Mortar Round - 2.jpg', target_size=(224, 224))
# test_image_no = image.load_img(path='Naval Ordnance - 1.jpg', target_size=(224, 224))
# test_image_p = image.load_img(path='projectile-1.jpg', target_size=(224, 224))
# test_image_p1 = image.load_img(path='projectile-2.jpg', target_size=(224, 224))
# test_image_pof = image.load_img(path='Pyrotechnic or Flare - 1.jpg', target_size=(224, 224))
# test_image_pof1 = image.load_img(path='Pyrotechnic or Flare - 2.jpg', target_size=(224, 224))
#
# test_image_ap_np = np.expand_dims(test_image_ap, axis=0)
# result_ap = best_model.predict(test_image_ap_np)
# print("AP Mine")
# print(result_ap)
# print("----------------------------------------")
#
# test_image_ap1 = np.expand_dims(test_image_ap1, axis=0)
# result_ap1 = best_model.predict(test_image_ap1)
# print("AP Mine")
# print(result_ap1)
# print("----------------------------------------")
#
# test_image_av = np.expand_dims(test_image_av, axis=0)
# result_av = best_model.predict(test_image_av)
# print("AV Mine")
# print(result_av)
# print("----------------------------------------")
#
# test_image_av1 = np.expand_dims(test_image_av1, axis=0)
# result_av1 = best_model.predict(test_image_av1)
# print("AV Mine")
# print(result_av1)
# print("----------------------------------------")
#
# test_image_g = np.expand_dims(test_image_g, axis=0)
# result_g = best_model.predict(test_image_g)
# print("Grenade")
# print(result_g)
# print("----------------------------------------")
#
# test_image_g1 = np.expand_dims(test_image_g1, axis=0)
# result_g1 = best_model.predict(test_image_g1)
# print("Grenade")
# print(result_g1)
# print("----------------------------------------")
#
# test_image_mr = np.expand_dims(test_image_mr, axis=0)
# result_mr = best_model.predict(test_image_mr)
# print("Mortar Round")
# print(result_mr)
# print("----------------------------------------")
#
# test_image_mr1 = np.expand_dims(test_image_mr1, axis=0)
# result_mr1 = best_model.predict(test_image_mr1)
# print("Mortar Round")
# print(result_mr1)
# print("----------------------------------------")
#
# test_image_no = np.expand_dims(test_image_no, axis=0)
# result_no = best_model.predict(test_image_no)
# print("Naval Ordnance")
# print(result_no)
# print("----------------------------------------")
#
# test_image_p = np.expand_dims(test_image_p, axis=0)
# result_p = best_model.predict(test_image_p)
# print("Projectile")
# print(result_p)
# print("----------------------------------------")
#
# test_image_p1 = np.expand_dims(test_image_p1, axis=0)
# result_p1 = best_model.predict(test_image_p1)
# print("Projectile")
# print(result_p1)
# print("----------------------------------------")
#
#
# test_image_pof = np.expand_dims(test_image_pof, axis=0)
# result_pof = best_model.predict(test_image_pof)
# print("Pyrotechnic or Flare")
# print(result_pof)
# print("----------------------------------------")
#
# test_image_pof1 = np.expand_dims(test_image_pof1, axis=0)
# result_pof1 = best_model.predict(test_image_pof1)
# print("Pyrotechnic or Flare")
# print(result_pof1)
# print("----------------------------------------")
