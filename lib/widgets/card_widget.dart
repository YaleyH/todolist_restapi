import 'package:flutter/material.dart';
import 'package:restapi_again/models/item.dart';

class CardWidget extends StatelessWidget {
  final int index;
  final Item item;
  final Function(Item) navigateToEditPage;
  final Function(String) deleteById;

  const CardWidget({
    super.key,
    required this.index,
    required this.item,
    required this.navigateToEditPage,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text((index + 1).toString()),
        ),
        title: Text(item.title),
        subtitle: Text(item.description),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              navigateToEditPage(item);
            } else if (value == 'delete') {
              deleteById(item.id);
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              )
            ];
          },
        ),
      ),
    );
  }
}
