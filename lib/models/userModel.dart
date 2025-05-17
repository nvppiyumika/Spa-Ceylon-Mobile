import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String mobile;
  final String nationality;
  final String gender;
  final String nic;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? birthday; // New field for birthday

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.mobile,
    required this.nationality,
    required this.gender,
    required this.nic,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.birthday, // Optional field
  });

  // Create an empty user
  factory UserModel.empty() {
    return UserModel(
      uid: '',
      username: '',
      email: '',
      mobile: '',
      nationality: '',
      gender: '',
      nic: '',
      photoUrl: null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      birthday: null, // Default to null
    );
  }

  // Create a user from Firebase user data (Map)
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
      nationality: data['nationality'] ?? '',
      gender: data['gender'] ?? '',
      nic: data['nic'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      birthday: data['birthday'] != null
          ? (data['birthday'] as Timestamp).toDate()
          : null, // Parse birthday from Timestamp
    );
  }

  // Convert user data to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'mobile': mobile,
      'nationality': nationality,
      'gender': gender,
      'nic': nic,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'birthday': birthday, // Add birthday to map
    };
  }

  // Create a copy of the user with updated fields
  UserModel copyWith({
    String? username,
    String? email,
    String? mobile,
    String? nationality,
    String? gender,
    String? nic,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? birthday, // Add birthday parameter
  }) {
    return UserModel(
      uid: this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      nationality: nationality ?? this.nationality,
      gender: gender ?? this.gender,
      nic: nic ?? this.nic,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      birthday: birthday ?? this.birthday, // Include birthday in copy
    );
  }
}
