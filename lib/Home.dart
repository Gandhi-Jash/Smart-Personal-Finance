import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_personal_finance/Login.dart';
import 'package:smart_personal_finance/Budget.dart';
import 'package:smart_personal_finance/Expense.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smart_personal_finance/Profile.dart';

class User1{
  final String userid;
  final String useremail;
  User1(this.userid, this.useremail);
}

class SixMonthExpenses{
  final String  category;
  final int value;

  SixMonthExpenses(this.category, this.value);

  @override
  String toString(){
    return "{category: $category, value: $value, }";
  }
}


class HomePage extends StatefulWidget {

  final User user;
  HomePage({this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentDate = new DateTime.now().subtract(new Duration(days: 30));
  var prevDate = new DateTime.now().subtract(new Duration(days: 180));

  DateTime prevMonth;
  @override


  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffD3D3D3),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('${widget.user.useremail}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_balance),
                title: Text('Budget'),
                onTap: () async{
                  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                  FirebaseUser user = await _firebaseAuth.currentUser();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Budget(recordObject: new User1("${user.uid}","${user.email}"))));
                },
              ),
              ListTile(
                title: Text('Expense'),
                leading: Icon(Icons.attach_money),
                onTap: () async{
                  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                  FirebaseUser user = await _firebaseAuth.currentUser();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Expense(recordObject: new User1("${user.uid}","${user.email}"))));
                },
              ),
              ListTile(
                title: Text('Change Password'),
                leading: Icon(Icons.accessibility),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile()));
                },
              ),
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.phonelink_erase),
                onTap: (){
                  Navigator.pop(context,true);// It worked for me instead of above line
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()),);
                },
              ),
            ],
          ),
        ),
        appBar: new AppBar(
          title: new Text('Home'),

        ),
        body: Column(
          children: <Widget>[
            new SizedBox(
              height: 150.0,
              child: StreamBuilder(
                stream: Firestore.instance.collection('UserBalance').where('UserId', isEqualTo: '${widget.user.userid}').snapshots(),
                builder: (context, snapshots){
                  if(snapshots.hasData) {
                    return ListView.builder(
                        itemCount: snapshots.data.documents.length,
                        itemBuilder: (context,index){
                          print(currentDate);
                          DocumentSnapshot user = snapshots.data.documents[index];
                          return Card(
                              elevation: 5,
                              shape: Border(top: BorderSide(color: Colors.black, width: 5), bottom: BorderSide(color: Colors.black, width: 5)),
                              child: ListTile(
                                isThreeLine: true,
                                title: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Balance',
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),

                                  ],
                                ),
                                subtitle: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(''),
                                    Text('(Balance changes will be reflected on next login)', style: TextStyle(fontSize: 10.0, color: Colors.red),),
                                    Text(user.data['Balance'].toString(), style: TextStyle(fontSize: 20.0,),),
                                  ],
                                ),
                              )
                          );
                        });
                  }
                  return Container(width: 0.00, height: 0.00,);
                },
              ),
            ),
            new Flexible(
                child: StreamBuilder(
                  stream: Firestore.instance.collection('Expense').where('Date', isGreaterThanOrEqualTo: currentDate, isLessThanOrEqualTo: DateTime.now()).where('UserId', isEqualTo: widget.user.userid).snapshots(),
                  builder: (context,snapshots){
                    if(snapshots.data == null) return CircularProgressIndicator();
                    print(snapshots.data.documents.length);
                    int j = 0;
                    for (int i = 0; i < snapshots.data.documents.length; i++)
                    {
                      j = j + int.parse(snapshots.data.documents[i]['Value']);
                    }
                    print(j);
                    if(snapshots.hasData){
                      return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index){
                            return Card(
                                child: ListTile(
                                  isThreeLine: true,
                                  title: Text('Recent Expenses',
                                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                                  subtitle: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(''),
                                      Text('$j', style: TextStyle(fontSize: 20.0,),),
                                    ],
                                  ),
                                  onTap: (){
                                    Widget okButton = FlatButton(
                                      child: Text("OK", style: TextStyle(fontSize: 20.0,),),
                                      onPressed: () async{
                                        Navigator.pop(context);
                                      },
                                    );

                                    AlertDialog filter = AlertDialog(
                                      title: Text('Last Month Expenses'),
                                      content: new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Container(
                                              width: 300.0, height: 400.0,
                                              child: StreamBuilder(
                                                  stream: Firestore.instance.collection('Expense').where('Date', isGreaterThanOrEqualTo: currentDate, isLessThanOrEqualTo: DateTime.now()).where('UserId', isEqualTo: widget.user.userid).snapshots(),
                                                  builder: (context,snapshots){
                                                    if(snapshots.hasData)
                                                    {
                                                      return ListView.builder(
                                                          itemCount: snapshots.data.documents.length,
                                                          itemBuilder: (context, index){
                                                            DocumentSnapshot user = snapshots.data.documents[index];
                                                            return ListTile(
                                                              title: Text(user.data['Category']),
                                                              subtitle: Text(user.data['Value']),
                                                            );
                                                          }
                                                      );
                                                    }
                                                    return new Container(width: 0.00, height: 0.00,);
                                                  }
                                              )
                                          )
                                        ],
                                      ),
                                      actions: [
                                        okButton,
                                      ],
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return filter;
                                      },
                                    );
                                  },
                                )
                            );
                          }
                      );
                    }
                    return Container(height: 0.00, width: 0.00);
                  },
                )
            ),
            new Flexible(
                child: StreamBuilder(
              stream: Firestore.instance.collection('Expense').where('Date', isGreaterThanOrEqualTo: prevDate, isLessThanOrEqualTo: DateTime.now()).where('UserId', isEqualTo: widget.user.userid).snapshots(),
              builder: (context,snapshots){
                if(snapshots.data == null) return CircularProgressIndicator();
                var data = <SixMonthExpenses>[];
                var series;
                var chart;
                var chartwidget;
                int Household = 0;
                int Entertainment = 0;
                int Food = 0;
                int Other = 0;
                int Family = 0;
                int Health = 0;
                int Shopping = 0;
                for(int i = 0; i < snapshots.data.documents.length; i++)
                {
                  if(snapshots.data.documents[i]['Category'] == 'Household')
                    Household = Household + int.parse(snapshots.data.documents[i]['Value']);
                  else if(snapshots.data.documents[i]['Category'] == 'Entertainment')
                    Entertainment = Entertainment + int.parse(snapshots.data.documents[i]['Value']);
                  else if(snapshots.data.documents[i]['Category'] == 'Food')
                    Food = Food + int.parse(snapshots.data.documents[i]['Value']);
                  else if(snapshots.data.documents[i]['Category'] == 'Other')
                    Other = Other + int.parse(snapshots.data.documents[i]['Value']);
                  else if(snapshots.data.documents[i]['Category'] == 'Family')
                    Family = Family + int.parse(snapshots.data.documents[i]['Value']);
                  else if(snapshots.data.documents[i]['Category'] == 'Health')
                    Health = Health + int.parse(snapshots.data.documents[i]['Value']);
                  else if(snapshots.data.documents[i]['Category'] == 'Shopping')


                  data = [
                    SixMonthExpenses('Hhold', Household),
                    SixMonthExpenses('Enter', Entertainment),
                    SixMonthExpenses('Food', Food),
                    SixMonthExpenses('Other', Other),
                    SixMonthExpenses('Family', Family),
                    SixMonthExpenses('Health', Health),
                    SixMonthExpenses('Shopping', Shopping),
                  ];
                }
                series = [
                  charts.Series(
                    domainFn: (SixMonthExpenses SixMonthData, _) => SixMonthData.category,
                    measureFn: (SixMonthExpenses SixMonthData, _) => SixMonthData.value,
                    id: 'Value',
                    data: data,
                  ),
                ];

                chart = charts.BarChart(
                  series,
                  animate: true,
                );

                chartwidget = Padding(
                  padding: EdgeInsets.all(32.0),
                  child: SizedBox(
                    height: 200.0,
                    child: chart,
                  ),
                );
                if(snapshots.hasData)
                  return chartwidget;
                return Container(height: 0.00, width: 0.00);
              },
            )
            ),
          ],
        )
    );
  }
}
