import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_finance/Expense.dart';


class Databaseservice {

  final String uid;

  Databaseservice({this.uid});

  String i = '';


  final CollectionReference budget = Firestore.instance.collection('budget');
  final CollectionReference balance = Firestore.instance.collection('UserBalance');
  final CollectionReference expense = Firestore.instance.collection('Expense');

  Future UpdateBudgetData(String Category, String value) async {
    return budget.document().setData({
      'UserId': uid,
      'Category': Category,
      'value': value,
    });
  }

  Future AddBudgetData(String Index, String value) async {
    return await budget.document(Index).updateData({
      'value': value
    });
  }

  Future DeleteDocument(String Index) async {
    return budget.document(Index).delete();
  }

/* Expense */

  Future AddExpenseData(String Category,String TransactionType, String Value, DateTime dt, String Remark ) async {
    return expense.document().setData({
      'UserId': uid,
      'Category': Category,
      'TransactionType' : TransactionType,
      'Value': Value,
      'Date' : dt,
      'Remark' : Remark,
    });
  }

  Future UpdateExpenseData(String Index, String Value, String Remark) async {
    return await expense.document(Index).updateData({
        'Value': Value,
        'Remark': Remark,
    });
  }


  Future UpdateExpenseDataWithDate(String Index, String Value, DateTime dt, String Remark) async {
    return await expense.document(Index).updateData({
      'Date' : dt,
      'Value': Value,
      'Remark': Remark,
    });
  }

  Future DeleteExpenseData(String Index) async {
    return expense.document(Index).delete();
  }

  Future UpdateBalance(int Index) async {
    final docref = await Firestore.instance.collection('UserBalance').where('UserId', isEqualTo: '$uid').getDocuments();
    return balance.document(docref.documents[0].documentID).updateData({
      'Balance': Index,
    });
  }

}
