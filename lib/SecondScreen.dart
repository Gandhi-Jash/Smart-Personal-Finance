import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_personal_finance/Login.dart';
import 'package:smart_personal_finance/Budget.dart';
import 'package:smart_personal_finance/Expense.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class SixMonthExpenses{
  final String  category;
  final int value;

  SixMonthExpenses(this.category, this.value);

  @override
  String toString(){
    return "{category: $category, value: $value, }";
  }
}

class SecondScreen extends StatelessWidget{
  @override

  final User user;
  var currentDate = new DateTime.now().subtract(new Duration(days: 30));
  var prevDate = new DateTime.now().subtract(new Duration(days: 180));
  var chartWidget;

  DateTime prevMonth;
  SecondScreen({this.user});
  @override


  prevSixMonths(){
    var data = <SixMonthExpenses>[];
    int Household = 0;
    int Entertainment = 0;
    int Food = 0;
    int Other = 0;
    int Family = 0;
    int Health = 0;
    int Shopping = 0;
    Firestore.instance.collection('Expense').where('Date', isGreaterThanOrEqualTo: prevDate, isLessThanOrEqualTo: DateTime.now()).getDocuments().then((docsnap){
      for(int i = 0; i < docsnap.documents.length; i++)
      {
        print(docsnap.documents[i]['Category']);
        if(docsnap.documents[i]['Category'] == 'Household')
          Household = Household + int.parse(docsnap.documents[i]['Value']);
        else if(docsnap.documents[i]['Category'] == 'Entertainment')
          Entertainment = Entertainment + int.parse(docsnap.documents[i]['Value']);
        else if(docsnap.documents[i]['Category'] == 'Food')
          Food = Food + int.parse(docsnap.documents[i]['Value']);
        else if(docsnap.documents[i]['Category'] == 'Other')
          Other = Other + int.parse(docsnap.documents[i]['Value']);
        else if(docsnap.documents[i]['Category'] == 'Family')
          Family = Family + int.parse(docsnap.documents[i]['Value']);
        else if(docsnap.documents[i]['Category'] == 'Health')
          Health = Health + int.parse(docsnap.documents[i]['Value']);
        else if(docsnap.documents[i]['Category'] == 'Shopping')
          Shopping = Shopping + int.parse(docsnap.documents[i]['Value']);


        data = [
          SixMonthExpenses('Household', Household),
          SixMonthExpenses('Entertainment', Entertainment),
          SixMonthExpenses('Food', Food),
          SixMonthExpenses('Other', Other),
          SixMonthExpenses('Family', Family),
          SixMonthExpenses('Health', Health),
          SixMonthExpenses('Shopping', Shopping),
        ];
      }

      var series = [
        charts.Series(
          domainFn: (SixMonthExpenses SixMonthData, _) => SixMonthData.category,
          measureFn: (SixMonthExpenses SixMonthData, _) => SixMonthData.value,
          id: 'Value',
          data: data,
        ),
      ];

      var chart = charts.BarChart(
        series,
        animate: true,
      );

      var chartWidget = Padding(
        padding: EdgeInsets.all(32.0),
        child: SizedBox(
          height: 200.0,
          child: chart,
        ),
      );
      print(chartWidget);
      return chartWidget;
    });
  }




  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('${user.useremail}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                trailing: Icon(Icons.account_balance),
                title: Text('Budget'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Budget()));
                  },
              ),
              ListTile(
                title: Text('Expense'),
                trailing: Icon(Icons.attach_money),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Expense()));
                },
              )
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
                stream: Firestore.instance.collection('UserBalance').where('UserId', isEqualTo: '${user.userid}').snapshots(),
                builder: (context, snapshots){
                  if(snapshots.hasData) {
                    return ListView.builder(
                        itemCount: snapshots.data.documents.length,
                        itemBuilder: (context,index){
                          print(currentDate);
                          DocumentSnapshot user = snapshots.data.documents[index];
                          return Card(
                              elevation: 5,
                              shape: Border(top: BorderSide(color: Colors.green, width: 5), bottom: BorderSide(color: Colors.green, width: 5)),
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
                  stream: Firestore.instance.collection('Expense').where('Date', isGreaterThanOrEqualTo: currentDate, isLessThanOrEqualTo: DateTime.now()).snapshots(),
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
                                  title: Text('Previous month spendings',
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
                                              width: 300.0, height: 300.0,
                                              child: StreamBuilder(
                                                  stream: Firestore.instance.collection('Expense').where('Date', isGreaterThanOrEqualTo: currentDate, isLessThanOrEqualTo: DateTime.now()).snapshots(),
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
          ],
        )
    );
  }
}
