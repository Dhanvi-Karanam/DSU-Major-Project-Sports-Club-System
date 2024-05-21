import 'package:flutter/material.dart';
import 'dart:async';
import 'clubdetails.dart';
import 'package:upi_india/upi_india.dart';

class PaymentScreen extends StatefulWidget {
  List<ExtraItems> bilingitems;

  PaymentScreen(this.bilingitems);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  num total = 0;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  UpiApp app = UpiApp.googlePay;
  @override
  void initState() {
    // TODO: implement initState
    // _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
    //   setState(() {
    //     apps = value;
    //   });
    // }).catchError((e) {
    //   apps = [];
    // });
    for(int i=0;i<widget.bilingitems.length;i++){

    setState(() {
      total = total+double.parse(widget.bilingitems[i].price);
    });
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Order Summary',style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(30),
          child: ListView.separated(
            itemCount: widget.bilingitems.length,
            itemBuilder: (BuildContext context,int index){
              return Padding(
                padding: const EdgeInsets.only(top:18.0),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.bilingitems[index].name}'),
                      Text('Rs.${widget.bilingitems[index].price}')
                    ],
                  ),

                ),
              );
            },
            separatorBuilder:(BuildContext context,int index){
              return Padding(
                padding: const EdgeInsets.only(top:28.0),
                child: Divider(thickness: 1,),
              );
            }

          ),
        ),
      ),

      bottomNavigationBar: Container(
        child: ElevatedButton(
          child: Text('Proceed to pay Rs ${total}'),
          onPressed: (){
            initiateTransaction(app);
            print('opening google pay');
          },
        ),
      ),
    );
  }


    FutureOr<UpiResponse> initiateTransaction(UpiApp app) async {
      return _upiIndia.startTransaction(
        app: app,
        receiverUpiId: "truekriti-1@okicici",
        receiverName: 'Kriti Sharma',
        transactionRefId: 'testingupi',
        transactionNote: 'Not actual. Just an example.',
        amount: 1.00,
      );

  }
}
