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
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 6; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _otpControllers[i],
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                          focusNode: _focusNodes[i],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : verifyOTPAndNavigate,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Verify OTP'),
              ),
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
