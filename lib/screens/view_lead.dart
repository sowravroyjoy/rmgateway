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
import 'package:rmgateway/widgets/side_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_attendance.dart';
import 'create_lead.dart';
import 'create_student_type.dart';
import 'create_university.dart';

class ViewLead extends StatefulWidget {
  const ViewLead({Key? key}) : super(key: key);

  @override
  State<ViewLead> createState() => _ViewLeadState();
}

class _ViewLeadState extends State<ViewLead> {
  final List<String> _users = [];
  String? _chosenUser;

  final List<String> _countries = [];
  String? _chosenCountry;

  final List<String> _currentCountry = [];
  String? _chosenCurrentCountry;

  final List<String> _leadSource = [];
  String? _chosenLeadSource;

  final List<String> _weightages = [];
  String? _chosenWeightage;

  final List<String> _intakeYears = [
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030"
  ];
  String? _chosenIntakeYear;

  final List<String> _status = [];
  String? _chosenStatus;

  DateTime? _dateCreated;
  DateTime? _taskFrom;
  DateTime? _taskTo;
  DateTime? _modifiedFrom;
  DateTime? _modifiedTo;
  DateTime? _visaExpired;

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

    FirebaseFirestore.instance
        .collection('leads')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          totalLeads += 1;
        });
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _users.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('countries')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _countries.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('countries')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _currentCountry.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('leadsource')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _leadSource.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('status')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _status.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('weightage')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _weightages.add(doc["name"]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _modifiedToField = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Modified To   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width / 5,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _modifiedTo ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _modifiedTo = value;
                  });
                });
              },
              child: Text(
                (_modifiedTo == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_modifiedTo!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
    Widget _modifiedFromField = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Modified From   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width / 5,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _modifiedFrom ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _modifiedFrom = value;
                  });
                });
              },
              child: Text(
                (_modifiedFrom == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_modifiedFrom!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
    Widget _taskToField = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Task To   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width / 5,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _taskTo ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _taskTo = value;
                  });
                });
              },
              child: Text(
                (_taskTo == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_taskTo!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
    Widget _taskFromField = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Task From   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width / 5,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _taskFrom ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _taskFrom = value;
                  });
                });
              },
              child: Text(
                (_taskFrom == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_taskFrom!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
    Widget _dateCreatedField = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Date Created   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width / 5,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _dateCreated ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _dateCreated = value;
                  });
                });
              },
              child: Text(
                (_dateCreated == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_dateCreated!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
    Widget _visaExpiredField = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Visa Expired   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width / 5,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _visaExpired ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _visaExpired = value;
                  });
                });
              },
              child: Text(
                (_visaExpired == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_visaExpired!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    DropdownMenuItem<String> buildMenuCurrentCountry(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final currentCountryDropdown = Container(
        width: MediaQuery.of(context).size.width / 5,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            items: _currentCountry.map(buildMenuCurrentCountry).toList(),
            hint: Text(
              'Current Country',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenCurrentCountry,
            onChanged: (newValue) {
              setState(() {
                _chosenCurrentCountry = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuApplyCountry(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final applyCountryDropdown = Container(
        width: MediaQuery.of(context).size.width / 5,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            items: _countries.map(buildMenuApplyCountry).toList(),
            hint: Text(
              'Interested Country',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenCountry,
            onChanged: (newValue) {
              setState(() {
                _chosenCountry = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuIntakeYear(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final intakeYearDropdown = Container(
        width: MediaQuery.of(context).size.width / 5,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            items: _intakeYears.map(buildMenuIntakeYear).toList(),
            hint: Text(
              ' Intake Year',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenIntakeYear,
            onChanged: (newValue) {
              setState(() {
                _chosenIntakeYear = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuWeightage(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final weightageDropdown = Container(
        width: MediaQuery.of(context).size.width / 5,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            items: _weightages.map(buildMenuWeightage).toList(),
            hint: Text(
              ' Weightage',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenWeightage,
            onChanged: (newValue) {
              setState(() {
                _chosenWeightage = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuLeadSource(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final leadSourceDropdown = Container(
        width: MediaQuery.of(context).size.width / 5,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            items: _leadSource.map(buildMenuLeadSource).toList(),
            hint: Text(
              ' Lead Source',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenLeadSource,
            onChanged: (newValue) {
              setState(() {
                _chosenLeadSource = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuStatus(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.black),
        ));

    final statusDropdown = Container(
        width: MediaQuery.of(context).size.width / 5,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            items: _status.map(buildMenuStatus).toList(),
            hint: Text(
              ' Status',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenStatus,
            onChanged: (newValue) {
              setState(() {
                _chosenStatus = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuAssigned(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.black),
        ));

    final assignedDropdown = Container(
        width: MediaQuery.of(context).size.width / 5,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            items: _users.map(buildMenuAssigned).toList(),
            hint: Text(
              ' Assigned Person',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenUser,
            onChanged: (newValue) {
              setState(() {
                _chosenUser = newValue;
              });
            }));

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
                                'Phone',
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
                                'Edit',
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
                                        .collection('leads')
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      for (var doc in querySnapshot.docs) {
                                        if (doc["docID"] ==
                                            storedocs[i]["docID"]) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingleLead(
                                                        leadModel: doc,
                                                      )));
                                        }
                                      }
                                    });
                                  },
                                  child: Text(
                                    storedocs[i]["firstName"] ?? "empty",
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
                                  storedocs[i]["ieltsResult"] ?? "empty",
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
                                  storedocs[i]["applyCountry"] ?? "empty",
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
                                  storedocs[i]["phone"] ?? "empty",
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
                                    FirebaseFirestore.instance
                                        .collection('leads')
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      for (var doc in querySnapshot.docs) {
                                        if (doc["docID"] ==
                                            storedocs[i]["docID"]) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateLead(
                                                        leadModel: doc,
                                                      )));
                                        }
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
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
                                                                    'leads')
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

    final searchButton = TextButton(
        onPressed: () {
          advancedSearch();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Colors.cyan.shade700,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Advance Search",
            style: TextStyle(color: Colors.white),
          ),
        ));

    final advanceButton = TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: Colors.cyan.shade100,
              title: Center(child: Text("Advance Search")),
              titleTextStyle: TextStyle(fontSize: 20),
              scrollable: true,
              content:
               StatefulBuilder(builder: (context, StateSetter setState) {
                 return SingleChildScrollView(
                   child: Container(
                     child: Padding(
                       padding: const EdgeInsets.all(50.0),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               assignedDropdown,
                               Container(
                                 child: Row(
                                   children: [
                                     SizedBox(
                                       width: 50,
                                     ),
                                     Text(
                                       'Modified From   :',
                                       style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                     SizedBox(
                                       width: 25,
                                     ),
                                     Material(
                                       elevation: 5,
                                       color: Colors.cyan,
                                       borderRadius: BorderRadius.circular(10),
                                       child: MaterialButton(
                                         padding: EdgeInsets.fromLTRB(
                                           20,
                                           15,
                                           20,
                                           15,
                                         ),
                                         minWidth: MediaQuery
                                             .of(context)
                                             .size
                                             .width / 5,
                                         onPressed: () {
                                           showDatePicker(
                                             context: context,
                                             firstDate: DateTime(1990, 01),
                                             lastDate: DateTime(2101),
                                             initialDate: _modifiedFrom ??
                                                 DateTime.now(),
                                           ).then((value) {
                                             setState(() {
                                               _modifiedFrom = value;
                                             });
                                           });
                                         },
                                         child: Text(
                                           (_modifiedFrom == null)
                                               ? 'Pick Date'
                                               : DateFormat('yyyy-MM-dd')
                                               .format(_modifiedFrom!),
                                           textAlign: TextAlign.center,
                                           style:
                                           TextStyle(color: Colors.white,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: 20,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               applyCountryDropdown,
                               Container(
                                 child: Row(
                                   children: [
                                     SizedBox(
                                       width: 50,
                                     ),
                                     Text(
                                       'Modified To   :',
                                       style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                     SizedBox(
                                       width: 25,
                                     ),
                                     Material(
                                       elevation: 5,
                                       color: Colors.cyan,
                                       borderRadius: BorderRadius.circular(10),
                                       child: MaterialButton(
                                         padding: EdgeInsets.fromLTRB(
                                           20,
                                           15,
                                           20,
                                           15,
                                         ),
                                         minWidth: MediaQuery
                                             .of(context)
                                             .size
                                             .width / 5,
                                         onPressed: () {
                                           showDatePicker(
                                             context: context,
                                             firstDate: DateTime(1990, 01),
                                             lastDate: DateTime(2101),
                                             initialDate: _modifiedTo ??
                                                 DateTime.now(),
                                           ).then((value) {
                                             setState(() {
                                               _modifiedTo = value;
                                             });
                                           });
                                         },
                                         child: Text(
                                           (_modifiedTo == null)
                                               ? 'Pick Date'
                                               : DateFormat('yyyy-MM-dd')
                                               .format(_modifiedTo!),
                                           textAlign: TextAlign.center,
                                           style:
                                           TextStyle(color: Colors.white,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: 20,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               leadSourceDropdown,
                               Container(
                                 child: Row(
                                   children: [
                                     SizedBox(
                                       width: 50,
                                     ),
                                     Text(
                                       'Date Created   :',
                                       style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                     SizedBox(
                                       width: 25,
                                     ),
                                     Material(
                                       elevation: 5,
                                       color: Colors.cyan,
                                       borderRadius: BorderRadius.circular(10),
                                       child: MaterialButton(
                                         padding: EdgeInsets.fromLTRB(
                                           20,
                                           15,
                                           20,
                                           15,
                                         ),
                                         minWidth: MediaQuery
                                             .of(context)
                                             .size
                                             .width / 5,
                                         onPressed: () {
                                           showDatePicker(
                                             context: context,
                                             firstDate: DateTime(1990, 01),
                                             lastDate: DateTime(2101),
                                             initialDate: _dateCreated ??
                                                 DateTime.now(),
                                           ).then((value) {
                                             setState(() {
                                               _dateCreated = value;
                                             });
                                           });
                                         },
                                         child: Text(
                                           (_dateCreated == null)
                                               ? 'Pick Date'
                                               : DateFormat('yyyy-MM-dd')
                                               .format(_dateCreated!),
                                           textAlign: TextAlign.center,
                                           style:
                                           TextStyle(color: Colors.white,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: 20,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               currentCountryDropdown,
                               Container(
                                 child: Row(
                                   children: [
                                     SizedBox(
                                       width: 50,
                                     ),
                                     Text(
                                       'Task From   :',
                                       style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                     SizedBox(
                                       width: 25,
                                     ),
                                     Material(
                                       elevation: 5,
                                       color: Colors.cyan,
                                       borderRadius: BorderRadius.circular(10),
                                       child: MaterialButton(
                                         padding: EdgeInsets.fromLTRB(
                                           20,
                                           15,
                                           20,
                                           15,
                                         ),
                                         minWidth: MediaQuery
                                             .of(context)
                                             .size
                                             .width / 5,
                                         onPressed: () {
                                           showDatePicker(
                                             context: context,
                                             firstDate: DateTime(1990, 01),
                                             lastDate: DateTime(2101),
                                             initialDate: _taskFrom ??
                                                 DateTime.now(),
                                           ).then((value) {
                                             setState(() {
                                               _taskFrom = value;
                                             });
                                           });
                                         },
                                         child: Text(
                                           (_taskFrom == null)
                                               ? 'Pick Date'
                                               : DateFormat('yyyy-MM-dd')
                                               .format(_taskFrom!),
                                           textAlign: TextAlign.center,
                                           style:
                                           TextStyle(color: Colors.white,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: 20,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               weightageDropdown,
                               Container(
                                 child: Row(
                                   children: [
                                     SizedBox(
                                       width: 50,
                                     ),
                                     Text(
                                       'Task To   :',
                                       style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                     SizedBox(
                                       width: 25,
                                     ),
                                     Material(
                                       elevation: 5,
                                       color: Colors.cyan,
                                       borderRadius: BorderRadius.circular(10),
                                       child: MaterialButton(
                                         padding: EdgeInsets.fromLTRB(
                                           20,
                                           15,
                                           20,
                                           15,
                                         ),
                                         minWidth: MediaQuery
                                             .of(context)
                                             .size
                                             .width / 5,
                                         onPressed: () {
                                           showDatePicker(
                                             context: context,
                                             firstDate: DateTime(1990, 01),
                                             lastDate: DateTime(2101),
                                             initialDate: _taskTo ??
                                                 DateTime.now(),
                                           ).then((value) {
                                             setState(() {
                                               _taskTo = value;
                                             });
                                           });
                                         },
                                         child: Text(
                                           (_taskTo == null)
                                               ? 'Pick Date'
                                               : DateFormat('yyyy-MM-dd')
                                               .format(_taskTo!),
                                           textAlign: TextAlign.center,
                                           style:
                                           TextStyle(color: Colors.white,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: 20,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               intakeYearDropdown,
                               Container(
                                 child: Row(
                                   children: [
                                     SizedBox(
                                       width: 50,
                                     ),
                                     Text(
                                       'Visa Expired   :',
                                       style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                       ),
                                     ),
                                     SizedBox(
                                       width: 25,
                                     ),
                                     Material(
                                       elevation: 5,
                                       color: Colors.cyan,
                                       borderRadius: BorderRadius.circular(10),
                                       child: MaterialButton(
                                         padding: EdgeInsets.fromLTRB(
                                           20,
                                           15,
                                           20,
                                           15,
                                         ),
                                         minWidth: MediaQuery
                                             .of(context)
                                             .size
                                             .width / 5,
                                         onPressed: () {
                                           showDatePicker(
                                             context: context,
                                             firstDate: DateTime(1990, 01),
                                             lastDate: DateTime(2101),
                                             initialDate: _visaExpired ??
                                                 DateTime.now(),
                                           ).then((value) {
                                             setState(() {
                                               _visaExpired = value;
                                             });
                                           });
                                         },
                                         child: Text(
                                           (_visaExpired == null)
                                               ? 'Pick Date'
                                               : DateFormat('yyyy-MM-dd')
                                               .format(_visaExpired!),
                                           textAlign: TextAlign.center,
                                           style:
                                           TextStyle(color: Colors.white,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: 20,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               statusDropdown,
                             ],
                           ),
                           SizedBox(
                             height: 30,
                           ),
                           searchButton
                         ],
                       ),
                     ),
                   ),
                 );
               }

              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Colors.cyan.shade700,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Advance Search",
            style: TextStyle(color: Colors.white),
          ),
        ));

    final cancelFilterButton = TextButton(
        onPressed: () {
          setState(() {
            setState(() {
              search = false;
              _chosenCountry = null;
              _chosenCurrentCountry = null;
              _chosenIntakeYear = null;
              _chosenLeadSource = null;
              _chosenUser = null;
              _chosenStatus = null;
              _chosenWeightage = null;
              _dateCreated = null;
              _taskFrom = null;
              _taskTo = null;
              _modifiedFrom = null;
              _modifiedTo = null;
              _visaExpired = null;
            });
            storedocs.clear();
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Advance Filter Off",
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
                                child: Text("Total Leads  :  $totalLeads"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              advanceButton
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
                              cancelFilterButton
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
        .collection('leads')
        .orderBy("timeStamp", descending: true)
        .get();
    if (value != "") {
      storedocs.clear();
      for (var doc in documents.docs) {
        if (doc["firstName"]
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase())) {
          storedocs.add(doc);
          setState(() {});
        }
      }
    } else {
      setState(() {
        storedocs.clear();
        search = false;
      });
    }
  }

  void advancedSearch() async {
    final documents = await FirebaseFirestore.instance
        .collection('leads')
        .orderBy("timeStamp", descending: true)
        .get();
    setState(() {
      search = true;
      storedocs.clear();
    });

    if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null && _chosenStatus != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"]
            .toString()
            .toLowerCase()
            .contains(_chosenUser.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenStatus != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_modifiedFrom != null && _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_modifiedTo != null) {
      for (var doc in documents.docs) {
        if (int.parse(
                DateFormat('yyyyMMdd').format(doc["modifiedDate"].toDate())) <=
            int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null && _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenStatus != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["status"].toString().toLowerCase() ==
                (_chosenStatus.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenUser != null &&
        _chosenCountry != null &&
        _chosenCurrentCountry != null &&
        _chosenWeightage != null &&
        _modifiedFrom != null &&
        _modifiedTo != null) {
      for (var doc in documents.docs) {
        if (doc["assigned"].toString().toLowerCase() ==
                (_chosenUser.toString().toLowerCase()) &&
            doc["applyCountry"].toString().toLowerCase() ==
                (_chosenCountry.toString().toLowerCase()) &&
            doc["originCountry"].toString().toLowerCase() ==
                (_chosenCurrentCountry.toString().toLowerCase()) &&
            doc["weightage"].toString().toLowerCase() ==
                (_chosenWeightage.toString().toLowerCase()) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) >=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!)) &&
            int.parse(DateFormat('yyyyMMdd')
                    .format(doc["modifiedDate"].toDate())) <=
                int.parse(DateFormat('yyyyMMdd').format(_modifiedTo!))) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenLeadSource != null) {
      for (var doc in documents.docs) {
        if (doc["leadSource"]
            .toString()
            .toLowerCase()
            .contains(_chosenLeadSource.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    } else if (_chosenIntakeYear != null) {
      for (var doc in documents.docs) {
        if (doc["intakeYearApplied"].contains(_chosenIntakeYear)) {
          storedocs.add(doc);
        }
      }
    } else if (_dateCreated != null) {
      for (var doc in documents.docs) {
        if (DateFormat('yyyyMMdd')
            .format(doc["timeStamp"].toDate())
            .contains(DateFormat('yyyyMMdd').format(_dateCreated!))) {
          storedocs.add(doc);
        }
      }
    } else if (_visaExpired != null) {
      for (var doc in documents.docs) {
        if (doc["visaExpired"]
            .contains(DateFormat('yyyyMMdd').format(_visaExpired!))) {
          storedocs.add(doc);
        }
      }
    } else if (_taskFrom != null) {
      for (var doc in documents.docs) {
        if (int.parse(doc["taskDueDate"]) >=
            int.parse(DateFormat('yyyyMMdd').format(_taskFrom!))) {
          storedocs.add(doc);
        }
      }
    } else if (_taskTo != null) {
      for (var doc in documents.docs) {
        if (int.parse(doc["taskDueDate"]) <=
            int.parse(DateFormat('yyyyMMdd').format(_taskTo!))) {
          storedocs.add(doc);
        }
      }
    }
    else if (_modifiedFrom != null) {
      for (var doc in documents.docs) {
        if (int.parse(doc["modifiedDate"]) >=
            int.parse(DateFormat('yyyyMMdd').format(_modifiedFrom!))) {
          storedocs.add(doc);
        }
      }
    }
    else if (_chosenStatus != null) {
      for (var doc in documents.docs) {
        if (doc["status"]
            .toString()
            .toLowerCase()
            .contains(_chosenStatus.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    }
    else if (_chosenWeightage != null) {
      for (var doc in documents.docs) {
        if (doc["weightage"]
            .toString()
            .toLowerCase()
            .contains(_chosenWeightage.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    }
    else if (_chosenCurrentCountry != null) {
      for (var doc in documents.docs) {
        if (doc["originCountry"]
            .toString()
            .toLowerCase()
            .contains(_chosenCurrentCountry.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    }
    else if (_chosenCountry != null) {
      for (var doc in documents.docs) {
        if (doc["applyCountry"]
            .toString()
            .toLowerCase()
            .contains(_chosenCountry.toString().toLowerCase())) {
          storedocs.add(doc);
        }
      }
    }else {
      setState(() {
        search = false;
      });
      storedocs.clear();
    }

    Navigator.of(context).pop();

    // if (searchController.text != "") {
    //   storedocs.clear();
    //   for (var doc in documents.docs) {
    //     if (doc["firstName"].toString().toLowerCase().contains(value.toLowerCase())) {
    //       storedocs.add(doc);
    //       setState(() {});
    //     }
    //   }
    // } else {
    //   setState(() {
    //     storedocs.clear();
    //     search = false;
    //   });
  }
}
