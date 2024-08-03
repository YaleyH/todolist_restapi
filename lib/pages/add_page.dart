import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restapi_again/models/item.dart';

class AddPage extends StatefulWidget {
  final Item? item;
  const AddPage({super.key, this.item});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      titleController.text = item.title;
      descriptionController.text = item.description;
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit page' : 'Add Page'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(hintText: 'Description'),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final item = widget.item;
    if (item == null) {
     return;
    }
    final body = {
      'title': titleController.text,
      'description': descriptionController.text,
      'is_completed': false,
    };
    final json = jsonEncode(body);
    final id = item.id;
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: json,
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200) {
      showSuccessMessage('Update todo Success!');
    } else {
      showErrorMessage('Update todo Failed!');
    }
  }

  Future<void> submitData() async {
    final body = {
      'title': titleController.text,
      'description': descriptionController.text,
      'is_completed': false,
    };
    final json = jsonEncode(body);
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: json,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      showSuccessMessage('Submit Success!');
    } else {
      showErrorMessage('Submit Failed!');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
