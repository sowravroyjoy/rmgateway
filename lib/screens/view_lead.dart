import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rmgateway/screens/single_lead.dart';
import 'package:rmgateway/screens/update_lead.dart';
import 'package:rmgateway/widgets/side_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewLead extends StatefulWidget {
  const ViewLead({Key? key}) : super(key: key);

  @override
  State<ViewLead> createState() => _ViewLeadState();
}

class _ViewLeadState extends State<ViewLead> {
  String? _chosenUser;
  String? _chosenCountry;
  String? _chosenCurrentCountry;
  String? _chosenLeadSource;
  String? _chosenWeightage;
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
  String currentUserID = "";
  String currentUserName = "";
  SharedPreferences? _pref;
  String userType = "";

  // Initial Selected Value
  String userName = 'Unknown';

  int totalLeads = 0;
  int index = 0;
  int restLeads = 0;
  int length = 10;
  final TextEditingController searchController = TextEditingController();

  List storedocs = [];
  bool search = false;
  bool isLessLead = false;


  List userL = [];
  List applyCountryL = [];
  List currentCountryL = [];
  List leadSourceL = [];
  List statusL = [];
  List weightageL =[];
  List intakeYearL = ["2020","2021","2022",'2023',"2024","2025","2026","2027","2028","2029","2030"];

