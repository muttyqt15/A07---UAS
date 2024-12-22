import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
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

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

// access a django endpoint to check if the owner has a restaurant
  Future<void> checkOwnerRestaurant() async {
    final url = Uri.parse('http://localhost:8000/restaurant/has_restaurant/');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['has_restaurant']) {
        int restaurantId = data['restaurant_id'];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You already have a restaurant!')),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditRestaurantPage(restaurantId: restaurantId)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You do not have a restaurant.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to check restaurant ownership!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkOwnerRestaurant();
  }

  Future<void> uploadRestaurant() async {
    final url = Uri.parse('http://localhost:8000/api/add-restaurant/');
    var request = http.MultipartRequest('POST', url);
    request.fields['name'] = name;
    request.fields['district'] = district;
    request.fields['address'] = address;
    request.fields['operational_hours'] = operationalHours;

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('photo', _image!.path),
      );
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restaurant added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add restaurant!')),
      );
    }
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
      appBar: AppBar(title: const Text('Add Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'District'),
                onChanged: (value) => district = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) => address = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Operational Hours'),
                onChanged: (value) => operationalHours = value,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Select Image'),
              ),
              if (_image != null) Image.file(_image!, height: 100),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadRestaurant,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
