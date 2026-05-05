import 'package:flutter/material.dart';
import 'item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> _items = [
    Item(id: 1, name: 'Item 1', description: 'Description for item 1'),
    Item(id: 2, name: 'Item 2', description: 'Description for item 2'),
    Item(id: 3, name: 'Item 3', description: 'Description for item 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items List'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(item.id.toString()),
            ),
            title: Text(item.name),
            subtitle: Text(item.description),
          );
        },
      ),
    );
  }


}