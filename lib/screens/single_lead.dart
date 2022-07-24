import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rmgateway/model/country_model.dart';
import 'package:rmgateway/model/course_title_model.dart';
import 'package:rmgateway/model/lead_model.dart';
import 'package:rmgateway/model/student_type_model.dart';
import 'package:rmgateway/model/university_model.dart';
import 'package:rmgateway/screens/apply.dart';
import 'package:rmgateway/screens/attendance.dart';
import 'package:rmgateway/screens/create_country.dart';
import 'package:rmgateway/screens/create_course_level.dart';
import 'package:rmgateway/screens/create_course_title.dart';
import 'package:rmgateway/screens/create_lead_source.dart';
import 'package:rmgateway/screens/create_status.dart';
import 'package:rmgateway/screens/create_weightage.dart';
import 'package:rmgateway/screens/employee_details.dart';
import 'package:rmgateway/screens/send_email.dart';
import 'package:rmgateway/screens/send_sms.dart';
import 'package:rmgateway/screens/signin.dart';
import 'package:rmgateway/screens/single_lead.dart';
import 'package:rmgateway/screens/today_task.dart';
import 'package:rmgateway/screens/update_country.dart';
import 'package:rmgateway/screens/update_course_title.dart';
import 'package:rmgateway/screens/update_lead.dart';
import 'package:rmgateway/screens/update_student_type.dart';
import 'package:rmgateway/screens/update_university.dart';
import 'package:rmgateway/screens/user_profile.dart';
import 'package:rmgateway/screens/view_lead.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/side_widget.dart';
import 'admin_attendance.dart';
import 'create_lead.dart';
import 'create_student_type.dart';
import 'create_university.dart';

class SingleLead extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> leadModel;

  const SingleLead({Key? key, required this.leadModel}) : super(key: key);

  @override
  State<SingleLead> createState() => _SingleLeadState();
}

class _SingleLeadState extends State<SingleLead> {
  bool? _process;
  int? _count;
  String? currentUserID;
  String? currentUserName;

  // Initial Selected Value
  String userName = 'Unknown';

  // List of items in our dropdown menu
  List<String> items = [];

  // List of items in our dropdown menu
  List<String> properties = [
    "Add Country",
    "Add University",
    "Add Course Level",
    "Add Lead Source",
    "Add Status",
    "Add Student Type",
    "Add Weightage"
  ];

  int totalLeads = 0;
  final TextEditingController searchController = TextEditingController();

  final List storedocs = [];
  bool search = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;

