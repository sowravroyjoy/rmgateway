
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceModel {
  FieldValue? timeStamp;
  FieldValue? inTimeStamp;
  FieldValue? outTimeStamp;
  String? employeeID;
  String? employeeName;
  String? dTimestamp;
  String? docID;


  AttendanceModel({
    this.timeStamp,
    this.inTimeStamp,
    this.outTimeStamp,
    this.employeeID,
    this.employeeName,
    this.dTimestamp,
    this.docID
  });


  factory AttendanceModel.fromMap(map){
    return AttendanceModel(
        timeStamp: map["timeStamp"],
        inTimeStamp: map["inTimeStamp"],
        outTimeStamp: map["outTimeStamp"],
        employeeID: map['employeeID'],
        employeeName: map['employeeName'],
        dTimestamp: map['dTimestamp'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "timeStamp":timeStamp,
      "inTimeStamp":inTimeStamp,
      "outTimeStamp":outTimeStamp,
      'employeeID': employeeID,
      'employeeName': employeeName,
      'dTimestamp': dTimestamp,
      'docID': docID
    };
  }
}
