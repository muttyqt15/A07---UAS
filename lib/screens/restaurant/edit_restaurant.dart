import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditRestaurantPage extends StatefulWidget {
  final int restaurantId;

  const EditRestaurantPage({super.key, required this.restaurantId});

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
        const SnackBar(content: Text('Failed to load restaurant details!')),
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
    print('YAHOOOOOOOOO');
    final response = await request.postJson(
        'http://localhost:8000/restaurant/edit_api/${widget.restaurantId}/',
        jsonEncode(data));
    print('GMAILLLLLLLLL');
    if (response.status == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restaurant updated successfully!')),
      );
    } else {
      final error = jsonDecode(response.body)['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Restaurant'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        color: Colors.brown[50],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: name,
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
                  initialValue: district,
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
                  initialValue: address,
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
                  initialValue: operationalHours,
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
                  child: Text('Select New Image'),
                ),
                if (_image != null)
                  Image.file(_image!, height: 100)
                else if (photoUrl.isNotEmpty)
                  Image.network('http://localhost:8000$photoUrl', height: 100),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: editRestaurant,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.brown,
                  ),
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
