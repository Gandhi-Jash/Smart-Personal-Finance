import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_personal_finance/BudgetAdd.dart';
import 'package:smart_personal_finance/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_personal_finance/Home.dart';
import 'package:smart_personal_finance/Login.dart';

class Budget extends StatefulWidget {
  final User1 recordObject;
  Budget({this.recordObject});
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {

  final myController = TextEditingController();


  showAlertDialog(String Index ,BuildContext context) {

    // set up the button
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: (){
        Navigator.pop(context);
      },
    );

    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async{
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        FirebaseUser user1 = await _firebaseAuth.currentUser();
        await Databaseservice(uid: user1.uid).DeleteDocument('$Index');
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("Error"),
      content: Text("Are you sure you want to delete budget for the selected field"),
      actions: [
        cancelButton,
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
      content: Text("Cannot delete as the budget has dependencies"),
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


  showAlertDialog3(BuildContext context) {

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
      content: Text("Amount cannot be empty"),
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

  showAlertDialog4(BuildContext context) {

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
      content: Text("Budget cannot be less than Expense amount"),
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

    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: ()async{
            final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
            FirebaseUser user = await _firebaseAuth.currentUser();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HomePage(user: new User("${user.uid}","${user.email}"))));
          },
        ),
        title: new Text('Budget'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => BudgetAdd()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('budget').where('UserId', isEqualTo: widget.recordObject.userid).snapshots(),
        builder: (context, snapshots){
            if (snapshots.hasData){
              return ListView.builder(
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context,index) {
                    DocumentSnapshot user = snapshots.data.documents[index];
                    String s1 = user.documentID;
                    return ListTile(
                      title: Text(user.data['Category']),
                      subtitle: Text(user.data['value']),
                      onTap: () async {
                        print('$index');
                        String s = user.data['Category'];
                        await showDialog<String>(
                          context: context,
                          child: new AlertDialog(
                            contentPadding: const EdgeInsets.all(16.0),
                            content: new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new TextField(
                                    controller: myController,
                                    autofocus: true,
                                    decoration: new InputDecoration(
                                        labelText: 'Change Value for $s', hintText: 'eg. 500'),
                                  ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                  child: const Text('CANCEL'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              new FlatButton(
                                  child: const Text('SAVE'),
                                  onPressed: () async {
                                    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                    FirebaseUser user1 = await _firebaseAuth.currentUser();
                                    if(myController.text == '')
                                    {
                                      showAlertDialog3(context);
                                    }
                                    else{
                                      Firestore.instance.collection('UserBalance').where('UserId', isEqualTo: '${user1.uid}').getDocuments().then((docsnap){
                                        String i = docsnap.documents[0]['Balance'].toString();
                                        if(int.parse('${myController.text}') > int.parse('$i'))
                                        {
                                          showAlertDialog1(context);
                                        }
                                        else{
                                          Firestore.instance.collection('budget').where('UserId', isEqualTo: '${user1.uid}').getDocuments().then((docsnap1){
                                            int j = int.parse(myController.text);
                                            for(int i = 0; i < docsnap1.documents.length; i++)
                                            {
                                              if(docsnap1.documents[i]['Category'] != user.data['Category'])
                                              {
                                                j = j + int.parse(docsnap1.documents[i]['value']);
                                              }
                                            }
                                            if(j > int.parse('$i'))
                                            {
                                              showAlertDialog1(context);
                                            }
                                            else
                                            {
                                              int sum = 0;
                                              Firestore.instance.collection('Expense').where('Category', isEqualTo: user.data['Category']).where('UserId', isEqualTo: '${user1.uid}').getDocuments().then((docsnap3){
                                                if(docsnap3.documents.length != 0)
                                                  {
                                                    if(docsnap3.documents.length == 1){
                                                      sum = int.parse(docsnap3.documents[0]['Value']);
                                                      if(int.parse('${myController.text}') < sum)
                                                      {
                                                        showAlertDialog4(context);
                                                      }
                                                      else
                                                      {
                                                        Databaseservice(uid: user1.uid).AddBudgetData("$s1","${myController.text}");
                                                        myController.text = '';
                                                        Navigator.pop(context);
                                                      }
                                                    }
                                                    else{
                                                      for(int i = 0; i < docsnap1.documents.length; i++)
                                                      {
                                                        sum = sum + int.parse(docsnap3.documents[i]['Value']);
                                                      }
                                                      print(sum);
                                                      if(int.parse('${myController.text}') < sum)
                                                      {
                                                        showAlertDialog4(context);
                                                      }
                                                      else
                                                      {
                                                        Databaseservice(uid: user1.uid).AddBudgetData("$s1","${myController.text}");
                                                        myController.text = '';
                                                        Navigator.pop(context);
                                                      }
                                                    }
                                                  }
                                                else{
                                                  Databaseservice(uid: user1.uid).AddBudgetData("$s1","${myController.text}");
                                                  myController.text = '';
                                                  Navigator.pop(context);
                                                }
                                              });
                                            }
                                          });
                                        }
                                      });
                                    }
                                  })
                            ],
                          ),
                        );
                      },
                      onLongPress: () async {
                        Widget cancelButton = FlatButton(
                          child: Text("Cancel"),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        );

                        Widget okButton = FlatButton(
                          child: Text("Yes"),
                          onPressed: () async{
                            Navigator.pop(context);
                            final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                            FirebaseUser user1 = await _firebaseAuth.currentUser();
                            Firestore.instance.collection('Expense').where('UserId', isEqualTo: '${user1.uid}').getDocuments().then((docsnap){
                              if(docsnap.documents.length != 0)
                                {
                                  String s = user.data['Category'];
                                  for(int i =0; i < docsnap.documents.length; i++)
                                  {
                                    if(docsnap.documents[i]['Category'] == '$s'){
                                      showAlertDialog2(context);
                                      return;
                                    }
                                    else
                                    {
                                      print(1);
                                      Databaseservice(uid: user1.uid).DeleteDocument('$s1');
                                    }
                                  }
                                }
                              else{
                                print(2);
                                Databaseservice(uid: user1.uid).DeleteDocument('$s1');
                              }

                            });

                          },
                        );
                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title:  Text("!!"),
                          content: Text("Are you sure you want to delete budget for the selected field"),
                          actions: [
                            cancelButton,
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
                      },
                    );
                  }
              );
            }
            else if(!snapshots.hasData){
              return Center(
                child: Text('No data'),
              );
            }
            return null;
        },
      ),
    );
  }
}
