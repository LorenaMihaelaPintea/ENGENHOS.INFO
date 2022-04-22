import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../shared/constants.dart';

class UploadForm extends StatefulWidget {
  const UploadForm({Key? key}) : super(key: key);

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final _formKey = GlobalKey<FormState>();

  String? _weight;
  String? _height;
  String? _width;

  void _trySubmit() {

    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus(); //closes the keyboard

    if(isValid == true) {
      _formKey.currentState?.save();

      print(_weight);
      print(_height);
      print(_width);
    } else {
      null;
    }

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
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
              onSaved: (width) => { _width = width},
            ),
            const SizedBox(height: 11,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'Height'),
              validator: (height) {
                return (height!.isEmpty) ? 'Height is required!' : null;
              },
              onSaved: (height) => { _height = height },
            ),
            const SizedBox(height: 11,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'Weight'),
              validator: (weight) {
                return (weight!.isEmpty) ? 'Weight is required!' : null;
              },
              onSaved: (weight) => { _weight = weight },
            ),
            const SizedBox(height: 11,),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: FormBuilderImagePicker(
                name: 'photos',
                decoration: const InputDecoration(
                  label: const Center(
                    child: Text("Take Picture"),
                  ),
                ),
                maxImages: 1,
                previewHeight: 200,
                previewWidth: 200,

                //onSaved: , *save image when onSaved*
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: _trySubmit, //TODO: create function that sends info to the flask server,
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


