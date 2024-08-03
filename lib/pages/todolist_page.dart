import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:restapi_again/models/item.dart';
import 'package:restapi_again/pages/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:restapi_again/widgets/card_widget.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  List<Item> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: getData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(child: Text('No Items'),),
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return CardWidget(
                  index: index,
                  item: item,
                  navigateToEditPage: navigateToEditPage,
                  deleteById: deleteById,
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add page'),
      ),
    );
  }

  Future<void> getData() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map;
      final json = body['items'] as List;
      setState(() {
        items = json.map((e) {
          return Item.fromJson(e as Map<String, dynamic>);
        }).toList();
      });
    } else {
      showErrorMessage('Get Data Failed!');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode == 200) {
      final newItems = items.where((element) => element.id != id).toList();
      setState(() {
        items = newItems;
      });
    } else {
      showErrorMessage('Deletion Failed!');
    }
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (_) => const AddPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    getData();
  }

  Future<void> navigateToEditPage(Item item) async {
    final route = MaterialPageRoute(builder: (_) => AddPage(item: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    getData();
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
