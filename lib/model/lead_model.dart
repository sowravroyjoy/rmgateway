
import 'package:cloud_firestore/cloud_firestore.dart';

class LeadModel {
  FieldValue? timeStamp;
  String? userID;
  String? firstName;
  String? lastName;
  String? studentType;
  String? email;
  String? phone;
  String? applyCountry;
  String? originCountry;
  String? optionalPhone;
  String? visaIssued;
  String? visaExpired;
  String? immigrationHistory;
  String? comments;
  String? courseLevel;
  String? courseTitle;
  String? intakeYear;
  String? intakeMonth;
  String? preQLevel;
  String? preQTitle;
  String? recQLevel;
  String? recQTitle;
  String? workExperience;
  String? studyGap;
  String? ielts;
  String? ieltsResult;
  String? ieltsDate;
  String? firstChoice;
  String? secondChoice;
  String? thirdChoice;
  String? fourthChoice;
  String? docApplicationForm;
  String? docCV;
  String? docAcademic;
  String? docAttendance;
  String? docWorkExperience;
  String? docSOP;
  String? docPassport;
  String? docSponsor;
  String? docIELTSTest;
  String? docBank;
  String? docRecommendationLetter;
  String? docApplicationFormLink;
  String? docCVLink;
  String? docAcademicLink;
  String? docAttendanceLink;
  String? docWorkExperienceLink;
  String? docSOPLink;
  String? docPassportLink;
  String? docSponsorLink;
  String? docIELTSTestLink;
  String? docBankLink;
  String? docRecommendationLetterLink;
  String? status;
  String? statusDes;
  String? leadSource;
  String? leadSourceDes;
  String? weightage;
  String? assigned;
  String? taskSubject;
  String? taskContact;
  String? taskDueDate;
  String? taskStatus;
  String? courseName;
  String? tutionFee;
  String? universityName;
  String? applicationStatus;
  String? intakeYearApplied;
  String? intakeMonthApplied;
  String? modifiedBy;
  FieldValue? modifiedDate;
  String? docID;


  LeadModel({
    this.timeStamp,
    this.userID,
    this.firstName,
    this.lastName,
    this.studentType,
    this.email,
    this.phone,
    this.applyCountry,
    this.originCountry,
    this.optionalPhone,
    this.visaIssued,
    this.visaExpired,
    this.immigrationHistory,
    this.comments,
    this.courseLevel,
    this.courseTitle,
    this.intakeYear,
    this.intakeMonth,
    this.preQLevel,
    this.preQTitle,
    this.recQLevel,
    this.recQTitle,
    this.workExperience,
    this.studyGap,
    this.ielts,
    this.ieltsResult,
    this.ieltsDate,
    this.firstChoice,
    this.secondChoice,
    this.thirdChoice,
    this.fourthChoice,
    this.docApplicationForm,
    this.docCV,
    this.docAcademic,
    this.docAttendance,
    this.docWorkExperience,
    this.docSOP,
    this.docPassport,
    this.docSponsor,
    this.docIELTSTest,
    this.docBank,
    this.docRecommendationLetter,
    this.docApplicationFormLink,
    this.docCVLink,
    this.docAcademicLink,
    this.docAttendanceLink,
    this.docWorkExperienceLink,
    this.docSOPLink,
    this.docPassportLink,
    this.docSponsorLink,
    this.docIELTSTestLink,
    this.docBankLink,
    this.docRecommendationLetterLink,
    this.status,
    this.statusDes,
    this.leadSource,
    this.leadSourceDes,
    this.weightage,
    this.assigned,
    this.taskSubject,
    this.taskContact,
    this.taskDueDate,
    this.taskStatus,
    this.courseName,
    this.tutionFee,
    this.universityName,
    this.applicationStatus,
    this.intakeYearApplied,
    this.intakeMonthApplied,
    this.modifiedBy,
    this.modifiedDate,
    this.docID,
  });


