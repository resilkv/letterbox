class Letter {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String message;
  final DateTime sentAt;
  final DateTime? deliveredAt;
  final String status; // sent, in_transit, delivered


  Letter({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.message,
    required this.sentAt,
    this.deliveredAt,
    this.status = 'sent',
    });


Map<String, dynamic> toJson() => {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'message': message,
      'sentAt': sentAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'status': status,
    };


  factory Letter.fromJson(Map<String, dynamic> json) => Letter(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'] ?? '',
      receiverId: json['receiverId'],
      receiverName: json['receiverName'] ?? '',
      message: json['message'],
      sentAt: DateTime.parse(json['sentAt']),
      deliveredAt: json['deliveredAt'] != null
      ? DateTime.parse(json['deliveredAt'])
      : null,
      status: json['status'] ?? 'sent',
    );
  }
