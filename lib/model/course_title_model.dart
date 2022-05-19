
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseTitleModel {
  FieldValue? timeStamp;
  String? userID;
  String? name;
  String? docID;


  CourseTitleModel({
    this.timeStamp,
    this.userID,
    this.name,
    this.docID
  });


  factory CourseTitleModel.fromMap(map){
    return CourseTitleModel(
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
