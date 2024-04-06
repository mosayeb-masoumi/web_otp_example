
import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey webViewKey = GlobalKey();

  late WebViewXController webviewController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text('Web OTP API Examplee'),
      ),
      // body: buildInAppWebView(context),
      // body: buildWebViewXContainerForWeb(size),
      body: buildIframe(size),
      // body: Container(),
    );
  }

  Widget buildWebViewXContainerForWeb(Size size) {
    return WebViewX(
      key: const ValueKey('webviewx'),
      // initialContent: "https://jyotishman.github.io/webOTPAPI/",
      initialContent: "https://web-otp-demo.glitch.me/",
      initialSourceType: SourceType.url,
      javascriptMode: JavascriptMode.unrestricted,
      height: size.height,
      width: size.width,
      onWebViewCreated: (controller) => {
        webviewController = controller,
      },
      onPageStarted: (url) => {},
      onPageFinished: (src) =>
      {webviewController.evalRawJavascript(getOtpScript())},

      // jsContent: {
      //FIRST APPROACH
      // EmbeddedJsContent(mobileJs: '''
      //   alert('start.');
      //   console.log('Executing JavaScript code');
      //   if ('OTPCredential' in window) {
      //       alert('OTPCredential' in window.');
      //     const ac = new AbortController();
      //     navigator.credentials.get({
      //       otp: { transport:['sms'] },
      //       signal: ac.signal
      //     }).then(otp => {
      //       console.log(otp.code);
      //       alert(otp.code);
      //     }).catch(err => {
      //        console.log(err);
      //        alert('err')
      //     });
      //   } else {
      //     alert('WebOTP not supported!.');
      //   }
      // '''),

      // SECOND APPROACH
      //       EmbeddedJsContent(webJs: '''
      //         alert('start.');
      //         console.log('Executing JavaScript code');
      //         if ('OTPCredential' in window) {
      //             window.addEventListener('DOMContentLoaded', e => {
      //              alert('start listening.');
      //   const input = document.querySelector('input[autocomplete="one-time-code"]');
      //   if (!input) return;
      //   const ac = new AbortController();
      //   const form = input.closest('form');
      //   if (form) {
      //     form.addEventListener('submit', e => {
      //       ac.abort();
      //     });
      //   }
      //   navigator.credentials.get({
      //     otp: { transport:['sms'] },
      //     signal: ac.signal
      //   }).then(otp => {
      //     input.value = otp.code;
      //     alert(otp.code);
      //     if (form) form.submit();
      //   }).catch(err => {
      //     console.log(err);
      //      alert('err');
      //   });
      // });
      //       '''),
      //     },

      webSpecificParams: const WebSpecificParams(
        printDebugInfo: false,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
    );
  }



  Widget buildIframe(Size size) {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: '''
        <html>
        <body>
          <iframe src="https://web-otp-demo.glitch.me/" allow="otp-credentials" id="otp-iframe" width="100%" height="100%" frameborder="0"></iframe>
        </body>
        </html>
      ''',
      initialSourceType: SourceType.html,
      javascriptMode: JavascriptMode.unrestricted,
      height: size.height,
      width: size.width,
      onWebViewCreated: (controller) {
        webviewController = controller;
      },
      onPageFinished: (src) {
        // Inject the OTP detection script into the iframe
        webviewController.evalRawJavascript(getOtpScript());
      },
      onPageStarted: (url) {
        // Optionally, you can handle page start events here.
      },
      // javascriptChannels: {
      //   // Define a JavaScript channel for receiving OTP code from web page
      //   JavascriptChannel(
      //     name: 'OTPChannel',
      //     onMessageReceived: (message) {
      //       setState(() {
      //         _otpCode = message.message;
      //         // You can process the received OTP code here
      //         print('Received OTP: $_otpCode');
      //       });
      //     },
      //   ),
      // },
    );
  }



  //first approach
  // String getOtpScript() {
  //   return '''
  //     if ('OTPCredential' in window) {
  //       const ac = new AbortController();
  //       navigator.credentials.get({
  //         otp: { transport:['sms'] },
  //         signal: ac.signal
  //       }).then(otp => {
  //         alert(otp.code);
  //       }).catch(err => {
  //         alert('Error: ' + err);
  //       });
  //     } else {
  //       alert('WebOTP not supported!.');
  //     }
  //   ''';
  // }

  //second approach
  String getOtpScript() {
    return '''
     console.log("start"
      if ("OTPCredential" in window) {
          console.log("Credential is in window"
        window.addEventListener("DOMContentLoaded", (e) => {
          const input = document.querySelector('input[autocomplete="one-time-code"]');
            console.log("input called")
          if (!input) return;
            console.log("form called 2")
          const ac = new AbortController();
          const form = input.closest("form");
          if (form) {
             console.log("form called")
            form.addEventListener("submit", (e) => {
              ac.abort();
            });
          }
          navigator.credentials
            .get({
              otp: { transport: ["sms"] },
              signal: ac.signal,
            })
            .then((otp) => {
              console.log(otp.code)
              input.value = otp.code;
              if (form) form.submit();
            })
            .catch((err) => {
              console.error(err);
              console.log(err)
            });
        });
      }
    ''';
  }

//third approach
//   String getOtpScript() {
//     return '''
//     if ('OTPCredential' in window) {
//   window.addEventListener('DOMContentLoaded', e => {
//     const ac = new AbortController();
//     navigator.credentials.get({
//       otp: { transport:['sms'] },
//       signal: ac.signal
//     }).then(otp => {
//       alert(otp.code)
//     }).catch(err => {
//       console.log(err)
//     });
//   })
// } else {
//   alert('WebOTP not supported!.')
// }
//   ''';
//   }
}