  bool userB = false;
  bool applyCountryB = false;
  bool currentCountryB = false;
  bool leadSourceB = false;
  bool statusB = false;
  bool weightageB =false;
  bool intakeYearB = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
      _getUser();
    FirebaseFirestore.instance
        .collection('leads')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          totalLeads += 1;
          restLeads +=1;
        });
      }
    });


    if(totalLeads > 11){
      setState((){
        isLessLead = true;
      });
    }

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          userL.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('countries')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          applyCountryL.add(doc["name"]);
          currentCountryL.add(doc["name"]);
        });
      }
    });


    FirebaseFirestore.instance
        .collection('leadsource')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          leadSourceL.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('status')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          statusL.add(doc["name"]);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('weightage')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          weightageL.add(doc["name"]);
        });
      }
    });
  }

  _getUser() async{
    _pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {

    String? tempName = _pref?.getString('username');
    String? tempUserID = _pref?.getString('userID');
    String? tempUserType = _pref?.getString('userType');
    userName = tempName.toString();
    currentUserID = tempUserID.toString();
    userType = tempUserType.toString();

    Widget userList(StateSetter setState1) {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: ListView.builder(
              itemCount: userL.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      setState1(() {
                        userB = value!;
                        if(value == true){
                          _chosenUser = userL[index];
                        }else{
                          _chosenUser = null;
                        }

                      });
                    },
                    value:(_chosenUser == userL[index])? userB : false,
                  ),
                  title: Text(
                    userL[index],
                  ),
                );
              }
          ),
        ),
      );
    }

    Widget applyCountryList(StateSetter setState1) {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: ListView.builder(
              itemCount: applyCountryL.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      setState1(() {
                        applyCountryB = value!;
                        if(value == true){
                          _chosenCountry = applyCountryL[index];
                        }else{
                          _chosenCountry = null;
                        }
                      });
                    },
                    value:(_chosenCountry == applyCountryL[index])? applyCountryB : false,
                  ),
                  title: Text(
                    applyCountryL[index],
                  ),
                );
              }
          ),
        ),
      );
    }

    Widget currentCountryList(StateSetter setState1) {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: ListView.builder(
              itemCount: currentCountryL.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      setState1(() {
                        currentCountryB = value!;
                        if(value == true){
                          _chosenCurrentCountry = currentCountryL[index];
                        }else{
                          _chosenCurrentCountry = null;
                        }
                      });
                    },
                    value:(_chosenCurrentCountry == currentCountryL[index])? currentCountryB : false,
                  ),
                  title: Text(
                    currentCountryL[index],
                  ),
                );
              }
          ),
        ),
      );
    }

    Widget leadSourceList(StateSetter setState1) {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: ListView.builder(
              itemCount: leadSourceL.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      setState1(() {
                        leadSourceB = value!;
                        if(value == true){
                          _chosenLeadSource = leadSourceL[index];
                        }else{
                          _chosenLeadSource = null;
                        }
                      });
                    },
                    value:(_chosenLeadSource == leadSourceL[index])? leadSourceB : false,
                  ),
                  title: Text(
                    leadSourceL[index],
                  ),
                );
              }
          ),
        ),
      );
    }

    Widget statusList(StateSetter setState1) {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: ListView.builder(
              itemCount: statusL.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      setState1(() {
                        statusB = value!;
                        if(value == true){
                          _chosenStatus = statusL[index];
                        }else{
                          _chosenStatus = null;
                        }
                      });
                    },
                    value:(_chosenStatus == statusL[index])? statusB : false,
                  ),
                  title: Text(
                    statusL[index],
                  ),
                );
              }
          ),
        ),
      );
    }

    Widget weightageList(StateSetter setState1) {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: ListView.builder(
              itemCount: weightageL.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      setState1(() {
                        weightageB = value!;
                        if(value == true){
                          _chosenWeightage = weightageL[index];
                        }else{
                          _chosenWeightage = null;
                        }
                      });
                    },
                    value:(_chosenWeightage == weightageL[index])? weightageB : false,
                  ),
                  title: Text(
                    weightageL[index],
                  ),
                );
              }
          ),
        ),
      );
    }

    Widget intakeYearList(StateSetter setState1) {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: ListView.builder(
              itemCount: intakeYearL.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      setState1(() {
                        intakeYearB = value!;
                        if(value == true){
                          _chosenIntakeYear = intakeYearL[index];
                        }else{
                          _chosenIntakeYear = null;
                        }
                      });
                    },
                    value:(_chosenIntakeYear == intakeYearL[index])? intakeYearB : false,
                  ),
                  title: Text(
                    intakeYearL[index],
                  ),
                );
              }
          ),
        ),
      );
    }

    Widget _modifiedFromW(StateSetter setState1) {
      return Container(
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
              elevation: 2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              child: MaterialButton(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 10,
                onPressed: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1990, 01),
                    lastDate: DateTime(2101),
                    initialDate: _modifiedFrom ??
                        DateTime.now(),
                  ).then((value) {
                    setState1(() {
                      _modifiedFrom = value;
                    });
                  });
                },
                child: Text(
                  (_modifiedFrom == null)
                      ? 'Select'
                      : DateFormat('yyyy-MM-dd')
                      .format(_modifiedFrom!),
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _modifiedToW(StateSetter setState1) {
      return Container(
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
              elevation: 2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              child: MaterialButton(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 10,
                onPressed: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1990, 01),
                    lastDate: DateTime(2101),
                    initialDate: _modifiedTo ??
                        DateTime.now(),
                  ).then((value) {
                    setState1(() {
                      _modifiedTo = value;
                    });
                  });
                },
                child: Text(
                  (_modifiedTo == null)
                      ? 'Select'
                      : DateFormat('yyyy-MM-dd')
                      .format(_modifiedTo!),
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _taskFromW(StateSetter setState1) {
      return Container(
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
              elevation: 2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              child: MaterialButton(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 10,
                onPressed: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1990, 01),
                    lastDate: DateTime(2101),
                    initialDate: _modifiedFrom ??
                        DateTime.now(),
                  ).then((value) {
                    setState1(() {
                      _taskFrom = value;
                    });
                  });
                },
                child: Text(
                  (_taskFrom == null)
                      ? 'Select'
                      : DateFormat('yyyy-MM-dd')
                      .format(_taskFrom!),
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _taskToW(StateSetter setState1) {
      return Container(
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
              elevation: 2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              child: MaterialButton(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 10,
                onPressed: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1990, 01),
                    lastDate: DateTime(2101),
                    initialDate: _taskTo ??
                        DateTime.now(),
                  ).then((value) {
                    setState1(() {
                      _taskTo = value;
                    });
                  });
                },
                child: Text(
                  (_taskTo == null)
                      ? 'Select'
                      : DateFormat('yyyy-MM-dd')
                      .format(_taskTo!),
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _visaExpiredW(StateSetter setState1) {
      return Container(
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
              elevation: 2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              child: MaterialButton(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 10,
                onPressed: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1990, 01),
                    lastDate: DateTime(2101),
                    initialDate: _visaExpired ??
                        DateTime.now(),
                  ).then((value) {
                    setState1(() {
                      _visaExpired = value;
                    });
                  });
                },
                child: Text(
                  (_visaExpired == null)
                      ? 'Select'
                      : DateFormat('yyyy-MM-dd')
                      .format(_visaExpired!),
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _dateCreatedW(StateSetter setState1) {
      return Container(
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
              elevation: 2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              child: MaterialButton(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 10,
                onPressed: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1990, 01),
                    lastDate: DateTime(2101),
                    initialDate: _dateCreated ??
                        DateTime.now(),
                  ).then((value) {
                    setState1(() {
                      _dateCreated = value;
                    });
                  });
                },
                child: Text(
                  (_dateCreated == null)
                      ? 'Select'
                      : DateFormat('yyyy-MM-dd')
                      .format(_dateCreated!),
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _titleText(String title){
      return Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }


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
                setState((){
                  search = true;
                  nameSearch(value);
                });
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


      final nextButton = ElevatedButton(
        onPressed: (){
          if(restLeads - 10 > 0){
            restLeads = restLeads - 10;
            setState((){
              index = index + 10;
            });
            if(restLeads < 10){
              setState((){
                length = length + restLeads;
              });
            }else{
              setState((){
                length = length + 10;
              });
            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text("No more leads!!")));
          }

        },
        child: Text(
          "NEXT",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      );
      final prevButton =
      ElevatedButton(
        onPressed: (){

          if(restLeads + 10 <= totalLeads){
            restLeads = restLeads + 10;
            setState((){
              index = index - 10;
            });

            if(restLeads > 10){
              setState((){
                length = length - restLeads + 10;
                index = 0;
              });
            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text("No more leads!!")));
          }

        },
        child: Text(
          "PREV",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      );

      final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("leads");

      Widget _buildListView() {

        if(search){
          restLeads = storedocs.length;
          index = 0;
          if(restLeads<10){
            length = restLeads;
          }else{
            length = 10;
          }
        }

        return FutureBuilder<QuerySnapshot>(
            future: _collectionReference.orderBy("timeStamp", descending: true).get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                      'SL NO.',
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


                          for(var i = index;i<(isLessLead?totalLeads:length); i++)...[
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        i.toString(),
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
                                        (storedocs[i]["timeStamp"] != null)
                                            ? DateFormat('dd-MMM-yyyy').format(
                                            storedocs[i]["timeStamp"].toDate())
                                            : "Loading...",
                                        style: TextStyle(
                                          fontSize: 9.0,
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
                                          textAlign: TextAlign.center,
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

                                                                          search =
                                                                          false;
                                                                          storedocs
                                                                              .clear();

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
                StatefulBuilder(builder: (context, StateSetter setState1) {
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
                                _titleText("Assigned User"),
                                _titleText("Apply Country"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                userList(setState1),
                                applyCountryList(setState1),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _titleText("Current Country"),
                                _titleText("Lead Source"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                currentCountryList(setState1),
                                leadSourceList(setState1),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _titleText("Status"),
                                _titleText("Weightage"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                statusList(setState1),
                                weightageList(setState1),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _titleText("Intake Year"),
                              _visaExpiredW(setState1),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               intakeYearList(setState1),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _dateCreatedW(setState1),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _modifiedFromW(setState1),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _modifiedToW(setState1),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _taskFromW(setState1),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _taskToW(setState1),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
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
              storedocs.clear();
              restLeads = totalLeads;
              index = 0;
              if(restLeads<10){
                length = restLeads;
              }else{
                length = 10;
              }

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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: prevButton,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: nextButton,
                                )
                              ],
                            ),
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
        }
      }
      setState(() {});
    } else {
      setState(() {
        storedocs.clear();
        search = false;
        restLeads = totalLeads;
        index = 0;
        if(restLeads<10){
          length = restLeads;
        }else{
          length = 10;
        }
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
        restLeads = totalLeads;
        index = 0;
        if(restLeads<10){
          length = restLeads;
        }else{
          length = 10;
        }
      });
      storedocs.clear();
    }

    Navigator.of(context).pop();
  }
}
