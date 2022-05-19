import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rmgateway/model/attendance_model.dart';
import 'package:rmgateway/screens/update_user.dart';
import 'package:rmgateway/screens/view_lead.dart';

class Attendance extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> employeeModel;
  const Attendance({Key? key,required this.employeeModel}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  bool _processi = false;
  bool _processo = false;
  int _counti = 1;
  int _counto = 1;

  bool _showOut = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FirebaseAuth.instance.signOut();

  }

  @override
  Widget build(BuildContext context) {

    final CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection("attendance");

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

              final List storedocs = [];
              snapshot.data!.docs.where((element) => element["employeeID"] == widget.employeeModel["docID"])
                  .map((DocumentSnapshot document) {
                Map a = document.data() as Map<String, dynamic>;
                storedocs.add(a);
                a['id'] = document.id;
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
                                        'Name',
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
                                        'Clock In',
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
                                        'Clock Out',
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
            (  storedocs[i]["timeStamp"] != null) ?  DateFormat('dd-MMM-yyyy').format(storedocs[i]["timeStamp"].toDate()): "Loading...",
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
                                          (  storedocs[i]["inTimeStamp"] != null) ?   (storedocs[i]["dTimestamp"]!= "out")?  DateFormat('K:mm:ss').format(storedocs[i]["inTimeStamp"].toDate()): "0":"Loading...",
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
                                        child:  Text(
                                          (  storedocs[i]["outTimeStamp"] != null) ? (storedocs[i]["dTimestamp"]== "out")?  DateFormat('K:mm:ss').format(storedocs[i]["outTimeStamp"] .toDate()): "0":"Loading...",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
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


    final inButton =  Material(
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
          style:
          TextStyle(color: Colors.black),
        ),
      ),
    );

    final outButton =  Material(
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
          style:
          TextStyle(color: Colors.black),
        ),
      ),
    );





    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Please Ensure Your Attendance", style: TextStyle(color: Colors.black),),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  inButton,
                  outButton
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(child: _buildListView())
          ],
        ),
      ),
    );
  }


  void AddInData() async{

    final ref = FirebaseFirestore.instance.collection("attendance").doc();

    AttendanceModel attendanceModel = AttendanceModel();
    attendanceModel.timeStamp = FieldValue.serverTimestamp();
    attendanceModel.inTimeStamp =  FieldValue.serverTimestamp();
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


  void AddOutData() async{
    final ref = FirebaseFirestore.instance.collection("attendance").doc();
      AttendanceModel attendanceModel = AttendanceModel();
      attendanceModel.timeStamp =FieldValue.serverTimestamp();
    attendanceModel.inTimeStamp =  FieldValue.serverTimestamp();
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
