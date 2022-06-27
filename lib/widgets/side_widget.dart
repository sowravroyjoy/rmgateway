import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rmgateway/screens/application_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/admin_attendance.dart';
import '../screens/apply.dart';
import '../screens/attendance.dart';
import '../screens/create_country.dart';
import '../screens/create_course_level.dart';
import '../screens/create_course_title.dart';
import '../screens/create_lead.dart';
import '../screens/create_lead_source.dart';
import '../screens/create_status.dart';
import '../screens/create_student_type.dart';
import '../screens/create_university.dart';
import '../screens/create_weightage.dart';
import '../screens/employee_details.dart';
import '../screens/send_email.dart';
import '../screens/send_sms.dart';
import '../screens/signin.dart';
import '../screens/today_task.dart';
import '../screens/user_profile.dart';
import '../screens/view_lead.dart';

class SideWidget extends StatefulWidget {
  const SideWidget({Key? key}) : super(key: key);

  @override
  State<SideWidget> createState() => _SideWidgetState();
}

class _SideWidgetState extends State<SideWidget> {

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

    return  Container(
      width: widthDrawer,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Colors.cyan.shade700),
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ViewLead()));
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
                        builder: (context) => TodayTask(
                          currentUserName: currentUserName.toString(),
                        )));
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
                    if (doc["userID"].toString() == currentUserID &&
                        doc["userType"].toString().toLowerCase() ==
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SendEmail()));
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
                    MaterialPageRoute(builder: (context) => ApplicationList()));
              },
              child: Text(
                "Application List",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 10,
          ),
          propertyField
        ],
      ),
    );
  }
}
