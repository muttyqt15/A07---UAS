import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class EditRestaurantPage extends StatefulWidget {
  final int restaurantId;

  EditRestaurantPage({required this.restaurantId});

  @override
  _EditRestaurantPageState createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  int restoId = 0;
  String name = '';
  String district = '';
  String address = '';
  String operationalHours = '';
  String photoUrl = '';
  File? _image;

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails();
  }

  Future<void> fetchRestaurantDetails() async {
    final url = Uri.parse(
        'http://localhost:8000/restaurant/serialized/${widget.restaurantId}');
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        restoId = data['restaurant']['id'];
        name = data['restaurant']['name'];
        district = data['restaurant']['district'];
        address = data['restaurant']['address'];
        operationalHours = data['restaurant']['operational_hours'];
        photoUrl = data['restaurant']['photo_url'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load restaurant details!')),
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> editRestaurant() async {
    final url = Uri.parse(
        'http://localhost:8000/restaurant/edit_api/${widget.restaurantId}/');

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

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restaurant updated successfully!')),
      );
    } else {
      final responseData = await response.stream.bytesToString();
      final error = jsonDecode(responseData)['error'] ?? 'Failed to update.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) => name = value,
                ),
                TextFormField(
                  initialValue: district,
                  decoration: InputDecoration(labelText: 'District'),
                  onChanged: (value) => district = value,
                ),
                TextFormField(
                  initialValue: address,
                  decoration: InputDecoration(labelText: 'Address'),
                  onChanged: (value) => address = value,
                ),
                TextFormField(
                  initialValue: operationalHours,
                  decoration: InputDecoration(labelText: 'Operational Hours'),
                  onChanged: (value) => operationalHours = value,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text('Select New Image'),
                ),
                if (_image != null)
                  Image.file(_image!, height: 100)
                else if (photoUrl.isNotEmpty)
                  Image.network('http://localhost:8000$photoUrl', height: 100),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: editRestaurant,
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
