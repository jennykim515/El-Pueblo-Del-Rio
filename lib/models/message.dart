class Message {
  final String senderId;
  final String text;
  final int timestamp;

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  // Factory method to create Message object from JSON data
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }

  // Method to convert Message object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