  factory LeadModel.fromMap(map){
    return LeadModel(
        timeStamp: map["timeStamp"],
        userID: map["userID"],
      firstName: map['firstName'],
      lastName: map['lastName'],
      studentType: map["studentType"],
      email: map["email"],
      phone: map['phone'],
      applyCountry: map['applyCountry'],
      originCountry: map["originCountry"],
      optionalPhone: map["optionalPhone"],
      visaIssued: map['visaIssued'],
      visaExpired: map['visaExpired'],
      immigrationHistory: map["immigrationHistory"],
      comments: map["comments"],
      courseLevel: map['courseLevel'],
      courseTitle: map['courseTitle'],
      intakeYear: map["intakeYear"],
      intakeMonth: map["intakeMonth"],
      preQLevel: map['preQLevel'],
      preQTitle: map['preQTitle'],
      recQLevel: map["recQLevel"],
      recQTitle: map["recQTitle"],
      workExperience: map['workExperience'],
      studyGap: map['studyGap'],
      ielts: map["ielts"],
      ieltsResult: map["ieltsResult"],
      ieltsDate: map['ieltsDate'],
      firstChoice: map['firstChoice'],
      secondChoice: map["secondChoice"],
      thirdChoice: map["thirdChoice"],
      fourthChoice: map['fourthChoice'],
      docApplicationForm: map['docApplicationForm'],
      docCV: map["docCV"],
      docAcademic: map["docAcademic"],
      docAttendance: map['docAttendance'],
      docWorkExperience: map['docWorkExperience'],
      docSOP: map["docSOP"],
      docPassport: map["docPassport"],
      docSponsor: map['docSponsor'],
      docIELTSTest: map['docIELTSTest'],
      docBank: map["docBank"],
      docRecommendationLetter: map["docRecommendationLetter"],
      docApplicationFormLink: map['docApplicationFormLink'],
      docCVLink: map["docCVLink"],
      docAcademicLink: map["docAcademicLink"],
      docAttendanceLink: map['docAttendanceLink'],
      docWorkExperienceLink: map['docWorkExperienceLink'],
      docSOPLink: map["docSOPLink"],
      docPassportLink: map["docPassportLink"],
      docSponsorLink: map['docSponsorLink'],
      docIELTSTestLink: map['docIELTSTestLink'],
      docBankLink: map["docBankLink"],
      docRecommendationLetterLink: map["docRecommendationLetterLink"],
      status: map["status"],
      statusDes: map['statusDes'],
      leadSource: map['leadSource'],
      leadSourceDes: map["leadSourceDes"],
      weightage: map["weightage"],
      assigned: map['assigned'],
      taskSubject: map['taskSubject'],
      taskContact: map["taskContact"],
      taskDueDate: map["taskDueDate"],
      taskStatus: map["taskStatus"],
      courseName: map['courseName'],
      tutionFee: map['tutionFee'],
      universityName: map["universityName"],
      applicationStatus: map["applicationStatus"],
      intakeYearApplied: map["intakeYearApplied"],
      intakeMonthApplied: map["intakeMonthApplied"],
      modifiedBy: map['modifiedBy'],
      modifiedDate: map['modifiedDate'],
      docID: map['docID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "timeStamp":timeStamp,
      "userID":userID,
      'firstName': firstName,
      'lastName': lastName,
      "studentType":studentType,
      "email":email,
      'phone': phone,
      'applyCountry': applyCountry,
      "originCountry":originCountry,
      "optionalPhone":optionalPhone,
      'visaIssued': visaIssued,
      'visaExpired': visaExpired,
      "immigrationHistory":immigrationHistory,
      "comments":comments,
      'courseLevel': courseLevel,
      'courseTitle': courseTitle,
      'intakeYear': intakeYear,
      "intakeMonth":intakeMonth,
      "preQLevel":preQLevel,
      'preQTitle': preQTitle,
      'recQLevel': recQLevel,
      "recQTitle":recQTitle,
      "workExperience":workExperience,
      'studyGap': studyGap,
      'ielts': ielts,
      "ieltsResult":ieltsResult,
      "ieltsDate":ieltsDate,
      'firstChoice': firstChoice,
      'secondChoice': secondChoice,
      'thirdChoice': thirdChoice,
      "fourthChoice":fourthChoice,
      "docApplicationForm":docApplicationForm,
      'docCV': docCV,
      'docAcademic': docAcademic,
      "docAttendance":docAttendance,
      "docWorkExperience":docWorkExperience,
      'docSOP': docSOP,
      'docPassport': docPassport,
      "docSponsor":docSponsor,
      "docIELTSTest":docIELTSTest,
      'docBank': docBank,
      'docRecommendationLetter': docRecommendationLetter,
      "docApplicationFormLink":docApplicationFormLink,
      'docCVLink': docCVLink,
      'docAcademicLink': docAcademicLink,
      "docAttendanceLink":docAttendanceLink,
      "docWorkExperienceLink":docWorkExperienceLink,
      'docSOPLink': docSOPLink,
      'docPassportLink': docPassportLink,
      "docSponsorLink":docSponsorLink,
      "docIELTSTestLink":docIELTSTestLink,
      'docBankLink': docBankLink,
      'docRecommendationLetterLink': docRecommendationLetterLink,
      'status': status,
      "statusDes":statusDes,
      "leadSource":leadSource,
      "leadSourceDes":leadSourceDes,
      'weightage': weightage,
      'assigned': assigned,
      'taskSubject': taskSubject,
      'taskContact': taskContact,
      "taskDueDate":taskDueDate,
      "taskStatus":taskStatus,
      "courseName":courseName,
      'tutionFee': tutionFee,
      'universityName': universityName,
      "applicationStatus":applicationStatus,
      'intakeYearApplied': intakeYearApplied,
      "intakeMonthApplied":intakeMonthApplied,
      "modifiedBy":modifiedBy,
      'modifiedDate': modifiedDate,
      'docID': docID,
    };
  }
}
