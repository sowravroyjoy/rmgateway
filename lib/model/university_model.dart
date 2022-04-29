
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UniversityModel {
  FieldValue? timeStamp;
  String? userID;
  String? name;
  String? address;
  String? docID;


  UniversityModel({
    this.timeStamp,
    this.userID,
    this.name,
    this.address,
    this.docID
  });


  factory UniversityModel.fromMap(map){
    return UniversityModel(
        timeStamp: map["timeStamp"],
        userID: map["userID"],
        name: map['name'],
        address: map['address'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "timeStamp":timeStamp,
      "userID":userID,
      'name': name,
      'address': address,
      'docID': docID
    };
  }
}
