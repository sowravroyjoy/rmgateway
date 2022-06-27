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
import 'package:rmgateway/screens/application_info.dart';
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
import 'package:rmgateway/widgets/side_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_attendance.dart';
import 'create_lead.dart';
import 'create_student_type.dart';
import 'create_university.dart';

class ApplicationList extends StatefulWidget {
  const ApplicationList({Key? key}) : super(key: key);

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {

  int totalApplications = 0;
  final TextEditingController searchController = TextEditingController();

  final List storedocs = [];
  bool search = false;

  String? currentUserID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('apply')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          totalApplications += 1;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    currentUserID = FirebaseAuth.instance.currentUser?.uid;

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
               if(value.isNotEmpty){
                 search = true;
               }else{
                 search = false;
               }
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
    FirebaseFirestore.instance.collection("apply");

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
              if (!search) {
                storedocs.clear();
                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map a = document.data() as Map<String, dynamic>;
                  storedocs.add(a);
                  a['id'] = document.id;
                }).toList();
              }
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        1: FixedColumnWidth(140),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
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
                              color: Colors.cyan.shade100,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Contact',
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
                                    'Email',
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
                                    'Interested Country',
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
                                    'IELTS',
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
                                    'Delete',
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
                                          storedocs[i]["timeStamp"].toDate())
                                          : "Loading...",
                                      style: TextStyle(
                                        fontSize: 12.0,
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
                                    child: InkWell(
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('apply')
                                            .get()
                                            .then((QuerySnapshot querySnapshot) {
                                          for (var doc in querySnapshot.docs) {
                                            if (doc["docID"] ==
                                                storedocs[i]["docID"]) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ApplicationInfo(
                                                            applyModel: doc,
                                                          )));
                                            }
                                          }
                                        });
                                      },
                                      child: Text(
                                        storedocs[i]["name"] ?? "empty",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.cyan.shade900),
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
                                      storedocs[i]["contact"] ?? "empty",
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
                                      storedocs[i]["email"] ?? "empty",
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
                                      storedocs[i]["interestedCountry"] ?? "empty",
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
                                      storedocs[i]["ielts"] ?? "empty",
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
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text("Confirm"),
                                                  content: Text(
                                                      "Do you want to delete it?"),
                                                  actions: [
                                                    IconButton(
                                                        icon: new Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        }),
                                                    IconButton(
                                                        icon:
                                                        new Icon(Icons.delete),
                                                        onPressed: () {
                                                          FirebaseFirestore.instance
                                                              .collection('users')
                                                              .get()
                                                              .then((QuerySnapshot
                                                          querySnapshot) {
                                                            for (var doc
                                                            in querySnapshot
                                                                .docs) {
                                                              if (doc["userID"]
                                                                  .toString() ==
                                                                  currentUserID &&
                                                                  doc["userType"]
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                      "admin") {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                    'apply')
                                                                    .get()
                                                                    .then((QuerySnapshot
                                                                querySnapshot) {
                                                                  for (var doc
                                                                  in querySnapshot
                                                                      .docs) {
                                                                    if (doc["docID"] ==
                                                                        storedocs[i]
                                                                        [
                                                                        "docID"]) {
                                                                      setState(() {
                                                                        doc.reference
                                                                            .delete();
                                                                        setState(
                                                                                () {
                                                                              search =
                                                                              false;
                                                                              storedocs
                                                                                  .clear();
                                                                            });
                                                                        Navigator.pop(
                                                                            context);
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
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.black,
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

    final widthDrawer = MediaQuery.of(context).size.width / 6;
    final widthMain = widthDrawer * 5;

    return Scaffold(
      body: Row(
        children: [
          SideWidget(),
          Expanded(
            child: Stack(children: <Widget>[
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
                                    child: Text("Total Applications  :  $totalApplications"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  nameSearchField,
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
            ]),
          ),
        ],
      ),
    );
  }

  void nameSearch(String value) async {
    final documents = await FirebaseFirestore.instance
        .collection('apply')
        .orderBy("timeStamp", descending: true)
        .get();
    if (value != "") {
      storedocs.clear();
      for (var doc in documents.docs) {
        if (doc["name"]
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase())) {
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
}
