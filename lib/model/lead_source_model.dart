
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeadSourceModel {
  FieldValue? timeStamp;
  String? userID;
  String? name;
  String? docID;


  LeadSourceModel({
    this.timeStamp,
    this.userID,
    this.name,
    this.docID
  });


  factory LeadSourceModel.fromMap(map){
    return LeadSourceModel(
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
