import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rmgateway/screens/update_user.dart';
import 'package:rmgateway/screens/view_lead.dart';

import '../model/lead_model.dart';

class TodayTask extends StatefulWidget {
  final String currentUserName;
  const TodayTask({Key? key, required this.currentUserName}) : super(key: key);

  @override
  State<TodayTask> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {

  int totalLeads = 0;
  final TextEditingController searchController = TextEditingController();

  final List storedocs = [];
  bool search = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        width: MediaQuery.of(context).size.width / 4,
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
              labelText: 'Search Task Subject',
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
                    color: Colors.cyan.shade100,
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
                                  color: Colors.cyan.shade300,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Date',
                                        style: TextStyle(
                                          fontSize: 20.0,
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
                                        'Task Subject',
                                        style: TextStyle(
                                          fontSize: 20.0,
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
                                        'Task Contact',
                                        style: TextStyle(
                                          fontSize: 20.0,
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
                                        'Task Status',
                                        style: TextStyle(
                                          fontSize: 20.0,
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
                                        'Change Task Status',
                                        style: TextStyle(
                                          fontSize: 20.0,
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


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Today's Task", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.cyan.shade100,
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ViewLead()));
          },
          icon: Icon(
            Icons.home_rounded,
            color: Colors.cyan.shade700,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                      "Total Tasks  :  $totalLeads"
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: nameSearchField,
                )
              ],
            ),
            SizedBox(height: 10,),
            Expanded(child: _buildListView())
          ],
        ),
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
