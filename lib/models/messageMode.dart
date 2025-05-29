import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String sender;
  final String message;
  final String time;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.sender,
    required this.message,
    required this.time,
    required this.timestamp,
  });

  // Create a MessageModel from Firestore document
  factory MessageModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MessageModel(
      id: doc.id,
      sender: data['sender'] ?? '',
      message: data['message'] ?? '',
      time: data['time'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert MessageModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'message': message,
      'time': time,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}