import 'dart:convert';
import 'dart:io';
import 'package:uas/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/screens/restaurant/edit_restaurant.dart';

class AddRestaurantPage extends StatefulWidget {
  const AddRestaurantPage({super.key});

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
    final response =
        await request.get('${CONSTANTS.baseUrl}/restaurant/has_restaurant/$id');

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
        '${CONSTANTS.baseUrl}/restaurant/add_api/', jsonEncode(data));

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restaurant added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add restaurant!')),
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
      return const Scaffold(
        body: Center(
          child: Text('You are not authorized to access this page!'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Restaurant'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        color: Colors.brown[50],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.brown),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'District',
                  labelStyle: TextStyle(color: Colors.brown),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                onChanged: (value) => district = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.brown),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                onChanged: (value) => address = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Operational Hours',
                  labelStyle: TextStyle(color: Colors.brown),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                onChanged: (value) => operationalHours = value,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.brown,
                ),
                child: Text('Select Image'),
              ),
              if (_image != null) Image.file(_image!, height: 100),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadRestaurant,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.brown,
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
