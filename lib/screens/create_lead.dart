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
import 'package:rmgateway/screens/today_task.dart';
import 'package:rmgateway/screens/update_country.dart';
import 'package:rmgateway/screens/update_course_title.dart';
import 'package:rmgateway/screens/update_student_type.dart';
import 'package:rmgateway/screens/update_university.dart';
import 'package:rmgateway/screens/user_profile.dart';
import 'package:rmgateway/screens/view_lead.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_attendance.dart';
import 'apply.dart';
import 'create_student_type.dart';
import 'create_university.dart';

class CreateLead extends StatefulWidget {
  const CreateLead({Key? key}) : super(key: key);

  @override
  State<CreateLead> createState() => _CreateLeadState();
}

class _CreateLeadState extends State<CreateLead> {
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final phoneEditingController = new TextEditingController();
  final originCountryEditingController = new TextEditingController();
  final optionalPhoneEditingController = new TextEditingController();
  final immigrationHistoryEditingController = new TextEditingController();
  final commentsEditingController = new TextEditingController();
  final preQTitleEditingController = new TextEditingController();
  final recQTitleEditingController = new TextEditingController();
  final workExperienceEditingController = new TextEditingController();
  final studyGapEditingController = new TextEditingController();
  final ieltsResultEditingController = new TextEditingController();
  final statusDesEditingController = new TextEditingController();
  final leadSourceDesEditingController = new TextEditingController();
  final taskSubjectEditingController = new TextEditingController();
  final taskContactEditingController = new TextEditingController();
  final courseNameEditingController = new TextEditingController();
  final tutionFeeEditingController = new TextEditingController();
  final applicationStatusEditingController = new TextEditingController();

  bool? _process;
  int? _count;
  String? currentUserID;
  String? currentUserName;
  // Initial Selected Value
  String userName = 'Unknown';

  // List of items in our dropdown menu
  List<String> items = [];


  // List of items in our dropdown menu
  List<String> properties = ["Add Country", "Add University", "Add Course Level", "Add Course Title", "Add Lead Source","Add Status","Add Student Type","Add Weightage"];

  final List<String> _studentTypes = [];
  String? _chosenStudentType;

  final List<String> _applyCountryTypes = [];
  String? _chosenApplyCountry;

  final List<String> _courseLevelTypes = [];
  String? _chosenCourseLevel;

  final List<String> _courseTitleTypes = [];
  String? _chosenCourseTitle;

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

  final List<String> _intakeMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String? _chosenIntakeMonth;


