import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rmgateway/model/attendance_model.dart';
import 'package:rmgateway/screens/admin_attendance.dart';
import 'package:rmgateway/screens/attendance.dart';
import 'package:rmgateway/screens/signup.dart';
import 'package:rmgateway/screens/view_lead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final _formKeySecond = GlobalKey<FormState>();
  final nameEditingController = new TextEditingController();

  bool? _process;
  int? _count;

  bool _selection = false;
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
    final emailField = Container(
        width: MediaQuery.of(context).size.width / 3,
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
        width: MediaQuery.of(context).size.width / 3,
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

    final signInButton = Material(
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
              : Log();
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
                '  Log in  ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
      ),
    );

    final _rememberField = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: _selection,
            onChanged: (bool? value){
              setState(() {
                _selection = value!;
              });
            }
        ),
        SizedBox(width: 10,),
        Text(
          "Remember me",
        )
      ],
    );

    final nameField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: nameEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("email cannot be empty!!");
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

    final forgetButton = TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder:
                  (BuildContext context) =>
                  AlertDialog(
                    title: Text("Forget Password"),
                    content: Form(
                      key: _formKeySecond,
                        child: nameField
                    ),
                    actions: [
                      IconButton(
                          icon: new Icon(
                              Icons.close),
                          onPressed: () {
                            Navigator.pop(
                                context);
                          }),
                      IconButton(
                          icon: new Icon(
                              Icons.delete),
                          onPressed: () async {
                            if(_formKeySecond.currentState!.validate()){
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: nameEditingController.text).whenComplete((){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.green, content: Text("Password recovery email sent!")));
                                Navigator.of(context).pop();
                              });
                            }
                          })
                    ],
                  ));
        },
        child: Text(
          "Forget password",
          style: TextStyle(color: Colors.red.shade800),
        ));

    final createButton = Row(
      children: [
        Text(
          "Do not have any account ?",
          style: TextStyle(color: Colors.grey),
        ),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                  (route) => false);
            },
            child: Text("Click here to create new user"))
      ],
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: AlertDialog(
        backgroundColor: Colors.cyan.shade100,
        title: Center(child: Text("Log In")),
        titleTextStyle: TextStyle(fontSize: 20),
        scrollable: true,
        content: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    emailField,
                    SizedBox(
                      height: 20,
                    ),
                    passwordField,
                    SizedBox(
                      height: 30,
                    ),
                    signInButton,
                    SizedBox(
                      height: 10,
                    ),
                    _rememberField,
                    SizedBox(
                      height: 10,
                    ),
                    forgetButton,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                      child: createButton,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Log() async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(
              email: emailEditingController.text,
              password: passwordEditingController.text)
          .then((uid) => {AddData()})
          .catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text("Login failed!!")));
        setState(() {
          _process = false;
          _count = 1;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something is wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }

  void AddData() async {
    var pref = await SharedPreferences.getInstance();
    var _currentUser = FirebaseAuth.instance.currentUser;
    if(_selection){
      pref.setString("email", emailEditingController.text);
      pref.setString("password", passwordEditingController.text);
    }else{
      pref.remove("email");
      pref.remove("password");
    }
    if (_currentUser?.emailVerified == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Login Successful!!")));
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc["email"].toString().toLowerCase() ==
                  emailEditingController.text.toLowerCase() &&
              doc["userType"].toString().toLowerCase() == "admin") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ViewLead()),
                (route) => false);
          } else if (doc["email"].toString().toLowerCase() ==
              emailEditingController.text.toLowerCase()) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewLead()),
                (route) => false);
          }
        }
      });
    } else{
      _auth.currentUser!.sendEmailVerification().whenComplete((){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green, content: Text("Verification email sent!!")));
        setState(() {
          _process = false;
          _count = 1;
          emailEditingController.clear();
          passwordEditingController.clear();
        });
      }).onError((error, stackTrace){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text("Verification email sent failed!!")));
        setState(() {
          _process = false;
          _count = 1;
          emailEditingController.clear();
          passwordEditingController.clear();
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Please verify your email!!")));
      setState(() {
        _process = false;
        _count = 1;
        emailEditingController.clear();
        passwordEditingController.clear();
      });
    }
  }
}
