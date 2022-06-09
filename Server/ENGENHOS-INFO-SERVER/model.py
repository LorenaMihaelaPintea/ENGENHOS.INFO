from tensorflow.keras.preprocessing.image import ImageDataGenerator
import tensorflow as tf
from tensorflow.keras.optimizers import RMSprop, Adam, Adamax
import numpy as np
from keras.preprocessing import image

batch_size = 32

# Image normalization (0-1)
train_datagen = ImageDataGenerator(rescale=1.0/255.0)

# Flow training images using train_datagen generator
train_generator = train_datagen.flow_from_directory(
        'dataset',
        target_size=(300, 300),
        batch_size=batch_size,
        classes=['Projectile', 'Grenade', 'AP Mine', 'Mortar Round', 'Pyrotechnic or Flare'],
        class_mode='categorical')

model = tf.keras.models.Sequential([
    tf.keras.layers.Conv2D(16, (3, 3), activation='relu', input_shape=(300, 300, 3)),
    tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.Conv2D(32, (3, 3), activation='relu'),
    tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.Conv2D(64, (3, 3), activation='relu'),
    tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.Conv2D(64, (3, 3), activation='relu'),
    tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.Conv2D(64, (3, 3), activation='relu'),
    tf.keras.layers.MaxPooling2D(2, 2),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dense(5, activation='softmax')
])

model.summary()

model.compile(loss='categorical_crossentropy',
              optimizer=RMSprop(learning_rate=0.001),
              metrics=['acc'])

# model.compile(loss='categorical_crossentropy',
#               optimizer=Adam(learning_rate=0.001),
#               metrics=['acc'])

# model.compile(loss='categorical_crossentropy',
#               optimizer=Adamax(learning_rate=0.001),
#               metrics=['acc'])
#

total_sample = train_generator.n

n_epochs = 25

history = model.fit(
        train_generator,
        steps_per_epoch=int(total_sample/batch_size),
        epochs=n_epochs,
        verbose=1)

# model.save('model.h5')

test_image_ap = image.load_img(path='AP Mine - 1.jpg', target_size=(300, 300))
test_image_g = image.load_img(path='grenade-1.jpeg', target_size=(300, 300))
test_image_p = image.load_img(path='projectile-1.jpg', target_size=(300, 300))
test_image_pof = image.load_img(path='Pyrotechnic or Flare - 1.jpg', target_size=(300, 300))
test_image_mr = image.load_img(path='Mortar Round - 1.jpg', target_size=(300, 300))

test_image_p = np.expand_dims(test_image_p, axis=0)
result_p = model.predict(test_image_p)
print("Projectile")
print(result_p)
print("----------------------------------------")

test_image_g = np.expand_dims(test_image_g, axis=0)
result_g = model.predict(test_image_g)
print("Grenade")
print(result_g)
print("----------------------------------------")

test_image_ap = np.expand_dims(test_image_ap, axis=0)
result_ap = model.predict(test_image_ap)
print("AP Mine")
print(result_ap)
print("----------------------------------------")

test_image_mr = np.expand_dims(test_image_mr, axis=0)
result_mr = model.predict(test_image_mr)
print("Mortar Round")
print(result_mr)
print("----------------------------------------")

test_image_pof = np.expand_dims(test_image_pof, axis=0)
result_pof = model.predict(test_image_pof)
print("Pyrotechnic or Flare")
print(result_pof)
print("----------------------------------------")
