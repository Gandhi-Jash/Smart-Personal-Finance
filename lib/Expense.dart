import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_personal_finance/database.dart';
import 'package:smart_personal_finance/ExpenseAdd.dart';
import 'package:intl/intl.dart';
import 'package:smart_personal_finance/Home.dart';
import 'package:smart_personal_finance/Login.dart';

class Expense extends StatefulWidget {
  final User1 recordObject;
  Expense({this.recordObject});
  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {


  final myController = TextEditingController();
  final myController1 = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  final _date = TextEditingController();
  TextEditingController _date1 = new TextEditingController(text: '${DateTime.now().day.toString().padLeft(2,'0')}' + '-' + '${DateTime.now().month.toString().padLeft(2,'0')}' + '-' + '${DateTime.now().year}');
  TextEditingController _date2 = new TextEditingController(text: '${DateTime.now().day.toString().padLeft(2,'0')}' + '-' + '${DateTime.now().month.toString().padLeft(2,'0')}' + '-' + '${DateTime.now().year}');


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

        await Databaseservice(uid: user1.uid).DeleteExpenseData('$Index');
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("!!"),
      content: Text("Are you sure you want to delete this Expense"),
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
      content: Text("Amount cannot be greater than budget"),
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

  Future<Null> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate1,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate1)
      setState(() {
        selectedDate1 = picked;
        var parsedDate = DateTime.parse('$picked');
        String convertedDate = new DateFormat("dd-MM-yyyy").format(parsedDate);
        _date1.value = TextEditingValue(text: convertedDate.toString());
      });
  }


  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
        var parsedDate = DateTime.parse('$picked');
        String convertedDate = new DateFormat("dd-MM-yyyy").format(parsedDate);
        _date2.value = TextEditingValue(text: convertedDate.toString());
      });
  }



  filterByDate(BuildContext context) {

    // set up the button
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: (){
        Navigator.pop(context);
      },
    );

    Widget okButton = FlatButton(
      child: Text("Search"),
      onPressed: () async{

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("Error"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new GestureDetector(
            onTap: () => _selectDate1(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _date1,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'From Date',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: () => _selectDate2(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _date2,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'To Date',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
        title: new Text('Expense'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ExpenseAdd()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Expense').where('UserId', isEqualTo: widget.recordObject.userid).snapshots(),
        builder: (context, snapshots){
          if (snapshots.hasData){
            return ListView.builder(
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context,index) {
                  DocumentSnapshot user = snapshots.data.documents[index];
                  String s1 = user.documentID;
                  DateTime dt1 = user.data['Date'].toDate();
                  String convertedDate = new DateFormat("dd-MM-yyyy").format(dt1);
                  return Card(
                      child: ListTile(
                        isThreeLine: true,
                        title: Text(user.data['Category']),
                        subtitle: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Amount :'+' '+user.data['Value']),
                            Text('Date : $convertedDate'),
                            Text('Transaction Type :'+ ' '+user.data['TransactionType']),
                          ],
                        ),

                        onTap: () async {
                          print('$index');
                          DateTime dt = user.data['Date'].toDate();
                          String convertedDate = new DateFormat("dd-MM-yyyy").format(dt);
                          _date.text = '$convertedDate';
                          myController1.text = user.data['Remark'];
                          String s = user.data['Category'];
                          await showDialog<String>(
                            context: context,
                            child: new AlertDialog(
                              title: Text('Update Value for $s'),
                              contentPadding: const EdgeInsets.all(16.0),
                              content: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Container(
                                    child: new TextField(
                                      controller: myController,
                                      autofocus: true,
                                      decoration: new InputDecoration(
                                        hintText: 'Amount',
                                      ),
                                    ),
                                  ),
                                  new GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: _date,
                                        keyboardType: TextInputType.datetime,
                                        decoration: InputDecoration(
                                          hintText: 'Date',
                                          prefixIcon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    child: new TextField(
                                      controller: myController1,
                                      autofocus: true,
                                      decoration: new InputDecoration(
                                        hintText: 'Remark',
                                      ),
                                    ),
                                  ),
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
                                        showAlertDialog1(context);
                                      }
                                      else
                                      {
                                      Firestore.instance.collection('budget').where('Category', isEqualTo: '$s').where('UserId', isEqualTo: user1.uid).getDocuments().then((docsnap){
                                        int i = int.parse(docsnap.documents[0]['value']);
                                        if(int.parse('${myController.text}') > i)
                                        {
                                          showAlertDialog2(context);
                                        }
                                        else
                                        {
                                          int k = 0;
                                          int j = int.parse(myController.text);
                                          Firestore.instance.collection('Expense').where('Category', isEqualTo: '$s').where('UserId', isEqualTo: user1.uid).getDocuments().then((docsnap1){
                                            for(int i = 0; i < docsnap1.documents.length; i++)
                                            {
                                              j = j + int.parse(docsnap1.documents[i]['Value']);
                                            }
                                            var document = Firestore.instance.collection('Expense').document('$s1');
                                            document.get().then((docsnap2){
                                              k = int.parse(docsnap2.data['Value']);
                                              j = j - k;
                                              if(j > i)
                                              {
                                                showAlertDialog2(context);
                                              }
                                              else
                                              {
                                                print(selectedDate);
                                                print(_date);
                                                print('$convertedDate');
                                                if(_date.text == '$convertedDate')
                                                {
                                                  Databaseservice(uid: user1.uid).UpdateExpenseData("$s1","${myController.text}","${myController1.text}");
                                                }
                                                else
                                                {
                                                  Databaseservice(uid: user1.uid).UpdateExpenseDataWithDate("$s1","${myController.text}", selectedDate, "${myController1.text}");
                                                }
                                                myController.text = '';
                                                Navigator.pop(context);
                                              }
                                            });
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
                          showAlertDialog('$s1',context);
                        },
                      ),
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
