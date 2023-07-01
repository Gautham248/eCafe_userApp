import 'package:canteen_management_user/assistantMethods/assistant_methods.dart';
import 'package:canteen_management_user/global/global.dart';
import 'package:canteen_management_user/mainScreens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class PlacedOrderScreen extends StatefulWidget {


  final double? totalAmount;
  final String? sellerUID;


  PlacedOrderScreen({this.totalAmount, this.sellerUID});


  @override
  _PlacedOrderScreenState createState() => _PlacedOrderScreenState();
}


class _PlacedOrderScreenState extends State<PlacedOrderScreen>
{
  late  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    // You can navigate to a success screen or perform other actions
    print('Payment Successful. Payment ID: ${response.paymentId}');
    addOrderDetails();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    // You can display an error message or perform other actions
    print('Payment Error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    // You can handle external wallet payments here if supported by Razorpay
    print('External Wallet: ${response.walletName}');
  }

  void _startPayment() {

    double? price;
    price= widget.totalAmount;

    var options = {

      'key': 'rzp_test_e1MSDntuNxB0RH',
      'amount': price! * 100, // amount in paise (Example: 1INR = 100 paise)
      'name': 'e-Cafe',
      'description': 'order payment',
      'prefill': {'contact': '9876543210', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm', 'googlepay']
      }
    };

    try {
      _razorpay.open(options as Map<String, dynamic>);
    } catch (e) {
      print("Error: $e");
    }
  }
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails()
  {
    writeOrderDetailsForUser({
      // "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Paid",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "placed",//normal
      "orderId": orderId,
    });

    writeOrderDetailsForSeller({
      // "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Paid",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "placed",//normal
      "orderId": orderId,
    }).whenComplete((){
      clearCartNow(context);
      setState(() {
        orderId="";
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        Fluttertoast.showToast(msg: "Congratulations, Order has been placed successfully.");
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset("images/delivery.jpg"),

            const SizedBox(height: 12,),

            ElevatedButton(
              child: const Text("Place Order"),
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
              ),
              onPressed: ()
              {
                _startPayment();
                // addOrderDetails();
              },
            ),

          ],
        ),
      ),
    );
  }
}
