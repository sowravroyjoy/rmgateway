
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseLevelModel {
  FieldValue? timeStamp;
  String? userID;
  String? name;
  String? docID;


  CourseLevelModel({
    this.timeStamp,
    this.userID,
    this.name,
    this.docID
  });


  factory CourseLevelModel.fromMap(map){
    return CourseLevelModel(
        timeStamp: map["timeStamp"],
        userID: map["userID"],
        name: map['name'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "timeStamp":timeStamp,
      "userID":userID,
      'name': name,
      'docID': docID
    };
  }
}