  final List<String> _intakeYearsApplied = [
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
  String? _chosenIntakeYearApplied;

  final List<String> _intakeMonthsApplied = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String? _chosenIntakeMonthApplied;

  final List<String> _preQLevels = [
    "Level 1",
    "Level 2",
    "Level 3",
    "Level 4",
    "Level 5",
    "Level 6",
    "Level 7",
    "Level 8"
  ];
  String? _chosenPreQLevel;

  final List<String> _recQLevels = [
    "Level 1",
    "Level 2",
    "Level 3",
    "Level 4",
    "Level 5",
    "Level 6",
    "Level 7",
    "Level 8"
  ];
  String? _chosenRecQLevel;

  final List<String> _ielts = ["Intended Date", "Yes", "No"];
  String? _chosenIelts;

  final List<String> _firstChoices = [];
  String? _chosenFirstChoice;

  final List<String> _secondChoices = [];
  String? _chosenSecondChoice;

  final List<String> _thirdChoices = [];
  String? _chosenThirdChoice;

  final List<String> _fourthChoices = [];
  String? _chosenFourthChoice;

  final List<String> _status = [];
  String? _chosenStatus;

  final List<String> _leadSource = [];
  String? _chosenLeadSource;

  final List<String> _weightages = [];
  String? _chosenWeightage;

  final List<String> _universities = [];
  String? _chosenUniversity;


  final List<String> _assigned = [];
  String? _chosenAssigned;

  DateTime? _visaIssued;
  DateTime? _visaExpired;
  DateTime? _ieltsDate;
  DateTime? _taskDueDate;

  Uint8List? applicationForm;
  String? applicationFormName;
  String? applicationFormLink;

  Uint8List? cv;
  String? cvName;
  String? cvLink;

  Uint8List? academic;
  String? academicName;
  String? academicLink;

  Uint8List? attendance;
  String? attendanceName;
  String? attendanceLink;

  Uint8List? workExperience;
  String? workExperienceName;
  String? workExperienceLink;

  Uint8List? sop;
  String? sopName;
  String? sopLink;

  Uint8List? passport;
  String? passportName;
  String? passportLink;

  Uint8List? sponsor;
  String? sponsorName;
  String? sponsorLink;

  Uint8List? ieltsTest;
  String? ieltsTestName;
  String? ieltsTestLink;

  Uint8List? bank;
  String? bankName;
  String? bankLink;


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
        if(doc["userID"] == currentUserID){
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
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _assigned.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('countries')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _applyCountryTypes.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('courselevels')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _courseLevelTypes.add(doc["name"]);
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
        .collection('coursetitles')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _courseTitleTypes.add(doc["name"]);
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
        .collection('studenttypes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _studentTypes.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('universities')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _universities.add(doc["name"]);
          _firstChoices.add(doc["name"]);
          _secondChoices.add(doc["name"]);
          _thirdChoices.add(doc["name"]);
          _fourthChoices.add(doc["name"]);
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
    final _docBank = Container(
      child: Row(
        children: [
          Text(
            'Bank Statement   :',
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
                selectBank();
              },
              child: Text(
                bankName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final _docIELTS = Container(
      child: Row(
        children: [
          Text(
            'English Test   :',
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
                selectIELTS();
              },
              child: Text(
                ieltsTestName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final _docSponsor = Container(
      child: Row(
        children: [
          Text(
            'Current Sponsor Confirmation   :',
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
                selectSponsor();
              },
              child: Text(
                sponsorName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final _docPassport = Container(
      child: Row(
        children: [
          Text(
            'Passport with Visa Copy   :',
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
                selectPassport();
              },
              child: Text(
                passportName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final _docSOP = Container(
      child: Row(
        children: [
          Text(
            'Statement of Purpose   :',
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
                selectSop();
              },
              child: Text(
                sopName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final _docWorkExperience = Container(
      child: Row(
        children: [

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
                selectWorkExperience();
              },
              child: Text(
                workExperienceName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            ' :  Work Experience Letter',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],
      ),
    );

    final _docAttendance = Container(
      child: Row(
        children: [

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
                selectAttendance();
              },
              child: Text(
                attendanceName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            ' :  Letter of Attendance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],
      ),
    );

    final _docAcademic = Container(
      child: Row(
        children: [

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
                selectAcademic();
              },
              child: Text(
                academicName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            ' :  All Academic Certificate & Transcript',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],
      ),
    );

    final _docCV = Container(
      child: Row(
        children: [

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
                selectCv();
              },
              child: Text(
                cvName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            ' :  CV With 2 Reference',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],
      ),
    );

    final _docApplicationForm = Container(
      child: Row(
        children: [

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
                selectApplicationForm();
              },
              child: Text(
                applicationFormName
                    ?? 'No File Selected',
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            ' :  Completed Application Form',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],
      ),
    );


    final _taskDueDateField = Container(
      child: Row(
        children: [

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
                  initialDate: _taskDueDate ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _taskDueDate = value;
                  });
                });
              },
              child: Text(
                (_taskDueDate == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_taskDueDate!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            ':  Task Due Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],
      ),
    );

    final _ieltsDateField = Container(
      child: Row(
        children: [


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
                  initialDate: _ieltsDate ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _ieltsDate = value;
                  });
                });
              },
              child: Text(
                (_ieltsDate == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_ieltsDate!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            ':  English Test/ Future Test Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],
      ),
    );

    final _visaExpiredField = Container(
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

    final _visaIssuedField = Container(
      child: Row(
        children: [

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
                  initialDate: _visaIssued ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _visaIssued = value;
                  });
                });
              },
              child: Text(
                (_visaIssued == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_visaIssued!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            ':  Visa Issued',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

        ],
      ),
    );


    DropdownMenuItem<String> buildMenuAssigned(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final assignedDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _assigned.map(buildMenuAssigned).toList(),
            hint: Text(
              ' Assigned Person',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenAssigned,
            onChanged: (newValue) {
              setState(() {
                _chosenAssigned = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuUniversity(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final universityDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _universities.map(buildMenuUniversity).toList(),
            hint: Text(
              ' University',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenUniversity,
            onChanged: (newValue) {
              setState(() {
                _chosenUniversity = newValue;
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
        width: MediaQuery.of(context).size.width / 3,
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
        width: MediaQuery.of(context).size.width / 3,
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
        width: MediaQuery.of(context).size.width / 3,
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

    DropdownMenuItem<String> buildMenuFourthChoice(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final fourthChoiceDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _fourthChoices.map(buildMenuFourthChoice).toList(),
            hint: Text(
              ' Fourth Choice',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenFourthChoice,
            onChanged: (newValue) {
              setState(() {
                _chosenFourthChoice = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuThirdChoice(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final thirdChoiceDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _thirdChoices.map(buildMenuThirdChoice).toList(),
            hint: Text(
              ' Third Choice',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenThirdChoice,
            onChanged: (newValue) {
              setState(() {
                _chosenThirdChoice = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuSecondChoice(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final secondChoiceDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _secondChoices.map(buildMenuSecondChoice).toList(),
            hint: Text(
              ' Second Choice',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenSecondChoice,
            onChanged: (newValue) {
              setState(() {
                _chosenSecondChoice = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuFirstChoice(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final firstChoiceDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _firstChoices.map(buildMenuFirstChoice).toList(),
            hint: Text(
              ' First Choice',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenFirstChoice,
            onChanged: (newValue) {
              setState(() {
                _chosenFirstChoice = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuIelts(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.black),
        ));

    final ieltsDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _ielts.map(buildMenuIelts).toList(),
            hint: Text(
              ' IELTS/WAEC',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenIelts,
            onChanged: (newValue) {
              setState(() {
                _chosenIelts = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuRecQLevel(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final recQLevelDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _recQLevels.map(buildMenuRecQLevel).toList(),
            hint: Text(
              ' Recent Qualification Level',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenRecQLevel,
            onChanged: (newValue) {
              setState(() {
                _chosenRecQLevel = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuPreQLevel(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final preQLevelDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _preQLevels.map(buildMenuPreQLevel).toList(),
            hint: Text(
              'Previous Qualification Level',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenPreQLevel,
            onChanged: (newValue) {
              setState(() {
                _chosenPreQLevel = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuIntakeMonth(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final intakeMonthDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _intakeMonths.map(buildMenuIntakeMonth).toList(),
            hint: Text(
              ' Intake Month',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenIntakeMonth,
            onChanged: (newValue) {
              setState(() {
                _chosenIntakeMonth = newValue;
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
        width: MediaQuery.of(context).size.width / 3,
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

    DropdownMenuItem<String> buildMenuIntakeMonthApplied(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final intakeMonthAppliedDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _intakeMonthsApplied.map(buildMenuIntakeMonthApplied).toList(),
            hint: Text(
              ' Intake Month',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenIntakeMonthApplied,
            onChanged: (newValue) {
              setState(() {
                _chosenIntakeMonthApplied = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuIntakeYearApplied(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final intakeYearAppliedDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _intakeYearsApplied.map(buildMenuIntakeYearApplied).toList(),
            hint: Text(
              ' Intake Year',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenIntakeYearApplied,
            onChanged: (newValue) {
              setState(() {
                _chosenIntakeYearApplied = newValue;
              });
            }));



    DropdownMenuItem<String> buildMenuCourseTitle(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final courseTitleDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _courseTitleTypes.map(buildMenuCourseTitle).toList(),
            hint: Text(
              'Course Title',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenCourseTitle,
            onChanged: (newValue) {
              setState(() {
                _chosenCourseTitle = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuCourseLevel(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final courseLevelDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _courseLevelTypes.map(buildMenuCourseLevel).toList(),
            hint: Text(
              'Course Level',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenCourseLevel,
            onChanged: (newValue) {
              setState(() {
                _chosenCourseLevel = newValue;
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
        width: MediaQuery.of(context).size.width / 3,
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
            items: _applyCountryTypes.map(buildMenuApplyCountry).toList(),
            hint: Text(
              'Apply Country',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenApplyCountry,
            onChanged: (newValue) {
              setState(() {
                _chosenApplyCountry = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuStudentType(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final studentTypeDropdown = Container(
        width: MediaQuery.of(context).size.width / 3,
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
            items: _studentTypes.map(buildMenuStudentType).toList(),
            hint: Text(
              'Select Student Type',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenStudentType,
            onChanged: (newValue) {
              setState(() {
                _chosenStudentType = newValue;
              });
            }));

    final applicationStatusField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: applicationStatusEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              applicationStatusEditingController.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Application Status',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final tutionFeeField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: tutionFeeEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              tutionFeeEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Tuition Fees',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final courseNameField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: courseNameEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              courseNameEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Course Name',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final taskContactField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: taskContactEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              taskContactEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Task Contact',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final taskSubjectField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: taskSubjectEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              taskSubjectEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Task Subject',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final leadSourceDescriptionField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            maxLines: 3,
            controller: leadSourceDesEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              leadSourceDesEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Lead Source Description',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final statusDesField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            maxLines: 3,
            controller: statusDesEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              statusDesEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Status Description',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final ieltsResultField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: ieltsResultEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              ieltsResultEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'IELTS/WAEC Result',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final studyGapField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: studyGapEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              studyGapEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Study Gap',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final workExperienceField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: workExperienceEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              workExperienceEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Work Experience',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final recQTitleField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: recQTitleEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              recQTitleEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Recent Qualification Title',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final preQTitleField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: preQTitleEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              preQTitleEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Previous Qualification Title',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final commentsField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            maxLines: 3,
            autofocus: false,
            controller: commentsEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              commentsEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Comments',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final immigrationHistoryField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            maxLines: 3,
            autofocus: false,
            controller: immigrationHistoryEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              immigrationHistoryEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Immigration History',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final optionalPhoneField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: optionalPhoneEditingController,
            keyboardType: TextInputType.name,
            onSaved: (value) {
              optionalPhoneEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Optional Phone',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final originCountryField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: originCountryEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              originCountryEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Origin Country',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final phoneField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: phoneEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              phoneEditingController.text = value!;
            },

            onChanged: (value){
              taskContactEditingController.text = value;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Phone',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final emailField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: emailEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              emailEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final lastNameField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: lastNameEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              lastNameEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Last Name',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));
    final firstNameField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan,
            autofocus: false,
            controller: firstNameEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              firstNameEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'First Name',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            )));

    final createButton = Material(
      elevation: (_process!) ? 0 : 5,
      color: (_process!) ? Colors.green.shade800 : Colors.green,
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
            _process = true;
            _count = (_count! - 1);
          });
          (_count! < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red, content: Text("Wait Please!!")))
              : AddData();
        },
        child: (_process!)
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
                '  Create  ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
      ),
    );





    final dropdownButtonField =DropdownButton(
      focusColor: Colors.cyan.shade700,
      borderRadius: BorderRadius.circular(10),
      underline: DropdownButtonHideUnderline(child: Container()),
      dropdownColor: Colors.white,
      hint: Text(
        userName,
        style: TextStyle(
          color: Colors.white
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: TextButton(
            onPressed: () {
              if(items.contains("Logout")){
                showDialog(
                    context: context,
                    builder: (BuildContext context)=>AlertDialog(
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
                              FirebaseAuth.instance.signOut().catchError((onError) async {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red, content: Text("Log out failed!!")));

                                 Navigator.pop(context);
                              }).whenComplete(() async {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignIn()),
                                        (route) => false);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.green, content: Text("Logged out!!")));
                                SharedPreferences _pref = await SharedPreferences.getInstance();
                                _pref.remove("email");
                                _pref.remove("password");
                              });

                            })
                      ],
                    )
                );
              }else{
                FirebaseFirestore.instance
                    .collection('users')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if (doc["userID"].toString()==currentUserID) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserProfile(userModel:doc)));
                    }
                  }
                });
              }
            },
            child: Text(
              items,
              style: TextStyle(
                color: Colors.cyan.shade700
              ),
            ),
          ),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {

      },
    );


    final propertyField =DropdownButton(
      focusColor: Colors.cyan.shade700,
      borderRadius: BorderRadius.circular(10),
      underline: DropdownButtonHideUnderline(child: Container()),
      dropdownColor: Colors.white,
      hint: Text(
        "Add Property",
        style: TextStyle(
            color: Colors.white
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),
      items: properties.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: TextButton(
            onPressed: () {
              if(items.contains("Add Country")){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateCountry()));
              }else if(items.contains("Add University")){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateUniversity()));
              }else if(items.contains("Add Course Level")){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateCourseLevel()));
              }else if(items.contains("Add Course Title")){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateCourseTitle()));
              }else if(items.contains("Add Lead Source")){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateLeadSource()));
              }else if(items.contains("Add Status")){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateStatus()));
              }else if(items.contains("Add Student Type")){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateStudentType()));
              }else if(items.contains("Add Weightage")){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateWeightage()));
              }
            },
            child: Text(
              items,
              style: TextStyle(
                  color: Colors.cyan.shade700
              ),
            ),
          ),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {

      },
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
            child:Scrollbar(
                child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/demo.jpg",
                        ),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,0),
                    child: dropdownButtonField,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewLead()));
                      },
                      child: Text(
                        "Leads",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TodayTask(currentUserName: currentUserName.toString(),)));
                      },
                      child: Text(
                        "Today's Task",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CreateLead()));
                      },
                      child: Text(
                        "Create Lead",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  TextButton(
                      onPressed: (){
                        FirebaseFirestore.instance
                            .collection('users')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          for (var doc in querySnapshot.docs) {
                            if (doc["userID"].toString() == currentUserID && doc["userType"].toString().toLowerCase() == "admin" ) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EmployeeDetails()));
                            }
                          }
                        });


                      },
                      child: Text(
                        "Employee Details",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  TextButton(
                      onPressed: ()async{
                       await FirebaseFirestore.instance
                            .collection('users')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          for (var doc in querySnapshot.docs) {
                            if (doc["userID"].toString() ==
                                currentUserID &&
                                doc["userType"].toString().toLowerCase() == "admin") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdminAttendance()));
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SendSMS()));
                      },
                      child: Text(
                        "Sms",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SendEmail()));
                      },
                      child: Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Apply()));
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  SizedBox(height: 10,),
                  propertyField
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: widthMain,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                      child: Text(
                        "Create Lead",
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan.shade700),
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
                        "Edit Personal Details",
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                                  children:  <Widget>[firstNameField, lastNameField],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  <Widget>[studentTypeDropdown, applyCountryDropdown],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  <Widget>[emailField, originCountryField],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  <Widget>[phoneField, optionalPhoneField],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  <Widget>[_visaIssuedField, _visaExpiredField],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  <Widget>[immigrationHistoryField, commentsField],
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
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              children:  <Widget>[courseLevelDropdown, intakeYearDropdown],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[courseTitleDropdown, intakeMonthDropdown],
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
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              children:  <Widget>[preQLevelDropdown, recQLevelDropdown],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[preQTitleField, recQTitleField],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[workExperienceField, studyGapField],
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
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              children:  <Widget>[ieltsDropdown, ieltsResultField],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[_ieltsDateField],
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
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              children:  <Widget>[firstChoiceDropdown, thirdChoiceDropdown],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[secondChoiceDropdown, fourthChoiceDropdown],
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
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              children:  <Widget>[statusDropdown, leadSourceDropdown],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[statusDesField, leadSourceDescriptionField],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[weightageDropdown, assignedDropdown],
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
                        "Upload Documents",
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              children:  <Widget>[_docApplicationForm, _docSOP],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[_docCV, _docPassport],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[_docAcademic, _docSponsor],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[_docAttendance, _docIELTS],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[_docWorkExperience, _docBank],
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
                        "Create Task",
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              children:  <Widget>[taskSubjectField, taskContactField],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[_taskDueDateField],
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
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                              children:  <Widget>[courseNameField, tutionFeeField],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[universityDropdown,applicationStatusField],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  <Widget>[intakeMonthAppliedDropdown,intakeYearAppliedDropdown],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(child: createButton),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
            ),
            ),
        ],
      ),
    );
  }


  Future selectApplicationForm()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      applicationForm = result.files.single.bytes;
      applicationFormName = result.files.single.name;
    });
  }

  Future selectCv()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      cv = result.files.single.bytes;
      cvName = result.files.single.name;
    });
  }

  Future selectAcademic()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      academic = result.files.single.bytes;
      academicName = result.files.single.name;
    });
  }

  Future selectAttendance()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      attendance = result.files.single.bytes;
      attendanceName = result.files.single.name;
    });
  }

  Future selectWorkExperience()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      workExperience = result.files.single.bytes;
      workExperienceName = result.files.single.name;
    });
  }

  Future selectSop()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      sop = result.files.single.bytes;
      sopName = result.files.single.name;
    });
  }

  Future selectPassport()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      passport = result.files.single.bytes;
      passportName = result.files.single.name;
    });
  }

  Future selectSponsor()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      sponsor = result.files.single.bytes;
      sponsorName = result.files.single.name;
    });
  }

  Future selectIELTS()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      ieltsTest = result.files.single.bytes;
      ieltsTestName = result.files.single.name;
    });
  }

