
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String otpCredentialReceived ="set here";

  @override
  void initState() {
    super.initState();
    _webOtpListener();
  }

  void _webOtpListener(){
    String webOtp ="" ;
    html.window.addEventListener('receiveOTP', (html.Event event) {
      setState(() {
          webOtp = (event as html.CustomEvent).detail.toString();
          setState(() {
            otpCredentialReceived = webOtp;
          });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('Web OTP API Example'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(child: Text(otpCredentialReceived ,  style: TextStyle(color: Colors.white  ,fontSize: 25)),),
      ),
    );
  }




}

/********** info ********/

/**
 related code is in index.html to detect sms

    format of sms for android devices should be like this :

    Your OTP is: 123456.
    // space between //
    @baran-tst.bki.ir #123456


 **/

