import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    // Regular expression for a 10-digit mobile number
    RegExp regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  void submitData() {
    if (_validateName(_nameController.text) == null &&
        _validateMobile(_mobileController.text) == null &&
        _validateAddress(_addressController.text) == null) {
      String name = _nameController.text;
      String mobile = _mobileController.text;
      String address = _addressController.text;

      _firestore.collection('user_data').add({
        'name': name,
        'mobile': mobile,
        'address': address,
      }).then((value) {
        // Data submitted successfully
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Data submitted successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }).catchError((error) {
        // Error occurred while submitting data
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to submit data. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Data Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: _validateName,
            ),
            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
              validator: _validateMobile,
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: _validateAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_validateName(_nameController.text) == null &&
                    _validateMobile(_mobileController.text) == null &&
                    _validateAddress(_addressController.text) == null) {
                  submitData();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
