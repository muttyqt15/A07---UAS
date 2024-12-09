import 'package:flutter/material.dart';

class EditReviewDialog extends StatefulWidget {
  final String initialTitle;
  final String initialRating;
  final String initialReview;
  final String initialDisplayName;
  final Function(String, String, String) onSave;

  EditReviewDialog({
    required this.initialTitle,
    required this.initialRating,
    required this.initialReview,
    required this.initialDisplayName,
    required this.onSave,
  });

  @override
  _EditReviewDialogState createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _rating;
  late String _review;

  @override
  void initState() {
    super.initState();
    // Initialize form values from the widget's properties
    _title = widget.initialTitle;
    _rating = widget.initialRating;
    _review = widget.initialReview;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Your Review',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: widget.initialDisplayName,
                decoration: InputDecoration(labelText: 'Display Name'),
                readOnly: true, // Make display name readonly
              ),
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => _title = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _rating,
                decoration: InputDecoration(labelText: 'Rating'),
                items: ['1', '2', '3', '4', '5']
                    .map((rating) => DropdownMenuItem(
                          value: rating,
                          child: Text(rating),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _rating = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a rating';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _review,
                decoration: InputDecoration(labelText: 'Review'),
                maxLines: 4,
                onChanged: (value) => _review = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a review';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Validate form and save data
                      if (_formKey.currentState!.validate()) {
                        widget.onSave(_title, _rating, _review);
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                    child: Text('Save Changes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog without saving
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show the edit review dialog
void _showEditReviewDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditReviewDialog(
        initialTitle: 'Initial Title', // Initial title for editing
        initialRating: '4', // Initial rating for editing
        initialReview: 'Initial review content...', // Initial review text
        initialDisplayName: 'John Doe', // Display name (readonly)
        onSave: (String title, String rating, String review) {
          // Handle the save logic (e.g., send updated data to backend)
          print('Saved Review: Title=$title, Rating=$rating, Review=$review');
        },
      );
    },
  );
}

// Main screen showing the "Edit Review" button
class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showEditReviewDialog(context); // Show the edit review dialog
          },
          child: Text('Edit Review'),
        ),
      ),
    );
  }
}

// Entry point of the app
void main() {
  runApp(MaterialApp(
    home: ReviewScreen(),
    debugShowCheckedModeBanner: false, // Disable the debug banner
  ));
}
