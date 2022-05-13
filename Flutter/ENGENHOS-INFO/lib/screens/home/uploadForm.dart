import 'dart:io';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import '../../shared/constants.dart';

class ApiImage {
  final File imagePath;
  final String weight;
  final String height;
  final String width;

  ApiImage({
    required this.weight,
    required this.height,
    required this.width,
    required this.imagePath
  });
}

class UploadForm extends StatefulWidget {
  const UploadForm({Key? key}) : super(key: key);

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  late String _weight;
  late String _height;
  late String _width;
  late File _imgPath;
  late ApiImage image;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'Width'),
              validator: (width) {
                return (width!.isEmpty) ? 'Width is required!' : null;
              },
              onSaved: (width) => { _width = width!},
            ),
            const SizedBox(height: 11,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'Height'),
              validator: (height) {
                return (height!.isEmpty) ? 'Height is required!' : null;
              },
              onSaved: (height) => { _height = height! },
            ),
            const SizedBox(height: 11,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'Weight'),
              validator: (weight) {
                return (weight!.isEmpty) ? 'Weight is required!' : null;
              },
              onSaved: (weight) => { _weight = weight! },
            ),
            const SizedBox(height: 11,),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: FormBuilderImagePicker(
                name: 'photo',
                decoration: const InputDecoration(
                  label: Center(
                    child: Text("Take Picture"),
                  ),
                ),

                maxImages: 1,
                previewHeight: 200,
                previewWidth: 200,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() == true) {
                    // ApiImage(width: _width , height: _height , weight: _width ,
                    //     imagePath: _formKey.currentState?.value.map.values. )
                    _formKey.currentState?.value.forEach(
                        (key, value) {  _imgPath = File(value[0].path.toString()); });
                    // print(_imgPath);
                    image = ApiImage(weight: _weight, height: _height, width: _width, imagePath: _imgPath);
                    // map.forEach((key, value) {print(key + ":" + value);});
                    LocationData loc = await Location().getLocation();
                    MyUser user = Provider.of<MyUser>(context, listen: false);
                    var url = Uri.http('10.0.2.2:5000', '/formImage');

                    http.MultipartRequest request = http.MultipartRequest('POST', url);

                    request.fields['userID'] = user.uid;
                    request.fields['latitude'] = '${loc.latitude}';
                    request.fields['longitude'] = '${loc.longitude}';
                    request.fields['width'] = _width;
                    request.fields['height'] = _height;
                    request.fields['weight'] = _weight;
                    request.fields['imgPath'] = _imgPath.path;

                    request.files.add(
                      await http.MultipartFile.fromPath(
                        'file',
                        image.imagePath.path,
                        contentType: MediaType('file', 'jpg'),
                      ),
                    );

                    request.send().then((response) {
                      if (response.statusCode == 200) print("Uploaded!");
                    });
                  }
                },
                color: Colors.black,
                focusColor: Colors.grey[400],
                padding: const EdgeInsets.all(17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    const Icon(
                      Icons.send,
                      color: Color(0xffFBD732),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Send",
                      style: TextStyle(
                        color: Colors.grey[400],
                        wordSpacing: 2,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // MaterialButton(onPressed: (){
            //   if(_formKey.currentState?.save()){
            //     print(_formKey.currentState?.value);
            //   }
            // }),
          ],
        ),
      ),
    );
  }
}


