import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rmgateway/model/country_model.dart';
import 'package:rmgateway/model/status_model.dart';
import 'package:rmgateway/model/student_type_model.dart';
import 'package:rmgateway/model/university_model.dart';
import 'package:rmgateway/screens/create_country.dart';
import 'package:rmgateway/screens/create_status.dart';
import 'package:rmgateway/screens/create_student_type.dart';
import 'package:rmgateway/screens/create_university.dart';

class UpdateStatus extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> statusModel;
  const UpdateStatus({Key? key, required this.statusModel}) : super(key: key, );

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {

  final _formKey = GlobalKey<FormState>();
  var nameEditingController ;


  bool? _process;
  int? _count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;

    nameEditingController = TextEditingController(text: widget.statusModel["name"]);


  }
  @override
  Widget build(BuildContext context) {
    final nameField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: nameEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("name cannot be empty!!");
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
              labelText: 'Status',
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




    final updateButton =  Material(
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
          '  Update  ',
          textAlign: TextAlign.center,
          style:
          TextStyle(color: Colors.black),
        ),
      ),
    );



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


    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: AlertDialog(
        backgroundColor: Colors.cyan.shade100,
        title: Center(child: Text("Edit Status")),
        titleTextStyle: TextStyle(fontSize: 20),
        scrollable: true,
        content:SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    nameField,
                    SizedBox(height: 30,),
                    updateButton,
                    SizedBox(height: 10,),
                    backButton,
                    SizedBox(height: 40,),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void AddData() async{
    if (_formKey.currentState!.validate()) {
      final ref = FirebaseFirestore.instance.collection("status").doc(
          widget.statusModel["docID"]);

      StatusModel statusModel = StatusModel();
      statusModel.timeStamp = FieldValue.serverTimestamp();
      statusModel.userID = ref.id;
      statusModel.name = nameEditingController.text;
      statusModel.docID = ref.id;
      ref.set(statusModel.toMap());

      setState(() {
        _process = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Status updated!!")));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CreateStatus()));

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something is wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }
}
