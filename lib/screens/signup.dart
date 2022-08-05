

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rmgateway/model/user_model.dart';
import 'package:rmgateway/screens/signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = new TextEditingController();
  final contactEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();

  final _userTypes = [ 'Employee', 'Manager', 'Councilor','Senior Councilor','Admission Officer','Senior Admission Officer','Marketing Officer', 'Senior Marketing Officer','CEO','Office Assistant','Complaint Officer'];
  String? _chosenUser;
  bool? _process;
  int? _count;

  Uint8List? file;
  String? fileName;
  double progress = 0.0;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
  }
  @override
  Widget build(BuildContext context) {
    final imageName = (fileName != null) ? fileName : "No File Selected";


    final nameField = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 3,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: nameEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Name cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              nameEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final contactField = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 3,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            autofocus: false,
            controller: contactEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Contact cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              contactEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Contact',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final emailField = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 3,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: emailEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Email cannot be empty!!");
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
              floatingLabelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final passwordField = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 3,
        child: TextFormField(
            obscureText: true,
            cursorColor: Colors.blue,
            autofocus: false,
            controller: passwordEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              RegExp regExp = RegExp(r'^.{8,}$');
              if (value!.isEmpty) {
                return ("Password cannot be empty!!");
              } else if (!regExp.hasMatch(value)) {
                return ("enter minimum 8 digit password!!");
              }
              return null;
            },
            onSaved: (value) {
              passwordEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.black),
              floatingLabelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final selectButton = ElevatedButton(
        onPressed: () {
          selectFile();
        },
        child: Text(
          "Select File",
          style: TextStyle(
              color: Colors.black
          ),
        )
    );

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
              : signUp();
        },
        child: (_process!)
            ? (file != null)?Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$progress%',
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
                      value: progress / 100,
                      color: Colors.black,
                      strokeWidth: 2,
                    ))),
          ],
        )
        :Row(
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
          style:
          TextStyle(color: Colors.black),
        ),
      ),
    );


    final signInButton = Row(
      children: [
        Text(
          "Already have an account ?",
          style: TextStyle(
              color: Colors.grey
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
            },
            child: Text(
                "Click here to log in"
            )
        )
      ],
    );

    DropdownMenuItem<String> buildMenuItem(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ));

    final userDropdown = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 3,
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
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            items: _userTypes.map(buildMenuItem).toList(),
            hint: Text(
              'Select User Type',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenUser,
            onChanged: (newValue) {
              setState(() {
                _chosenUser = newValue;
              });
            }));


    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: AlertDialog(
        backgroundColor: Colors.cyan.shade100,
        title: Center(child: Text("Create User")),
        titleTextStyle: TextStyle(fontSize: 20),
        scrollable: true,
        content: Container(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  nameField,
                  SizedBox(height: 20,),
                  contactField,
                  SizedBox(height: 20,),
                  emailField,
                  SizedBox(height: 20,),
                  passwordField,
                  SizedBox(height: 20,),
                  userDropdown,
                  SizedBox(height: 20,),
                  selectButton,
                  Text(
                    imageName!,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 20,),
                  createButton,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                    child: signInButton,
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp()async{
    if(_formKey.currentState!.validate() && _chosenUser != null){
          await _auth.createUserWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text)
              .then((value) => {
               postDetailsToFirestore()
          }).catchError((e)
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red, content: Text("User creation failed!!")));
            setState(() {
              _process = false;
              _count = 1;
            });
          });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something is wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }

  void postDetailsToFirestore() async{
    await _auth.currentUser?.sendEmailVerification();
   final ref =   FirebaseFirestore.instance.collection("users").doc();
   final userid = FirebaseAuth.instance.currentUser?.uid;

   UserModel userModel = UserModel();
   userModel.timeStamp = FieldValue.serverTimestamp();
   userModel.userID = userid;
   userModel.name = nameEditingController.text;
   userModel.contact = contactEditingController.text;
   userModel.email = emailEditingController.text;
   userModel.userType = _chosenUser;
   userModel.imageUrl = fileName;
   userModel.docID = ref.id;
   ref.set(userModel.toMap()).whenComplete((){
     if(file != null){
       UploadTask task = FirebaseStorage.instance.ref().child("files/${ref.id}/$fileName").putData(file!);

       task.snapshotEvents.listen((event) {
         setState(() {
           progress = ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) * 100).roundToDouble();
         });

         if(progress == 100){
           setState(() {
             _process = false;
           });
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               backgroundColor: Colors.green, content: Text("User Created!!")));

           // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           //     backgroundColor: Colors.green, content: Text("Verification email sent!!")));

           Navigator.pushAndRemoveUntil(
               context, MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
         }
       });

     }else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.green, content: Text("User Created!!")));

       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.green, content: Text("Verification email sent!!")));

       Navigator.pushAndRemoveUntil(
           context, MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
     }
   });

  }

  Future selectFile()async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    setState(() {
      file = result.files.single.bytes;
      fileName = result.files.single.name;
    });
  }

}