    currentUserID = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["userID"] == currentUserID) {
          setState(() {
            currentUserName = doc["name"];
            userName = doc["name"];
            items = [
              userName,
              'Logout',
            ];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _singleField(String topic, var value) {
      return Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 40,
        child: Row(
          children: [
            Text(
              topic + "  :   ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.cyan.shade900),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Text(
                    value.toString(),
                    style: TextStyle(),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _linkField(String topic, var value) {
      return Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 40,
          child: Row(
            children: [
              Text(
                topic + " : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.cyan.shade900),
              ),
              TextButton(
                onPressed: () async {
                  final downloadRef = await FirebaseStorage.instance
                      .ref()
                      .child("files/${widget.leadModel["docID"]}/$value")
                      .getDownloadURL();
                  html.AnchorElement anchorElement =
                      html.AnchorElement(href: downloadRef);
                  anchorElement.download = value;
                  anchorElement.click();
                },
                child: Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      child: Text(
                        value.toString(),
                        style: TextStyle(),
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      );
    }

    final editButton = TextButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('leads')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              if (doc["docID"] == widget.leadModel["docID"]) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateLead(leadModel: doc)));
              }
            }
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Edit",
            style: TextStyle(color: Colors.white),
          ),
        ));

    final sendSMSButton = TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SendSMS(singleNumber: widget.leadModel["phone"])));
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Colors.cyan.shade700,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "SMS",
            style: TextStyle(color: Colors.white),
          ),
        ));

    final sendEmailButton = TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SendEmail(singleEmail: widget.leadModel["email"])));
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Colors.yellow.shade900,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Email",
            style: TextStyle(color: Colors.white),
          ),
        ));

    final deleteButton = TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("Confirm"),
                    content: Text("Do you want to delete it?"),
                    actions: [
                      IconButton(
                          icon: new Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      IconButton(
                          icon: new Icon(Icons.delete),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                if (doc["userID"].toString() == currentUserID && doc["userType"].toString().toLowerCase() ==
                                    "admin") {
                                  FirebaseFirestore.instance
                                      .collection('leads')
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {
                                    for (var doc in querySnapshot.docs) {
                                      if (doc["docID"] ==
                                          widget.leadModel["docID"]) {
                                        setState(() {
                                          doc.reference.delete();
                                          Navigator.pop(context);
                                        });
                                      }
                                    }
                                  });
                                }
                              }
                            });
                          })
                    ],
                  ));
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ));

    final backButton = TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ViewLead()));
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Back",
            style: TextStyle(color: Colors.white),
          ),
        ));


    final widthDrawer = MediaQuery.of(context).size.width / 6;
    final widthMain = widthDrawer * 5;

    return Scaffold(
      body: Row(
        children: [
          SideWidget(),
          Expanded(
            child: Stack(
              children: [
            Center(
            child: Container(
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/demo.jpeg"), fit: BoxFit.cover,opacity: 0.09),
            ),
          ),
    ),
                Container(
                width: widthMain,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                        child: Text(
                          widget.leadModel["firstName"],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan.shade700),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "Personal Details",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("First Name",
                                      widget.leadModel["firstName"]),
                                  _singleField(
                                      "Last Name", widget.leadModel["lastName"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Student Type",
                                      widget.leadModel["studentType"]),
                                  _singleField("Apply Country",
                                      widget.leadModel["applyCountry"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField(
                                      "Email", widget.leadModel["email"]),
                                  _singleField("Origin Country",
                                      widget.leadModel["originCountry"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField(
                                      "Phone", widget.leadModel["phone"]),
                                  _singleField("Optional Phone",
                                      widget.leadModel["optionalPhone"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Visa Issued",
                                      widget.leadModel["visaIssued"]),
                                  _singleField("Visa Expired",
                                      widget.leadModel["visaExpired"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Immigration History",
                                      widget.leadModel["immigrationHistory"]),
                                  _singleField(
                                      "Comments", widget.leadModel["comments"])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "Interested Course",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Course Level",
                                      widget.leadModel["courseLevel"]),
                                  _singleField("Intake Year",
                                      widget.leadModel["intakeYear"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Course Title",
                                      widget.leadModel["courseTitle"]),
                                  _singleField("Intake Month",
                                      widget.leadModel["intakeMonth"])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "Previous Education & Experience",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Previous Qualification Level",
                                      widget.leadModel["preQLevel"]),
                                  _singleField("Recent Qualification Level",
                                      widget.leadModel["recQLevel"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Previous Qualification Title",
                                      widget.leadModel["preQTitle"]),
                                  _singleField("Recent Qualification Title",
                                      widget.leadModel["recQTitle"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Work Experience",
                                      widget.leadModel["workExperience"]),
                                  _singleField(
                                      "Study Gap", widget.leadModel["studyGap"])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "English Language Test",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField(
                                      "IELTS", widget.leadModel["ielts"]),
                                  _singleField("IELTS",
                                      widget.leadModel["ieltsResult"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("English Test/Future Test Date",
                                      widget.leadModel["ieltsDate"])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "Institution Choice",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("First Choice",
                                      widget.leadModel["firstChoice"]),
                                  _singleField("Third Choice",
                                      widget.leadModel["thirdChoice"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Second Choice",
                                      widget.leadModel["secondChoice"]),
                                  _singleField("Fourth Choice",
                                      widget.leadModel["fourthChoice"])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "RM Use Only",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField(
                                      "Status", widget.leadModel["status"]),
                                  _singleField("Lead Source",
                                      widget.leadModel["leadSource"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Status Description",
                                      widget.leadModel["statusDes"]),
                                  _singleField("Lead Source Description",
                                      widget.leadModel["leadSourceDes"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField(
                                      "Weightage", widget.leadModel["weightage"]),
                                  _singleField(
                                      "Assigned", widget.leadModel["assigned"])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "Documents",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _linkField("Completed Application Form",
                                      widget.leadModel["docApplicationForm"]),
                                  _linkField("Statement of Purpose ",
                                      widget.leadModel["docSOP"]),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _linkField("CV With 2 Reference",
                                      widget.leadModel["docCV"]),
                                  _linkField("Passport with Visa Copy",
                                      widget.leadModel["docPassport"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _linkField(
                                      "All Academic Certificate & Transcript",
                                      widget.leadModel["docAcademic"]),
                                  _linkField("Current Sponsor Confirmation",
                                      widget.leadModel["docSponsor"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _linkField("Letter of Attendance",
                                      widget.leadModel["docAttendance"]),
                                  _linkField("English Test",
                                      widget.leadModel["docIELTSTest"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _linkField("Work Experience Letter",
                                      widget.leadModel["docWorkExperience"]),
                                  _linkField("Bank Statement",
                                      widget.leadModel["docBank"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _linkField("Recommendation Letter",
                                      widget.leadModel["docRecommendationLetter"]),
                                 Text("")
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "Task",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Task Subject",
                                      widget.leadModel["taskSubject"]),
                                  _singleField("Task Contact",
                                      widget.leadModel["taskContact"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Task Due Date",
                                      widget.leadModel["taskDueDate"]),
                                  _singleField("Task Status",   widget.leadModel["taskStatus"])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "Application",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Course Name",
                                      widget.leadModel["courseName"]),
                                  _singleField("Tuition Fees",
                                      widget.leadModel["tutionFee"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("University",
                                      widget.leadModel["universityName"]),
                                  _singleField("Application Status",
                                      widget.leadModel["applicationStatus"])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Intake Month",
                                      widget.leadModel["intakeMonthApplied"]),
                                  _singleField("Intake Year",
                                      widget.leadModel["intakeYearApplied"])
                                ],
                              ),

                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  backButton,
                                  editButton,
                                  deleteButton,
                                  sendSMSButton,
                                  sendEmailButton
                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _singleField("Modified By",
                                      widget.leadModel["modifiedBy"]),
                                  _singleField("Modified Date",
                                      DateFormat('yyyy-MM-dd K:mm:ss').format(widget.leadModel["modifiedDate"].toDate()))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
    ]
            ),
          ),
        ],
      ),
    );
  }
}
