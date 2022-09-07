import 'package:flutter/material.dart';
import 'package:smart_personal_finance/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_personal_finance/Expense.dart';
import 'package:intl/intl.dart';
import 'package:smart_personal_finance/Home.dart';

class ExpenseAdd extends StatefulWidget {
  final User1 recordObject;
  ExpenseAdd({this.recordObject});
  @override
  _ExpenseAddState createState() => _ExpenseAddState();
}

class _ExpenseAddState extends State<ExpenseAdd> {
  final myController = TextEditingController();
  final myController1 = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget idisposes disposed.
    myController.dispose();
    super.dispose();
  }



  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController(text: '${DateTime.now().day.toString().padLeft(2,'0')}' + '-' + '${DateTime.now().month.toString().padLeft(2,'0')}' + '-' + '${DateTime.now().year}');



  String dropdownValue = 'Household';
  String dropdownValue1 = 'Cash';
  String Value = '';
  String Value1 = '';
  int count = 0;
  //Category selectedUser;
  List<String> Categories = [
    'Household',
    'Food',
    'Entertainment',
    'Family',
    'Health',
    'Shopping',
    'Other',
  ];

  List<String> Transaction = [
    'Cash',
    'Cheque',
    'EFT',
  ];

  void getDropDownItem(){

    setState(() {
      Value = dropdownValue ;
    });
  }

  void getDropDownItem1(){

    setState(() {
      Value1 = dropdownValue1 ;
    });
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: (){
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("Error"),
      content: Text("Expense Amount for $Value exceeds its budget amount"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  showAlertDialog1(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: (){
        Navigator.pop(context);
      },
    );
        AlertDialog alert = AlertDialog(
          title:  Text("Error"),
          content: Text("Amount cannot be Empty"),
          actions: [
            okButton,
          ],
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
    // set up the AlertDialog
    // show the dialog
  }


  showAlertDialog2(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: (){
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("Error"),
      content: Text("Budget doesot exist for $Value. Create it's budget first"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var parsedDate = DateTime.parse('$picked');
        String convertedDate = new DateFormat("dd-MM-yyyy").format(parsedDate);
        _date.value = TextEditingValue(text: convertedDate.toString());
      });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: new AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: ()async{
              final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
              FirebaseUser user = await _firebaseAuth.currentUser();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Expense(recordObject: new User1("${user.uid}","${user.email}"))));
              },
            ),
            title: new Text('Add Expense'),
          ),
        body: new Container(
          padding: EdgeInsets.only(top : 110.0, left: 16.0, right: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new DropdownButton<String>(
                isExpanded : true,
                hint: Text('Select Category'),
                value: dropdownValue,
                onChanged: (String data) {
                  setState(() {
                    dropdownValue = data;
                  });
                },
                items: Categories.map<DropdownMenuItem<String>>((String value) {
                  return  DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: <Widget>[
                        Text(value, style:  TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              new DropdownButton<String>(
                isExpanded : true,
                hint: Text('Select Transaction Type'),
                value: dropdownValue1,
                onChanged: (String data) {
                  setState(() {
                    dropdownValue1 = data;
                  });
                },
                items: Transaction.map<DropdownMenuItem<String>>((String value1) {
                  return  DropdownMenuItem<String>(
                    value: value1,
                    child: Row(
                      children: <Widget>[
                        Text(value1, style:  TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              new TextField(
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  hintText: 'Amount'
                ),
                controller: myController,
              ),
              new GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _date,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: '(Current Date by default)',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              new TextField(
                decoration: new InputDecoration(
                    hintText: 'Remark'
                ),
                controller: myController1,
              ),
              new RaisedButton(child: new Text('Save',style: new TextStyle(fontSize: 20.0),),
                color: Colors.green,
                splashColor: Colors.lightGreen,
                onPressed: () async{
                  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                  FirebaseUser user1 = await _firebaseAuth.currentUser();
                  getDropDownItem();
                  getDropDownItem1();
                  if(myController.text == '')
                  {
                    showAlertDialog1(context);
                  }
                  else
                    {
                      Firestore.instance.collection('budget').where('Category', isEqualTo: '$Value').where('UserId', isEqualTo: user1.uid).getDocuments().then((docsnap){
                        if(docsnap.documents.length != 0)
                          {
                            int i = int.parse(docsnap.documents[0]['value']);
                            print(i);
                            if(int.parse('${myController.text}') > i)
                            {
                              showAlertDialog(context);
                            }
                            else
                            {
                              int j = int.parse(myController.text);
                              Firestore.instance.collection('Expense').where('Category', isEqualTo: '$Value').where('UserId', isEqualTo: user1.uid).getDocuments().then((docsnap1){
                                for(int i = 0; i < docsnap1.documents.length; i++)
                                {
                                  j = j + int.parse(docsnap1.documents[i]['Value']);
                                }
                                print(j);
                                if(j > i)
                                {
                                  showAlertDialog(context);
                                }
                                else
                                {

                                  print(selectedDate);
                                  Databaseservice(uid: user1.uid).AddExpenseData('$Value','$Value1',"${myController.text}", selectedDate, '${myController1.text}');

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => Expense(recordObject: new User1("${user1.uid}","${user1.email}"))));
                                }
                              });
                            }
                          }
                        else
                          showAlertDialog2(context);
                      });
                    }
                },)
            ],
          ),
        ),
      ),
    );
  }
}
