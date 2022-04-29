import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Apply extends StatefulWidget {
  const Apply({Key? key}) : super(key: key);

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = new TextEditingController();
  final contactEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final countryEditingController = new TextEditingController();
  final interestedCountryEditingController = new TextEditingController();

  final _ieltsTypes = ['Yes', 'No', 'Intended Date'];
  String? _chosenIelts;


  final _titleTypes = ['MR', 'Miss', 'Mrs'];
  String? _chosenTitle;


  bool? _process;
  int? _count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
  }
  @override
  Widget build(BuildContext context) {
    final nameField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan.shade100,
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
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan.shade100,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
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
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan.shade100,
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

    final countryField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan.shade100,
            autofocus: false,
            controller: countryEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Country cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              countryEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Country',
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

    final interestedCountryField = Container(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
            cursorColor: Colors.cyan.shade100,
            autofocus: false,
            controller: interestedCountryEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Interested Country cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              interestedCountryEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Interested Country',
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


    final createButton =  Material(
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
          '  Submit  ',
          textAlign: TextAlign.center,
          style:
          TextStyle(color: Colors.black),
        ),
      ),
    );



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
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            items: _ieltsTypes.map(buildMenuIelts).toList(),
            hint: Text(
              'IELTS',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenIelts,
            onChanged: (newValue) {
              setState(() {
                _chosenIelts = newValue;
              });
            }));



    DropdownMenuItem<String> buildMenuTitle(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.black),
        ));

    final titleDropdown = Container(
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
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            items: _titleTypes.map(buildMenuTitle).toList(),
            hint: Text(
              'Title',
              style: TextStyle(color: Colors.black),
            ),
            value: _chosenTitle,
            onChanged: (newValue) {
              setState(() {
                _chosenTitle = newValue;
              });
            }));


    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: AlertDialog(
        backgroundColor: Colors.cyan.shade100,
        title: Center(child: Text("Please Give Your Information\n         To Get Best Services" , style: TextStyle(fontSize: 30),)),
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
                    titleDropdown,
                    SizedBox(height: 20,),
                    nameField,
                    SizedBox(height: 20,),
                    contactField,
                    SizedBox(height: 20,),
                    emailField,
                    SizedBox(height: 20,),
                    ieltsDropdown,
                    SizedBox(height: 20,),
                    countryField,
                    SizedBox(height: 20,),
                    interestedCountryField,
                    SizedBox(height: 30,),
                    createButton,
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


  void AddData(){

  }
}