  Future selectBank()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      bank = result.files.single.bytes;
      bankName = result.files.single.name;
    });
  }

  void AddData() async {
    try{
      final ref =   FirebaseFirestore.instance.collection("leads").doc();

      bool isDocument = await uploadDocuments(ref.id, ref);
       bool isUploaded = await uploadFiles(ref.id);

       if(isUploaded && isDocument){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
             backgroundColor: Colors.green, content: Text("Lead Created!!")));
         Navigator.pushReplacement(
             context, MaterialPageRoute(builder: (context) => ViewLead()));
         setState(() {
           _process = false;
           _count = 1;
         });
       }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text(e.toString())));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }

  Future<bool> uploadDocuments(String id, DocumentReference<Map<String, dynamic>> ref)async{
    bool isError = true;

    LeadModel leadModel = LeadModel();
    leadModel.timeStamp = FieldValue.serverTimestamp();
    leadModel.userID = currentUserID;
    leadModel.firstName = firstNameEditingController.text;
    leadModel.lastName = lastNameEditingController.text;
    leadModel.studentType = _chosenStudentType;
    leadModel.email = emailEditingController.text;
    leadModel.phone = phoneEditingController.text;
    leadModel.applyCountry = _chosenApplyCountry;
    leadModel.originCountry = originCountryEditingController.text;
    leadModel.optionalPhone = optionalPhoneEditingController.text;
    leadModel.visaIssued =(_visaIssued!=null)?DateFormat('yyyy-MM-dd').format(_visaIssued!):"0";
    leadModel.visaExpired =  (_visaExpired!=null)?DateFormat('yyyy-MM-dd').format(_visaExpired!):"0";
    leadModel.immigrationHistory = immigrationHistoryEditingController.text;
    leadModel.comments = commentsEditingController.text;
    leadModel.courseLevel = _chosenCourseLevel;
    leadModel.courseTitle = _chosenCourseTitle;
    leadModel.intakeYear = _chosenIntakeYear;
    leadModel.intakeMonth = _chosenIntakeMonth;
    leadModel.preQLevel = _chosenPreQLevel;
    leadModel.preQTitle = preQTitleEditingController.text;
    leadModel.recQLevel = _chosenRecQLevel;
    leadModel.recQTitle = recQTitleEditingController.text;
    leadModel.workExperience = workExperienceEditingController.text;
    leadModel.studyGap = studyGapEditingController.text;
    leadModel.ielts = _chosenIelts;
    leadModel.ieltsResult = ieltsResultEditingController.text;
     leadModel.ieltsDate = (_ieltsDate!=null)?DateFormat('yyyy-MM-dd').format(_ieltsDate!):"0";
    leadModel.firstChoice = _chosenFirstChoice;
    leadModel.secondChoice = _chosenSecondChoice;
    leadModel.thirdChoice = _chosenThirdChoice;
    leadModel.fourthChoice = _chosenFourthChoice;
    leadModel.docApplicationForm = applicationFormName;
    leadModel.docCV = cvName;
    leadModel.docAcademic = academicName;
    leadModel.docAttendance = attendanceName;
    leadModel.docWorkExperience = workExperienceName;
    leadModel.docSOP = sopName;
    leadModel.docPassport = passportName;
    leadModel.docSponsor = sponsorName;
    leadModel.docIELTSTest = ieltsTestName;
    leadModel.docBank = bankName;
    leadModel.status = _chosenStatus;
    leadModel.statusDes = statusDesEditingController.text;
    leadModel.leadSource =_chosenLeadSource;
    leadModel.leadSourceDes = leadSourceDesEditingController.text;
    leadModel.weightage = _chosenWeightage;
    leadModel.assigned = _chosenAssigned;
    leadModel.taskSubject = taskSubjectEditingController.text;
    leadModel.taskContact = taskContactEditingController.text;
    leadModel.taskDueDate = (_taskDueDate!=null)?DateFormat('yyyy-MM-dd').format(_taskDueDate!):"0";
    leadModel.taskStatus = "pending";
    leadModel.courseName = courseNameEditingController.text;
    leadModel.tutionFee = tutionFeeEditingController.text;
    leadModel.universityName = _chosenUniversity;
    leadModel.applicationStatus = applicationStatusEditingController.text;
    leadModel.intakeYearApplied = _chosenIntakeYearApplied;
    leadModel.intakeMonthApplied = _chosenIntakeMonthApplied;
    leadModel.modifiedBy = currentUserName;
    leadModel.modifiedDate = FieldValue.serverTimestamp();
    leadModel.docID = id;
    await ref.set(leadModel.toMap()).catchError((onError){
      isError = false;
    });
    return isError;
  }

  Future<bool> uploadFiles(String id) async{
   bool bApplicationForm = true;
   bool bCV = true;
   bool bAcademic = true;
   bool bAttendance = true;
   bool bWorkExperience = true;
   bool bSOP = true;
   bool bPassport = true;
   bool bSponsor = true;
   bool bIelts = true;
   bool bBank = true;

    if(applicationFormName!=null){
      UploadTask taskApplicationForm =   FirebaseStorage.instance.ref().child("files/$id/$applicationFormName").putData(applicationForm!);
      await taskApplicationForm.whenComplete((){
        bApplicationForm = true;
      }).catchError((onError){
        bApplicationForm = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text("Application Form upload failed!!")));
      });
    }
   if(cvName!=null){
     UploadTask taskCV =  FirebaseStorage.instance.ref().child("files/$id/$cvName").putData(cv!);
     await taskCV.whenComplete((){
       bCV = true;

     }).catchError((onError){
       bCV = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("CV upload failed!!")));
     });
   }

   if(academicName!=null){
     UploadTask taskAcademic = FirebaseStorage.instance.ref().child("files/$id/$academicName").putData(academic!);
     await taskAcademic.whenComplete((){
       bAcademic = true;
     }).catchError((onError){
       bAcademic = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("Academic documents upload failed!!")));
     });
   }

   if(attendanceName!=null){
     UploadTask taskAttendance = FirebaseStorage.instance.ref().child("files/$id/$attendanceName").putData(attendance!);
     await taskAttendance.whenComplete((){
       bAttendance = true;
     }).catchError((onError){
       bAttendance = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("Attendance documents upload failed!!")));
     });
   }

   if(workExperienceName!=null){
     UploadTask taskWorkExperience = FirebaseStorage.instance.ref().child("files/$id/$workExperienceName").putData(workExperience!);
     await taskWorkExperience.whenComplete((){
       bWorkExperience = true;
     }).catchError((onError){
       bWorkExperience = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("Work Experience upload failed!!")));
     });
   }

   if(sopName!=null){
     UploadTask taskSOP = FirebaseStorage.instance.ref().child("files/$id/$sopName").putData(sop!);
     await taskSOP.whenComplete((){
       bSOP = true;
     }).catchError((onError){
       bSOP = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("SOP upload failed!!")));
     });
   }


   if(passportName!=null){
     UploadTask taskPassport = FirebaseStorage.instance.ref().child("files/$id/$passportName").putData(passport!);
     await taskPassport.whenComplete((){
       bPassport = true;
     }).catchError((onError){
       bPassport = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("Passport upload failed!!")));
     });
   }


   if(sponsorName!=null){
     UploadTask taskSponsor = FirebaseStorage.instance.ref().child("files/$id/$sponsorName").putData(sponsor!);
     await taskSponsor.whenComplete((){
       bSponsor = true;
     }).catchError((onError){
       bSponsor = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("Sponsor documents upload failed!!")));
     });
   }


   if(ieltsTestName!=null){
     UploadTask taskIeltsTest = FirebaseStorage.instance.ref().child("files/${id}/$ieltsTestName").putData(ieltsTest!);
     await taskIeltsTest.whenComplete((){
       bIelts = true;
     }).catchError((onError){
       bIelts = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("English test documents upload failed!!")));
     });
   }


   if(bankName!=null){
     UploadTask taskBank = FirebaseStorage.instance.ref().child("files/$id/$bankName").putData(bank!);
     await taskBank.whenComplete((){
       bBank = true;
     }).catchError((onError){
       bBank = false;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red, content: Text("Bank documents upload failed!!")));
     });
   }

   if(bApplicationForm && bCV && bAcademic && bAttendance && bWorkExperience && bSOP && bPassport & bSponsor && bIelts && bBank){
     return true;
   }else{
     return false;
   }

  }
}
