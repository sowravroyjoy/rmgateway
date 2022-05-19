// import 'package:flutter/material.dart';
//
// class UserProfile extends StatefulWidget {
//   final String userID;
//   const UserProfile({Key? key, required this.userID}) : super(key: key);
//
//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }
//
// class _UserProfileState extends State<UserProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rmgateway/screens/employee_details.dart';
import 'package:rmgateway/screens/update_user.dart';

import '../model/user_model.dart';

class UserProfile extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userModel;
  const UserProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {



String? networkImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadedUrl();
  }


  void downloadedUrl() async {
   networkImage =  await  FirebaseStorage.instance.ref().child("files/${widget.userModel["docID"]}/${widget.userModel["imageUrl"]}").getDownloadURL()
        .whenComplete((){
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
      final backButton = TextButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text(
          "Back",
          style: TextStyle(
              color: Colors.blue.shade800
          ),
        )
    );

      Widget _singleField(String topic, var value) {
        return Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 40,
          child: Row(
            children: [
              Text(
                topic + "  :   ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.cyan.shade900),
              ),
              Text(
                value.toString(),
                style: TextStyle(),
              )
            ],
          ),
        );
      }

      final editButton = TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('users')
                .get()
                .then((QuerySnapshot querySnapshot) {
              for (var doc in querySnapshot.docs) {
                if (doc["docID"] == widget.userModel["docID"] && doc["userType"].toString().toLowerCase() != "admin" ) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateUser(userModel: doc)));
                }
              }
            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
          ));

    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: AlertDialog(
        backgroundColor: Colors.cyan.shade100,
        title: Center(child: Text("Information")),
        titleTextStyle: TextStyle(fontSize: 20),
        scrollable: true,
        content:SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  (networkImage!= null)?CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      networkImage!
                    ),
                  ):Center(child: CircularProgressIndicator(),),
                  SizedBox(height: 20,),
                  _singleField("Name", widget.userModel["name"]),
                  SizedBox(height: 20,),
                  _singleField("Contact", widget.userModel["contact"]),
                  SizedBox(height: 20,),
                  _singleField("Email", widget.userModel["email"]),
                  SizedBox(height: 20,),
                  _singleField("User Type", widget.userModel["userType"]),
                  SizedBox(height: 20,),
                  editButton,
                  SizedBox(height: 20,),
                  backButton,
                  SizedBox(height: 40,),

                ],
              )
            ),
          ),
        ),
      ),
    );
  }



}
