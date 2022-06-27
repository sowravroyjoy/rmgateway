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
import 'package:rmgateway/screens/application_list.dart';
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

class ApplicationInfo extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> applyModel;

  const ApplicationInfo({Key? key, required this.applyModel}) : super(key: key);

  @override
  State<ApplicationInfo> createState() => _ApplicationInfoState();
}

class _ApplicationInfoState extends State<ApplicationInfo> {

  String? currentUserID;

  int totalLeads = 0;
  final TextEditingController searchController = TextEditingController();

  final List storedocs = [];
  bool search = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    currentUserID = FirebaseAuth.instance.currentUser?.uid;


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

    final sendSMSButton = TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SendSMS(singleNumber: widget.applyModel["contact"])));
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
                      SendEmail(singleEmail: widget.applyModel["email"])));
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
                                  .collection('apply')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                for (var doc in querySnapshot.docs) {
                                  if (doc["docID"] ==
                                      widget.applyModel["docID"]) {
                                    setState(() {
                                      doc.reference.delete();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ApplicationList()),
                                              (route) => false);
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
              context, MaterialPageRoute(builder: (context) => ApplicationList()));
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
                              widget.applyModel["name"],
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
                              "Information",
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
                                      _singleField("Title",
                                          widget.applyModel["title"]),
                                      _singleField(
                                          "Name", widget.applyModel["name"])
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _singleField("Contact",
                                          widget.applyModel["contact"]),
                                      _singleField("Email",
                                          widget.applyModel["email"])
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _singleField(
                                          "IELTS", widget.applyModel["ielts"]),
                                      _singleField("Origin Country",
                                          widget.applyModel["country"])
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _singleField(
                                          "Interested Country", widget.applyModel["interestedCountry"]),
                                      Text("")
                                    ],
                                  ),

                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      backButton,
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
                                    Text(""),
                                      _singleField("Application Date",
                                          DateFormat('yyyy-MM-dd K:mm:ss').format(widget.applyModel["timeStamp"].toDate()))
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
