import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:uas/screens/restaurant/edit_restaurant.dart';

class AddRestaurantPage extends StatefulWidget {
  @override
  _AddRestaurantPageState createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String district = '';
  String address = '';
  String operationalHours = '';
  String photoUrl = '';
  String role = '';
  File? _image;
  bool isUploadingFile = false;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> checkOwnerRestaurant() async {
    final request = context.read<CookieRequest>();
    int id = request.getJsonData()['data']['id'];
    final response = await request
        .get('http://localhost:8000/restaurant/has_restaurant/$id');

    if (response['statusCode'] == 200) {
      if (response['has_restaurant']) {
        int restoId = response['restaurant_id'];
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => EditRestaurantPage(restaurantId: restoId)),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkOwnerRestaurant();
  }

  Future<void> uploadRestaurant() async {
    final request = context.read<CookieRequest>();
    String? base64Image;

    if (_image != null) {
      List<int> imageBytes = await _image!.readAsBytes();
      base64Image =
          "data:image/${_image!.path.split('.').last};base64,${base64Encode(imageBytes)}";
    }

    final data = {
      'name': name,
      'district': district,
      'address': address,
      'operational_hours': operationalHours,
      'image': base64Image,
    };

    final response = await request.postJson(
        'http://localhost:8000/restaurant/add_api/', jsonEncode(data));

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restaurant added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add restaurant!')),
      );
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      isUploadingFile = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    setState(() {
      isUploadingFile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    role = request.getJsonData()['data']['role'];
    if (role != 'RESTO_OWNER') {
      return Scaffold(
        body: Center(
          child: Text('You are not authorized to access this page!'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'District'),
                onChanged: (value) => district = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) => address = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Operational Hours'),
                onChanged: (value) => operationalHours = value,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Select Image'),
              ),
              if (_image != null) Image.file(_image!, height: 100),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadRestaurant,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
