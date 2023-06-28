import 'package:canteen_management_user/assistantMethods/assistant_methods.dart';
import 'package:canteen_management_user/models/items.dart';
import 'package:canteen_management_user/widgets/app_bar.dart';
import 'package:canteen_management_user/widgets/cart_item_design.dart';
import 'package:canteen_management_user/widgets/progress_bar.dart';
import 'package:canteen_management_user/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;
  CartScreen({this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<int>? separateItemQuantityList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    separateItemQuantityList= separateItemQuantities();
  }
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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "Total Amount = 120")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
            .collection("items")
            .where("itemID",whereIn: separateItemIDs())
                .orderBy("publishedDate",descending: true)
            .snapshots(),
            builder: (context,snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data!.docs.length==0
                  ? //startBuildingCart()
              Container()
                  : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Items model= Items.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                    );
                    return CartItemDesign(
                      model: model,
                      context: context,
                      quanNumber: separateItemQuantityList![index] ,
                    );
                  },
                  childCount: snapshot.hasData ? snapshot.data!.docs.length :0 )
              );
                  
            },
          )
          //display cart items with quantity
        ],
      ),

    );
  }
}
