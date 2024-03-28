// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:laagat/home/home_screen.dart';
// // import 'home_screen.dart';

// class OTPVerificationScreen extends StatefulWidget {
//   final String verificationId;

//   const OTPVerificationScreen({Key? key, required this.verificationId})
//       : super(key: key);

//   @override
//   _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
// }

// class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
//   TextEditingController _otpController = TextEditingController();
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;

//   void verifyOTPAndNavigate() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       AuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: _otpController.text,
//       );

//       // Sign in with the credential
//       await _auth.signInWithCredential(credential);

//       // OTP verification successful
//       // Proceed with your desired actions, such as navigating to the HomeScreen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomeScreen(user: _auth.currentUser!),
//         ),
//       );
//     } catch (e) {
//       // Handle OTP verification failure
//       print('Error verifying OTP: $e');
//       setState(() {
//         _isLoading = false;
//       });
//       // Show error message to the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error verifying OTP. Please try again.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Verification'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: _otpController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: 'Enter OTP',
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : verifyOTPAndNavigate,
//                 child: _isLoading
//                     ? CircularProgressIndicator()
//                     : Text('Verify OTP'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laagat/home/home_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;

  const OTPVerificationScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  List<TextEditingController> _otpControllers = [];
  List<FocusNode> _focusNodes = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _otpControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      if (i == 5) {
        _otpControllers[i].addListener(() {
          if (_otpControllers[i].text.isNotEmpty) {
            _focusNodes[i].unfocus();
            verifyOTPAndNavigate();
          }
        });
      } else {
        _otpControllers[i].addListener(() {
          if (_otpControllers[i].text.isNotEmpty) {
            _focusNodes[i].unfocus();
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          }
        });
      }
    }
  }

  void verifyOTPAndNavigate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String otp = '';
      for (TextEditingController controller in _otpControllers) {
        otp += controller.text;
      }

      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // Sign in with the credential
      await _auth.signInWithCredential(credential);

      // OTP verification successful
      // Proceed with your desired actions, such as navigating to the HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: _auth.currentUser!),
        ),
      );
    } catch (e) {
      // Handle OTP verification failure
      print('Error verifying OTP: $e');
      setState(() {
        _isLoading = false;
      });
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        // title: Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Icon.png'),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Text("Enter The OTP Code",style: TextStyle(color: Color(0xFF83E10B),fontSize: 22),),
              ), 
              Text("We've sent you an OTP Code",style: TextStyle(color:Colors.white,fontSize: 14),),
              SizedBox(height: 8,),
              Text("+91-852-7723-542",style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
              SizedBox(height: 35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 6; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 40,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor:Color(0xff83E10B),
                          controller: _otpControllers[i],
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                           
                          enabledBorder: const OutlineInputBorder(  
      borderSide: const BorderSide(color:Colors.grey, width: 1.0),
    ),
    border: const OutlineInputBorder(),
    labelStyle: new TextStyle(color: Colors.green),
    focusedBorder: OutlineInputBorder(
        // borderRadius: BorderRadius.circular(25.0),
        borderSide:  BorderSide(color:Color(0xff83E10B),width: 2),
      ),
                           
                           
                            counterText: '',
                            // border: OutlineInputBorder(),
                          ),
                          focusNode: _focusNodes[i],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0XFF8EDB05), // Text color
              padding: EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: 120), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0), // Button border radius
              ),
              elevation: 5, // Button elevation
                          ),
                onPressed: _isLoading ? null : verifyOTPAndNavigate,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Verify OTP'),
              ),
              SizedBox(height: 8,),
              Text("Resend Code",style: TextStyle(color: Colors.white,fontSize: 14, decoration: TextDecoration.underline,decorationColor: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (TextEditingController controller in _otpControllers) {
      controller.dispose();
    }
    for (FocusNode node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
