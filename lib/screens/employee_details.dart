import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rmgateway/screens/update_user.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({Key? key}) : super(key: key);

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {

  int totalEmployees = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["userType"].toString().toLowerCase() != "Admin") {
           totalEmployees += 1;
        }
      }
      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {

    final CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection("users");

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
              snapshot.data!.docs.where((element) => element["userType"].toString().toLowerCase() != "Admin")
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
                                        'Contact',
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
                                        'Email',
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
                                        'User Type',
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
                                        'Edit',
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
                                        'Delete',
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
                                        storedocs[i]["name"],
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
                                        storedocs[i]["contact"],
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
                                        storedocs[i]["email"],
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
                                        storedocs[i]["userType"],
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
                                      child:    IconButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .get()
                                              .then((QuerySnapshot querySnapshot) {
                                            for (var doc in querySnapshot.docs) {
                                              if(doc["docID"] == storedocs[i]["docID"]){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => UpdateUser(userModel: doc,)));
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
                                      child:    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context)=>AlertDialog(
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
                                                            if(doc["docID"] == storedocs[i]["docID"]){
                                                              setState(() {
                                                                doc.reference.delete();
                                                                Navigator.pop(context);
                                                              });
                                                            }
                                                          }
                                                        });
                                                      })
                                                ],
                                              )
                                          );
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
        title: Text("Employee Details", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.cyan.shade100,
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
                    "Total Employees  :  $totalEmployees"
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                      "Total Employees  :  $totalEmployees"
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(child: _buildListView())
          ],
        ),
      ),
    );
  }
}
