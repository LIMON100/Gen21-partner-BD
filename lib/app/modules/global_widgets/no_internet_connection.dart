import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoInternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/img/no_signal.png"),
                SizedBox(height: 5,),
                Text("No Internet Connection!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),),
                SizedBox(height: 10,),
                GestureDetector(

                    child: Text("Please check your internet connection and reopen your app again!", textAlign: TextAlign.center, style: TextStyle( color: Colors.black, fontSize: 14))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
