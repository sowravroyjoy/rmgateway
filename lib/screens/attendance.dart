import 'dart:html';
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

import '../model/attendance_model.dart';
import '../widgets/side_widget.dart';
import 'admin_attendance.dart';
import 'create_lead.dart';
import 'create_student_type.dart';
import 'create_university.dart';

class Attendance extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> employeeModel;

  const Attendance({Key? key, required this.employeeModel}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
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

  bool _processi = false;
  bool _processo = false;
  int _counti = 1;
  int _counto = 1;

  bool _showOut = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
    final CollectionReference _collectionReference =
        FirebaseFirestore.instance.collection("attendance");

    Widget _buildListView() {
      return StreamBuilder<QuerySnapshot>(
          stream: _collectionReference
              .orderBy("timeStamp", descending: true)
              .snapshots()
              .asBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went Wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: Text('Empty'),
              );
            } else {
              final List storedocs = [];
              snapshot.data!.docs
                  .where((element) =>
                      element["employeeID"] == widget.employeeModel["docID"])
                  .map((DocumentSnapshot document) {
                Map a = document.data() as Map<String, dynamic>;
                storedocs.add(a);
                a['id'] = document.id;
              }).toList();

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        1: FixedColumnWidth(140),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          TableCell(
                            child: Container(
                              color: Colors.cyan.shade300,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Date',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.cyan.shade300,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.cyan.shade300,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Clock In',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.cyan.shade300,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Clock Out',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        for (var i = 0; i < storedocs.length; i++) ...[
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      (storedocs[i]["timeStamp"] != null)
                                          ? DateFormat('dd-MMM-yyyy').format(
                                              storedocs[i]["timeStamp"]
                                                  .toDate())
                                          : "Loading...",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      storedocs[i]["employeeName"],
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      (storedocs[i]["inTimeStamp"] != null)
                                          ? (storedocs[i]["dTimestamp"] !=
                                                  "out")
                                              ? DateFormat('K:mm:ss').format(
                                                  storedocs[i]["inTimeStamp"]
                                                      .toDate())
                                              : "0"
                                          : "Loading...",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      (storedocs[i]["outTimeStamp"] != null)
                                          ? (storedocs[i]["dTimestamp"] ==
                                                  "out")
                                              ? DateFormat('K:mm:ss').format(
                                                  storedocs[i]["outTimeStamp"]
                                                      .toDate())
                                              : "0"
                                          : "Loading...",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])
                        ]
                      ],
                    )),
              );
            }
          });
    }

    final inButton = Material(
      elevation: (_processi) ? 0 : 5,
      color: (_processi) ? Colors.pinkAccent.shade700 : Colors.pinkAccent,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          100,
          20,
          100,
          20,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _processi = true;
            _counti = (_counti - 1);
          });
          (_counti < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red, content: Text("Wait Please!!")))
              : AddInData();
        },
        child: (_processi)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Wait',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ))),
                ],
              )
            : Text(
                '  Clock In  ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
      ),
    );

    final outButton = Material(
      elevation: (_processo) ? 0 : 5,
      color: (_processo) ? Colors.pinkAccent.shade700 : Colors.pinkAccent,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          100,
          20,
          100,
          20,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _processo = true;
            _counto = (_counto - 1);
          });
          (_counto < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red, content: Text("Wait Please!!")))
              : AddOutData();
        },
        child: (_processo)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Wait',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ))),
                ],
              )
            : Text(
                '  Clock Out  ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
      ),
    );

    final dropdownButtonField = DropdownButton(
      focusColor: Colors.cyan.shade700,
      borderRadius: BorderRadius.circular(10),
      underline: DropdownButtonHideUnderline(child: Container()),
      dropdownColor: Colors.white,
      hint: Text(
        userName,
        style: TextStyle(color: Colors.white),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: TextButton(
            onPressed: () {
              if (items.contains("Logout")) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text("Confirm"),
                          content: Text("Do you want to log out?"),
                          actions: [
                            IconButton(
                                icon: new Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            IconButton(
                                icon: new Icon(Icons.logout),
                                onPressed: () {
                                  FirebaseAuth.instance
                                      .signOut()
                                      .catchError((onError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text("Log out failed!!")));
                                    Navigator.pop(context);
                                  }).whenComplete(() async {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignIn()),
                                        (route) => false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text("Logged out!!")));
                                    SharedPreferences _pref =
                                        await SharedPreferences.getInstance();
                                    _pref.remove("email");
                                    _pref.remove("password");
                                  });
                                })
                          ],
                        ));
              } else {
                FirebaseFirestore.instance
                    .collection('users')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if (doc["userID"].toString() == currentUserID) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserProfile(userModel: doc)));
                    }
                  }
                });
              }
            },
            child: Text(
              items,
              style: TextStyle(color: Colors.cyan.shade700),
            ),
          ),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {},
    );

    final propertyField = DropdownButton(
      focusColor: Colors.cyan.shade700,
      borderRadius: BorderRadius.circular(10),
      underline: DropdownButtonHideUnderline(child: Container()),
      dropdownColor: Colors.white,
      hint: Text(
        "Add Property",
        style: TextStyle(color: Colors.white),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      items: properties.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: TextButton(
            onPressed: () {
              if (items.contains("Add Country")) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CreateCountry()));
              } else if (items.contains("Add University")) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateUniversity()));
              } else if (items.contains("Add Course Level")) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateCourseLevel()));
              } else if (items.contains("Add Course Title")) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateCourseTitle()));
              } else if (items.contains("Add Lead Source")) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateLeadSource()));
              } else if (items.contains("Add Status")) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CreateStatus()));
              } else if (items.contains("Add Student Type")) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateStudentType()));
              } else if (items.contains("Add Weightage")) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CreateWeightage()));
              }
            },
            child: Text(
              items,
              style: TextStyle(color: Colors.cyan.shade700),
            ),
          ),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {},
    );

    final widthDrawer = MediaQuery.of(context).size.width / 6;
    final widthMain = widthDrawer * 5;

    return Scaffold(
      body: Row(
        children: [
          SideWidget(),
          Expanded(
            child: Stack(children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/demo.jpeg"),
                        fit: BoxFit.cover,
                        opacity: 0.09),
                  ),
                ),
              ),
              Container(
                width: widthMain,
                height: MediaQuery.of(context).size.height,

                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [inButton, outButton],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildListView()
                  ],
                )),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void AddInData() async {
    final ref = FirebaseFirestore.instance.collection("attendance").doc();

    AttendanceModel attendanceModel = AttendanceModel();
    attendanceModel.timeStamp = FieldValue.serverTimestamp();
    attendanceModel.inTimeStamp = FieldValue.serverTimestamp();
    attendanceModel.outTimeStamp = FieldValue.serverTimestamp();
    attendanceModel.employeeID = widget.employeeModel["docID"];
    attendanceModel.employeeName = widget.employeeModel["name"];
    attendanceModel.dTimestamp = "in";
    attendanceModel.docID = ref.id;
    await ref.set(attendanceModel.toMap());
    setState(() {
      _processi = false;
      _counti = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Clock In Added!!")));
  }

  void AddOutData() async {
    final ref = FirebaseFirestore.instance.collection("attendance").doc();
    AttendanceModel attendanceModel = AttendanceModel();
    attendanceModel.timeStamp = FieldValue.serverTimestamp();
    attendanceModel.inTimeStamp = FieldValue.serverTimestamp();
    attendanceModel.outTimeStamp = FieldValue.serverTimestamp();
    attendanceModel.employeeID = widget.employeeModel["docID"];
    attendanceModel.employeeName = widget.employeeModel["name"];
    attendanceModel.dTimestamp = "out";
    attendanceModel.docID = ref.id;
    await ref.set(attendanceModel.toMap());
    setState(() {
      _processo = false;
      _counto = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Clock Out Added!!")));
  }
}
