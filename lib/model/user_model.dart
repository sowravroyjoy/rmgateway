
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  FieldValue? timeStamp;
  String? userID;
  String? name;
  String? contact;
  String? email;
  String? userType;
  String? imageUrl;
  String? docID;


  UserModel({
    this.timeStamp,
    this.userID,
    this.name,
    this.contact,
    this.email,
    this.userType,
    this.imageUrl,
    this.docID
  });


  factory UserModel.fromMap(map){
    return UserModel(
      timeStamp: map["timeStamp"],
        userID: map["userID"],
        name: map['name'],
        contact: map['contact'],
        email: map["email"],
        userType: map["userType"],
        imageUrl: map["imageUrl"],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "timeStamp":timeStamp,
      "userID":userID,
      'name': name,
      'contact': contact,
      "email":email,
      "userType":userType,
      "imageUrl":imageUrl,
      'docID': docID
    };
  }
}
