import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _pickedImage;
  final _picker = ImagePicker();
  bool showSpinner = false;
  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> uploadImage() async {
    if (_pickedImage == null) {
      print("No image selected for upload.");
      return;
    }

    setState(() {
      showSpinner = true;
    });

    try {
      var stream = http.ByteStream(_pickedImage!.openRead().cast());
      var length = await _pickedImage!.length();

      var uri = Uri.parse('https://eagle.forexmountains.com/api/customer/deposit-submit');

      var request = http.MultipartRequest('POST', uri);

      request.fields['title'] = 'static title';
      request.fields['amount'] = '2001';
      request.fields['txn_id'] = '1234567890';
      request.fields['payment_type'] = 'Bank';
      request.fields['login_token'] = 'b776fc0116a8b5de44f8c1d9b9ddd175';
      request.headers['Content-Type'] = 'application/json';
      request.fields['X-API-KEY'] = 'forexmountain@741852963';

      var multipartFile = http.MultipartFile('slip', stream, length,
          filename: _pickedImage!.path.split('/').last);
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully.');
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      } else {
        print('Image upload failed with status code: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('Error response: $responseBody');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Image Picker Example'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(_pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _pickedImage == null
                      ? Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey[700])
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _pickImage,
                child: Text('Pick Image', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  uploadImage();
                },
                child: Text('Upload Image', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ImagePickerExample(),
  ));
}
