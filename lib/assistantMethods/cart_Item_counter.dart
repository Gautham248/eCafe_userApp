import 'package:flutter/cupertino.dart';
import 'package:canteen_management_user/global/global.dart';

class CartItemCounter extends ChangeNotifier
{
  int cartListItemCounter = sharedPreferences!.getStringList("userCart")!.length - 1;//variable holding the total number of items in the cart
  int get count => cartListItemCounter;

  Future<void> displayCartListItemsNumber() async
  {
    //function gets the number of items in cart in real time
    //Number of items increase as the user adds more items to the cart
    cartListItemCounter = sharedPreferences!.getStringList("userCart")!.length - 1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}