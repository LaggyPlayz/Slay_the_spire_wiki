class Item {
  final int id;
  final String imagePath;
  final String title;

  const Item({required this.id, required this.imagePath, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath
    };
  }

  // Convert a Map from the DB back into a News object
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      imagePath: map['imagePath'],
    );
  }
}
