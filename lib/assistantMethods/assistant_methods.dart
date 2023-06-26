import 'package:canteen_management_user/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

addItemToCart(String? foodItemId, BuildContext context, int itemCounter)
{
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add(foodItemId! + ":$itemCounter"); //56557657:7

  FirebaseFirestore.instance.collection("users")
      .doc(firebaseAuth.currentUser!.uid).update({
    "userCart": tempList,
  }).then((value)
      {

        Fluttertoast.showToast(msg: "Item added successfully");
        sharedPreferences!.setStringList("userCart", tempList);
      });

}