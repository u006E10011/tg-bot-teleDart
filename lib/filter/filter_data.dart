class FilterData {
  final String command;
  final String type;
  final String id;
  final String text;
  final DateTime createdAt;

  FilterData({
    required this.command,
    required this.type,
    required this.id,
    required this.text,
    required this.createdAt,
  });


  Map<String, dynamic> toJson() {
    return {
      'command': command,
      'type': type,
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FilterData.fromJson(Map<String, dynamic> json) {
    return FilterData(
      command: json['command'],
      type: json['type'],
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
