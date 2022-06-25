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

import 'admin_attendance.dart';
import 'create_lead.dart';
import 'create_student_type.dart';
import 'create_university.dart';

class TodayTask extends StatefulWidget {
  final String currentUserName;
  const TodayTask({Key? key, required this.currentUserName}) : super(key: key);

  @override
  State<TodayTask> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {
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

    FirebaseFirestore.instance
        .collection('leads')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {

        if(doc["assigned"].toString().toLowerCase() == widget.currentUserName.toLowerCase() && doc["taskStatus"].toString().toLowerCase() == "pending") {
          setState(() {
            totalLeads += 1;
            search = false;
            storedocs.clear();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final nameSearchField = Container(
        width: MediaQuery.of(context).size.width / 5,
        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Colors.pink.shade100,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
            cursorColor: Colors.black,
            autofocus: false,
            controller: searchController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("name cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              searchController.text = value!;
            },
            onChanged: (value) {
              setState(() {
                search = true;
              });
              nameSearch(value);
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Search Name',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black),
              ),
            )));

    final CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection("leads");

    Widget _buildListView() {
      return StreamBuilder<QuerySnapshot>(
          stream: _collectionReference.orderBy("timeStamp",  descending: true).snapshots().asBroadcastStream(),
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

              snapshot.data!.docs.where((element) => element["assigned"].toString().toLowerCase()==widget.currentUserName.toString().toLowerCase() &&  element["taskStatus"].toString().toLowerCase() == "pending")
                  .map((DocumentSnapshot document) {
                Map a = document.data() as Map<String, dynamic>;
                if (!search) {
                  storedocs.add(a);
                  a['id'] = document.id;
                }
              }).toList();



              return  Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                ),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        1: FixedColumnWidth(140),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Colors.cyan.shade100,
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
                                  color: Colors.cyan.shade100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Task Subject',
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
                                  color: Colors.cyan.shade100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Task Contact',
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
                                  color: Colors.cyan.shade100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Task Status',
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
                                  color: Colors.cyan.shade100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Change Task Status',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ]
                        ),


                        for(var i = 0 ; i< storedocs.length; i++)...[
                          TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          storedocs[i]["taskDueDate"],
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
                                          storedocs[i]["taskSubject"],
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
                                          storedocs[i]["taskContact"],
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
                                          storedocs[i]["taskStatus"],
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
                                          child: Column(
                                            children: [
                                              TextButton(
                                                onPressed: (){
                                                  changeStatus(storedocs[i]);
                                                },
                                                child: Text(
                                                  "Done",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.green
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          )
                        ]
                      ],
                    )
                ),
              );
            }
          });
    }

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
          Container(
            width: widthDrawer,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.cyan.shade700),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 80,
                        height: 80,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/demo.jpeg",
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: dropdownButtonField,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewLead()));
                      },
                      child: Text(
                        "Leads",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodayTask(currentUserName: currentUserName.toString(),)));
                      },
                      child: Text(
                        "Today's Task",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateLead()));
                      },
                      child: Text(
                        "Create Lead",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          for (var doc in querySnapshot.docs) {
                            if (doc["userID"].toString() == currentUserID &&doc["userType"].toString().toLowerCase() ==
                                "admin") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmployeeDetails()));
                            }
                          }
                        });
                      },
                      child: Text(
                        "Employee Details",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          for (var doc in querySnapshot.docs) {
                            if (doc["userID"].toString() == currentUserID &&
                                doc["userType"].toString().toLowerCase() ==
                                    "admin") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminAttendance()));
                            } else if (doc["userID"].toString() ==
                                currentUserID) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Attendance(employeeModel: doc)));
                            }
                          }
                        });
                      },
                      child: Text(
                        "Attendance",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SendSMS()));
                      },
                      child: Text(
                        "Sms",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendEmail()));
                      },
                      child: Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Apply()));
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  propertyField
                ],
              ),
            ),
          ),
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
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 20.0),
                                    decoration: BoxDecoration(
                                        color: Colors.pink.shade100,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Text("Total Leads  :  $totalLeads"),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  nameSearchField,
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _buildListView()
                      ],
                    )),
              ),
    ]
            ),
          ),
        ],
      ),
    );
  }

  void nameSearch(String value) async {
    final documents = await FirebaseFirestore.instance
        .collection('leads')
        .orderBy("timeStamp", descending: true).where("assigned",isEqualTo: widget.currentUserName).where("taskStatus", isEqualTo: "pending")
        .get();
    if (value != "") {
      storedocs.clear();
      for (var doc in documents.docs) {
        if (doc["taskSubject"].toString().toLowerCase().contains(value.toLowerCase())) {
          storedocs.add(doc);
          setState(() {});
        }
      }
    } else {
      setState(() {
        search = false;
        storedocs.clear();
      });
    }
  }

  void changeStatus( document)async {
    await FirebaseFirestore.instance
        .collection('leads')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc.id ==document["docID"] ){

          final ref =   FirebaseFirestore.instance.collection("leads").doc(document["docID"]);
          LeadModel leadModel = LeadModel();
          leadModel.timeStamp = FieldValue.serverTimestamp();
          leadModel.userID = document["userID"];
          leadModel.firstName =document["firstName"];
          leadModel.lastName = document["lastName"];
          leadModel.studentType = document["studentType"];
          leadModel.email = document["email"];
          leadModel.phone = document["phone"];
          leadModel.applyCountry =document["applyCountry"];
          leadModel.originCountry = document["originCountry"];
          leadModel.optionalPhone = document["optionalPhone"];
          leadModel.visaIssued = document["visaIssued"];
          leadModel.visaExpired =document["visaExpired"];
          leadModel.immigrationHistory = document["immigrationHistory"];
          leadModel.comments =document["comments"];
          leadModel.courseLevel = document["courseLevel"];
          leadModel.courseTitle = document["courseTitle"];
          leadModel.intakeYear =  document["intakeYear"];
          leadModel.intakeMonth =  document["intakeMonth"];
          leadModel.preQLevel =  document["preQLevel"];
          leadModel.preQTitle =  document["preQTitle"];
          leadModel.recQLevel = document["recQLevel"];
          leadModel.recQTitle = document["recQTitle"];
          leadModel.workExperience =  document["workExperience"];
          leadModel.studyGap =  document["studyGap"];
          leadModel.ielts =  document["ielts"];
          leadModel.ieltsResult = document["ieltsResult"];
          leadModel.ieltsDate =  document["ieltsDate"];
          leadModel.firstChoice = document["firstChoice"];
          leadModel.secondChoice =  document["secondChoice"];
          leadModel.thirdChoice =  document["thirdChoice"];
          leadModel.fourthChoice = document["fourthChoice"];
          leadModel.docApplicationForm = document["docApplicationForm"];
          leadModel.docCV =  document["docCV"];
          leadModel.docAcademic = document["docAcademic"];
          leadModel.docAttendance = document["docAttendance"];
          leadModel.docWorkExperience = document["docWorkExperience"];
          leadModel.docSOP =document["docSOP"];
          leadModel.docPassport =document["docPassport"];
          leadModel.docSponsor = document["docSponsor"];
          leadModel.docIELTSTest =document["docIELTSTest"];
          leadModel.docBank = document["docBank"];
          leadModel.status = document["status"];
          leadModel.statusDes =document["statusDes"];
          leadModel.leadSource =document["leadSource"];
          leadModel.leadSourceDes =document["leadSourceDes"];
          leadModel.weightage = document["weightage"];
          leadModel.assigned = document["assigned"];
          leadModel.taskSubject = document["taskSubject"];
          leadModel.taskContact =document["taskContact"];
          leadModel.taskDueDate =  document["taskDueDate"];
          leadModel.taskStatus = "done";
          leadModel.courseName = document["courseName"];
          leadModel.tutionFee = document["tutionFee"];
          leadModel.universityName = document["universityName"];
          leadModel.applicationStatus = document["applicationStatus"];
          leadModel.intakeYearApplied = document["intakeYearApplied"];
          leadModel.intakeMonthApplied = document["intakeMonthApplied"];
          leadModel.modifiedBy = widget.currentUserName;
          leadModel.modifiedDate = FieldValue.serverTimestamp();
          leadModel.docID = ref.id;
          ref.set(leadModel.toMap())
              .whenComplete(() {
            ScaffoldMessenger.of(
                context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors
                        .green,
                    content: Text(
                        "Task Status Changed!!")));
            setState(() {

            });
          }
          ).catchError((onError){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red, content: Text("Something is wrong!!")));
          });
        }
      }
    });
  }


}
