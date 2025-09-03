class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime dateTime;
  final double price;
  final String imageUrl;
  final int rows;
  final int cols;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.dateTime,
    required this.price,
    required this.imageUrl,
    this.rows = 8,
    this.cols = 12,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        location: json['location'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        rows: json['rows'] as int? ?? 8,
        cols: json['cols'] as int? ?? 12,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'dateTime': dateTime.toIso8601String(),
        'price': price,
        'imageUrl': imageUrl,
        'rows': rows,
        'cols': cols,
      };
}
