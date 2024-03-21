import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDataScreen extends StatefulWidget {
  final DocumentSnapshot document;

  const EditDataScreen({Key? key, required this.document}) : super(key: key);

  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.document['name']);
    _mobileController = TextEditingController(text: widget.document['mobile']);
    _addressController = TextEditingController(text: widget.document['address']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateData(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateData(BuildContext context) {
    final name = _nameController.text;
    final mobile = _mobileController.text;
    final address = _addressController.text;

    FirebaseFirestore.instance.collection('user_data').doc(widget.document.id).update({
      'name': name,
      'mobile': mobile,
      'address': address,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data updated successfully')));
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update data: $error')));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
