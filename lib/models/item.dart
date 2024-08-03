class Item {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['is_completed'],
    );
  }
}
