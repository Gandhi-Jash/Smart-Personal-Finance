import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_personal_finance/Home.dart';
import 'package:smart_personal_finance/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String userid;
  final String useremail;
  User(this.userid, this.useremail);
}



class Loginpage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => new _LoginPageState();

}
class _LoginPageState extends State<Loginpage>{

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;


  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }



  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: _email.toString().trim(), password: _password)).user;
        print('Signed in: ${user.uid}');

        int j = 0;
        int k = 0;
        Firestore.instance.collection('Expense').where('UserId', isEqualTo: user.uid).getDocuments().then((docsnap2){
          if(docsnap2.documents.length != 0)
            {
              for(int i = 0; i < docsnap2.documents.length; i++)
              {
                j = j + int.parse(docsnap2.documents[i]['Value']);
              }
              print(j);
              Firestore.instance.collection('UserBalance').where('UserId', isEqualTo: user.uid).getDocuments().then((docsnap1){
                k = docsnap1.documents[0]['StartBalance'] - j;
                print(k);
                Databaseservice(uid: user.uid).UpdateBalance(k);
              });
            }
          else{
            Firestore.instance.collection('UserBalance').where('UserId', isEqualTo: user.uid).getDocuments().then((docsnap1){
              k = docsnap1.documents[0]['StartBalance'];
              Databaseservice(uid: user.uid).UpdateBalance(k);
            });
          }


        });



        Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage(user : new User("${user.uid}","${user.email}"))));
      }
      catch (e) {
        formKey.currentState.reset();
        showAlertDialog(context);
        print('Error: $e');
      }
    }
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
      content: Text("Wrong username or password."),
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
      title: 'Login',
        theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        ),
        home: Scaffold(
          backgroundColor: Color(0xffF8F8F8),
          appBar: new AppBar(
            title: new Text('Login'),
          ),
          body: new Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 25.0),

            child: new Form(
                key: formKey,
                child:  new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/Login.png', scale: 2.0,),
                    SizedBox(height: 10,),
                    
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                      validator: (value) => value.isEmpty ? 'Email cant be empty' : null,
                      onSaved: (value) => _email = value,
                    ),
                    SizedBox(height: 5.0,),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) => value.isEmpty ? 'password cant be empty' : null,
                      onSaved: (value) => _password = value,
                      obscureText: true,
                    ),
                    SizedBox(height: 10.0,),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: double.infinity),
                      child: new RaisedButton(child: new Text('Login',style: new TextStyle(fontSize: 20.0),),
                        color: Colors.orangeAccent,
                        splashColor: Colors.lightGreen,
                        onPressed: validateAndSubmit,),
                    ),
                    SizedBox(height: 5.0,),
                    new InkWell(
                    child: new Text('Forgot Password', style: TextStyle(color: Colors.red)),
                        onTap: () async {


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
                              await _firebaseAuth.sendPasswordResetEmail(email: user1.email);
                            },
                          );
                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title:  Text("Reset"),
                            content: Text("Send Email to registered email for password reset?"),
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
                    ),
                  ],
                )),
          ),
        )
    );
  }
}









