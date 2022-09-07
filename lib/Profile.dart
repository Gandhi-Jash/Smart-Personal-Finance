import 'package:flutter/material.dart';
import 'package:smart_personal_finance/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final myController = TextEditingController();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        title: new Text('Update Password'),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text('Enter Password', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: new TextField(
              obscureText: true,
              decoration: new InputDecoration(
                  hintText: 'New Password'
              ),
              controller: myController1,
            ),
          ),
          SizedBox(height: 10.0,),
          Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text('Enter Password', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: new TextField(
              obscureText: true,
              controller: myController2,
            ),
          ),
          SizedBox(height: 5.0,),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: new RaisedButton(child: new Text('Save',style: new TextStyle(fontSize: 20.0),),
                color: Colors.orangeAccent,
                splashColor: Colors.black,
                onPressed: updatePassword ),
          )
        ],
      ),
    );
  }

  updatePassword()async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user1 = await _firebaseAuth.currentUser();
    if(myController1.text == "" || myController2.text == '')
      {
        showAlertDialog2(context);
      }
    else if(myController1.text != myController2.text)
      {
        showAlertDialog1(context);
      }
    else{
      user1.updatePassword(myController1.text);
      showAlertDialog(context);
    }

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
      content: Text("Passwords don't match"),
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
      content: Text("Password changed successfully"),
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
      content: Text("Password cannot be empty"),
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
}
