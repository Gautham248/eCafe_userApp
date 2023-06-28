import 'package:canteen_management_user/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;
  CartScreen({this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.sellerUID),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(onPressed: (){
                // clear cart function
            }, label:const Text("Clear Cart"),backgroundColor:Colors.cyan,
            icon: Icon(Icons.clear_all),),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(onPressed: (){
              //Checkout function

            }, label:const Text("Checkout"),backgroundColor:Colors.cyan,
              icon: Icon(Icons.navigate_next),),
          )
        ],
      ),
    );
  }
}
