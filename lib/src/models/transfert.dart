import 'package:payut/src/models/user.dart';

class Transfert{
  late final int _amount;
  late final String message;
  late final User target;
  Transfert.makeTransfert(this.target,double amount,[String? message]){
    this.message = message??"";
    _amount = (amount * 100).floor();
  }
  double get amount => _amount/100;
  toJson()=>{
    "amount": _amount,
    "message": message,
    "userID": target.id
  };
}