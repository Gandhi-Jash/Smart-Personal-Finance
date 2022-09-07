import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_finance/Budget.dart';
import 'package:smart_personal_finance/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_personal_finance/Home.dart';


class BudgetAdd extends StatefulWidget {
  final User1 recordObject;
  BudgetAdd({this.recordObject});
  @override
  _BudgetAddState createState() => _BudgetAddState();
}

class _BudgetAddState extends State<BudgetAdd> {
  @override

  final myController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget idisposes disposed.
    myController.dispose();
    super.dispose();
  }

  String dropdownValue = 'Household';
  String Value = '';
  var count = 0;
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

  void getDropDownItem(){

    setState(() {
      Value = dropdownValue ;
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
      content: Text("Budget Amount cannot be greater than current balance"),
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

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("Error"),
      content: Text("Budget for $Value has already been created"),
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
      content: Text("Amount cannot be Empty"),
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
                    builder: (BuildContext context) => Budget(recordObject: new User1("${user.uid}","${user.email}"))));
              },
            ),
            title: new Text('Add Budget'),
          ),
          body: new Container(
            padding: EdgeInsets.only(top : 110.0, left: 16.0, right: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Center(child : Text('Create Budget',style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
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
                new TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      hintText: 'Amount'
                  ),
                  controller: myController,
                ),
                new RaisedButton(child: new Text('Save',style: new TextStyle(fontSize: 20.0),),
                  color: Colors.green,
                  splashColor: Colors.lightGreen,
                  onPressed: () async{
                    if(myController.text == "")
                      {
                        showAlertDialog2(context);
                      }
                    else{
                        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                        FirebaseUser user1 = await _firebaseAuth.currentUser();
                        getDropDownItem();
                        Firestore.instance.collection('UserBalance').where('UserId', isEqualTo: '${user1.uid}').getDocuments().then((docsnap){
                        String i = docsnap.documents[0]['Balance'].toString();
                        if(int.parse('${myController.text}') > int.parse('$i'))
                        {
                          showAlertDialog(context);
                        }
                        else
                        {
                              Firestore.instance.collection('budget').where('UserId', isEqualTo: '${user1.uid}').getDocuments().then((docsnap1){
                                if(docsnap1.documents.length != 0)
                                  {
                                    int count1 = 0;
                                    int j = int.parse(myController.text);
                                    print(docsnap1.documents[0]['Category'].toString());
                                    print('$Value');
                                    for(int i = 0; i < docsnap1.documents.length; i++)
                                    {
                                      j = j + int.parse(docsnap1.documents[i]['value']);
                                      if('$Value' == (docsnap1.documents[i]['Category']))
                                        count1++;
                                    }
                                    print(count1);
                                    if(j > int.parse('$i'))
                                    {
                                      showAlertDialog(context);
                                    }
                                    else if(count1 > 0)
                                    {
                                      showAlertDialog1(context);
                                    }
                                    else
                                    {
                                      Databaseservice(uid: user1.uid).UpdateBudgetData('$Value',"${myController.text}");
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (BuildContext context) => Budget(recordObject: new User1("${user1.uid}","${user1.email}"))));
                                    }
                                  }
                                else
                                  {
                                    Databaseservice(uid: user1.uid).UpdateBudgetData('$Value',"${myController.text}");
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) => Budget(recordObject: new User1("${user1.uid}","${user1.email}"))));
                                  }

                              });
                        }
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
