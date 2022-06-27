
import 'package:cloud_firestore/cloud_firestore.dart';


class ApplyModel {
  FieldValue? timeStamp;
  String? title;
  String? name;
  String? contact;
  String? email;
  String? ielts;
  String? country;
  String? interestedCountry;
  String? docID;


  ApplyModel({
    this.timeStamp,
    this.title,
    this.name,
    this.contact,
    this.email,
    this.ielts,
    this.country,
    this.interestedCountry,
    this.docID
  });


  factory ApplyModel.fromMap(map){
    return ApplyModel(
        timeStamp: map["timeStamp"],
        title: map["title"],
        name: map['name'],
        contact: map['contact'],
        email: map["email"],
        ielts: map["ielts"],
        country: map['country'],
        interestedCountry: map['interestedCountry'],
        docID: map['docID']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "timeStamp":timeStamp,
      "title":title,
      'name': name,
      'contact': contact,
      "email":email,
      "ielts":ielts,
      'country': country,
      'interestedCountry': interestedCountry,
      'docID': docID
    };
  }
}
