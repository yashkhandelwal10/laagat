// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:laagat/firebase_options.dart';
// import 'package:laagat/pages/login_pages/login_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       name: 'Laagat.com', options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: LoginPage());
//   }
// }

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:laagat/home/home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'OTP Verification',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FutureBuilder(
//         future: FirebaseAuth.instance.authStateChanges().first,
//         builder: (context, AsyncSnapshot<User?> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//           if (snapshot.hasData) {
//             return HomeScreen(user: snapshot.data!);
//           }
//           return OTPScreen();
//         },
//       ),
//     );
//   }
// }

// class OTPScreen extends StatefulWidget {
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _otpController = TextEditingController();
//   TextEditingController _nameController = TextEditingController();

//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String _verificationId = '';

// Future<void> verifyPhone() async {
//   try {
//     PhoneVerificationCompleted verificationCompleted =
//         (PhoneAuthCredential phoneAuthCredential) async {
//       await _auth.signInWithCredential(phoneAuthCredential);
//       // Handle auto-verification
//     };

//     PhoneVerificationFailed verificationFailed =
//         (FirebaseAuthException authException) {
//       print('Error: ${authException.message}');
//     };

//     PhoneCodeSent codeSent =
//         (String verificationId, [int? forceResendingToken]) async {
//       _verificationId = verificationId;
//       // Navigate to OTP input screen
//     };

//     PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//         (String verificationId) {
//       _verificationId = verificationId;
//     };

//     await _auth.verifyPhoneNumber(
//       phoneNumber: '+91${_phoneNumberController.text}',
//       verificationCompleted: verificationCompleted,
//       verificationFailed: verificationFailed,
//       codeSent: codeSent,
//       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//     );
//   } catch (e) {
//     print('Error: $e');
//   }
// }

// void signInWithOTP() async {
//   try {
//     AuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId,
//       smsCode: _otpController.text,
//     );

//     await _auth.signInWithCredential(credential);

//     // Save user data to Firestore
//     await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
//       'name': _nameController.text,
//       'phoneNumber': _phoneNumberController.text,
//     });

//     // Update user's display name
//     await _auth.currentUser!.updateProfile(displayName: _nameController.text);

//     // Navigate to HomeScreen upon successful verification
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) => HomeScreen(user: _auth.currentUser!)),
//     );
//   } catch (e) {
//     print('Error: $e');
//   }
// }

//   // void signInWithOTP() async {
//   //   try {
//   //     AuthCredential credential = PhoneAuthProvider.credential(
//   //       verificationId: _verificationId,
//   //       smsCode: _otpController.text,
//   //     );

//   //     await _auth.signInWithCredential(credential);

//   //     // Save user data to Firestore
//   //     await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
//   //       'name': _nameController.text,
//   //       'phoneNumber': _phoneNumberController.text,
//   //     });

//   //     // Navigate to HomeScreen upon successful verification
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(
//   //           builder: (context) => HomeScreen(user: _auth.currentUser!)),
//   //     );
//   //   } catch (e) {
//   //     print('Error: $e');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Laagat.com'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 hintText: 'Enter your name',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _phoneNumberController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 hintText: 'Enter your phone number (+91)',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: verifyPhone,
//               child: Text('Get OTP'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Enter OTP',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: signInWithOTP,
//               child: Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laagat/home/home_screen.dart';
import 'package:laagat/otp/otp_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OTP Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CheckAuthentication()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_img.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CheckAuthentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return HomeScreen(user: snapshot.data!);
        }
        return OTPScreen();
      },
    );
  }
}

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  BuildContext? _bottomSheetContext;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _verificationId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showModalBottomSheet(
        isScrollControlled: true,
        // enableDrag: true,

        backgroundColor: Colors.black,
        context: context,
        builder: (BuildContext context) {
          _bottomSheetContext = context;
          return SingleChildScrollView(
            child: Padding(
                // padding:
                //     EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
                padding: MediaQuery.of(context).viewInsets,
                child: buildBottomSheetContent()),
          );
          // return buildBottomSheetContent();
        },
      );
    });
  }

  Widget buildTextFieldWithIcon({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        // border: Border.all(color: Color(0XFF8EDB05)),
        border: Border.all(color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            // color: Color(0XFF8EDB05),
            color: Colors.grey.shade600,
            size: 15,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                // hintStyle: TextStyle(color: Color(0XFF8EDB05)),
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 17),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomSheetContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Sign-In",
            style: TextStyle(
              color: Color(0XFF8EDB05),
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Name",
              style: TextStyle(
                color: Color(0XFF8EDB05),
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          buildTextFieldWithIcon(
            controller: _nameController,
            hintText: 'Enter Name',
            icon: Icons.person,
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Phone Number",
              style: TextStyle(
                color: Color(0XFF8EDB05),
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          buildTextFieldWithIcon(
            controller: _phoneNumberController,
            hintText: '+91 -',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            // style: ButtonStyle(backgroundColor: Color(0XFF8EDB05)),
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
            // onPressed: verifyPhone,
            onPressed: sendOTPAndNavigate,

            child: Text(
              'Get Started',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 15.0),
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Color(0XFF8EDB05)),
          //     borderRadius: BorderRadius.circular(10.0),
          //   ),
          //   child: TextField(
          //     controller: _otpController,
          //     keyboardType: TextInputType.number,
          //     decoration: InputDecoration(
          //       hintText: 'Enter OTP',
          //       border: InputBorder.none,
          //     ),
          //   ),
          // ),
          // SizedBox(height: 16.0),
          // ElevatedButton(
          //   onPressed: signInWithOTP,
          //   child: Text('Verify OTP'),
          // ),
        ],
      ),
    );
  }

  void sendOTPAndNavigate() async {
    try {
      PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
        // Handle auto-verification if needed
      };

      PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException authException) {
        print('Error: ${authException.message}');
      };

      PhoneCodeSent codeSent =
          (String verificationId, [int? forceResendingToken]) async {
        _verificationId = verificationId;
        // Navigate to OTP input screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OTPVerificationScreen(verificationId: _verificationId),
          ),
        );
      };

      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
      };

      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      if (_bottomSheetContext != null) {
        ScaffoldMessenger.of(_bottomSheetContext!).showSnackBar(
          SnackBar(content: Text('Phone verification started')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> verifyPhone() async {
    try {
      PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
        // Handle auto-verification
      };

      PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException authException) {
        print('Error: ${authException.message}');
      };

      PhoneCodeSent codeSent =
          (String verificationId, [int? forceResendingToken]) async {
        _verificationId = verificationId;
        // Navigate to OTP input screen
      };

      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
      };

      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      if (_bottomSheetContext != null) {
        ScaffoldMessenger.of(_bottomSheetContext!).showSnackBar(
          SnackBar(content: Text('Phone verification started')),
        );
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OTPVerificationScreen(verificationId: _verificationId)),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void signInWithOTP() async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );

      await _auth.signInWithCredential(credential);

      // Save user data to Firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name': _nameController.text,
        'phoneNumber': _phoneNumberController.text,
      });

      // Update user's display name
      await _auth.currentUser!.updateDisplayName(_nameController.text);

      // Navigate to HomeScreen upon successful verification
      Navigator.pushReplacement(
        _bottomSheetContext!,
        MaterialPageRoute(
            builder: (context) => HomeScreen(user: _auth.currentUser!)),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title: Text('Laagat.com'),
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: Center(
          // child: Text('Xpensease',),
          child: Image.asset('assets/images/Logo.png'),
        ),
      ),
      // body: Center(
      //   child: CircularProgressIndicator(), // Placeholder widget
      // ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:laagat/home/home_screen.dart';
// import 'package:laagat/otp/otp_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'OTP Verification',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => CheckAuthentication()),
//       );
//     });

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/splash_img.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CheckAuthentication extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (snapshot.hasData) {
//           return HomeScreen(user: snapshot.data!);
//         }
//         return OTPScreen();
//       },
//     );
//   }
// }

// class OTPScreen extends StatefulWidget {
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _otpController = TextEditingController();
//   TextEditingController _nameController = TextEditingController();

//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String _verificationId = '';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       showModalBottomSheet(
//         isScrollControlled: true,
//         backgroundColor: Colors.black,
//         context: context,
//         builder: (BuildContext context) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: MediaQuery.of(context).viewInsets,
//               child: buildBottomSheetContent(),
//             ),
//           );
//         },
//       );
//     });
//   }

//   Widget buildBottomSheetContent() {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
          // Text(
          //   "Sign-In",
          //   style: TextStyle(
          //     color: Color(0XFF8EDB05),
          //     fontSize: 20,
          //   ),
          // ),
          // SizedBox(height: 16.0),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Text(
          //     "Name",
          //     style: TextStyle(
          //       color: Color(0XFF8EDB05),
          //       fontSize: 10,
          //     ),
          //   ),
          // ),
          // SizedBox(height: 5.0),
          // buildTextFieldWithIcon(
          //   controller: _nameController,
          //   hintText: 'Enter Name',
          //   icon: Icons.person,
          // ),
          // SizedBox(height: 16.0),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Text(
          //     "Phone Number",
          //     style: TextStyle(
          //       color: Color(0XFF8EDB05),
          //       fontSize: 10,
          //     ),
          //   ),
          // ),
          // SizedBox(height: 5.0),
          // buildTextFieldWithIcon(
          //   controller: _phoneNumberController,
          //   hintText: '+91 -',
          //   icon: Icons.phone,
          //   keyboardType: TextInputType.phone,
          // ),
          // SizedBox(height: 16.0),
          // ElevatedButton(
          //   // style: ButtonStyle(backgroundColor: Color(0XFF8EDB05)),
          //   style: ElevatedButton.styleFrom(
          //     foregroundColor: Colors.white,
          //     backgroundColor: Color(0XFF8EDB05), // Text color
          //     padding: EdgeInsets.symmetric(
          //         vertical: 15.0, horizontal: 120), // Button padding
          //     shape: RoundedRectangleBorder(
          //       borderRadius:
          //           BorderRadius.circular(20.0), // Button border radius
          //     ),
          //     elevation: 5, // Button elevation
          //   ),
          //   onPressed: verifyPhone,

          //   child: Text(
          //     'Get Started',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
//           SizedBox(height: 16.0),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 15.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Color(0XFF8EDB05)),
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Enter OTP',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: signInWithOTP,
//             child: Text('Verify OTP'),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }

  // Widget buildTextFieldWithIcon({
  //   required TextEditingController controller,
  //   required String hintText,
  //   required IconData icon,
  //   TextInputType? keyboardType,
  // }) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 15.0),
  //     decoration: BoxDecoration(
  //       // border: Border.all(color: Color(0XFF8EDB05)),
  //       border: Border.all(color: Colors.grey.shade600),
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(
  //           icon,
  //           // color: Color(0XFF8EDB05),
  //           color: Colors.grey.shade600,
  //           size: 15,
  //         ),
  //         SizedBox(width: 10),
  //         Expanded(
  //           child: TextField(
  //             controller: controller,
  //             keyboardType: keyboardType,
  //             decoration: InputDecoration(
  //               hintText: hintText,
  //               // hintStyle: TextStyle(color: Color(0XFF8EDB05)),
  //               hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 17),
  //               border: InputBorder.none,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

//   Future<void> verifyPhone() async {
//     try {
//       PhoneVerificationCompleted verificationCompleted =
//           (PhoneAuthCredential phoneAuthCredential) async {
//         await _auth.signInWithCredential(phoneAuthCredential);
//         // Handle auto-verification
//       };

//       PhoneVerificationFailed verificationFailed =
//           (FirebaseAuthException authException) {
//         print('Error: ${authException.message}');
//       };

//       PhoneCodeSent codeSent =
//           (String verificationId, [int? forceResendingToken]) async {
//         _verificationId = verificationId;
//         // Navigate to OTP input screen
//       };

//       PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//           (String verificationId) {
//         _verificationId = verificationId;
//       };
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => OTPPage()), // Navigate to SecondScreen
//       );

//       await _auth.verifyPhoneNumber(
//         phoneNumber: '+91${_phoneNumberController.text}',
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//       );
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

  // void signInWithOTP() async {
  //   try {
  //     AuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId,
  //       smsCode: _otpController.text,
  //     );

  //     await _auth.signInWithCredential(credential);

  //     // Save user data to Firestore
  //     await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
  //       'name': _nameController.text,
  //       'phoneNumber': _phoneNumberController.text,
  //     });

  //     // Update user's display name
  //     await _auth.currentUser!.updateProfile(displayName: _nameController.text);

  //     // Navigate to HomeScreen upon successful verification
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => HomeScreen(user: _auth.currentUser!)),
  //     );
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: Icon(
//           Icons.arrow_back,
//           color: Colors.white,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 100.0),
//         child: Center(
//           child: Image.asset('assets/images/Logo.png'),
//         ),
//       ),
//     );
//   }
// }

// class OTPPage extends StatefulWidget {
//   @override
//   _OTPPageState createState() => _OTPPageState();
// }

// class _OTPPageState extends State<OTPPage> {
//   TextEditingController _otpController = TextEditingController();
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Verification'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Enter OTP',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 16.0),
//             // TextField(
//             //   controller: _otpController,
//             //   keyboardType: TextInputType.number,
//             //   decoration: InputDecoration(
//             //     hintText: 'Enter OTP',
//             //   ),
//             // ),
//             // SizedBox(height: 16.0),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     // Implement OTP verification logic here
//             //     // For example, you can verify the OTP and navigate to the HomeScreen
//             //     Navigator.pushReplacement(
//             //       context,
//             //       MaterialPageRoute(
//             //           builder: (context) => HomeScreen(
//             //                 user: _auth.currentUser!,
//             //               )),
//             //     );
//             //   },
//             //   child: Text('Verify OTP'),
//             // ),
//             Container(
//             padding: EdgeInsets.symmetric(horizontal: 15.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Color(0XFF8EDB05)),
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Enter OTP',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: signInWithOTP,
//             child: Text('Verify OTP'),
//           ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:laagat/home/home_screen.dart';
// import 'package:laagat/otp/otp_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'OTP Verification',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => CheckAuthentication()),
//       );
//     });

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/splash_img.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CheckAuthentication extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (snapshot.hasData) {
//           return HomeScreen(user: snapshot.data!);
//         }
//         return OTPScreen();
//       },
//     );
//   }
// }

// class OTPScreen extends StatefulWidget {
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _nameController = TextEditingController();
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String _verificationId = '';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       showModalBottomSheet(
//         isScrollControlled: true,
//         backgroundColor: Colors.black,
//         context: context,
//         builder: (BuildContext context) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: MediaQuery.of(context).viewInsets,
//               child: buildBottomSheetContent(),
//             ),
//           );
//         },
//       );
//     });
//   }

//   Widget buildBottomSheetContent() {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             "Sign-In",
//             style: TextStyle(
//               color: Color(0XFF8EDB05),
//               fontSize: 20,
//             ),
//           ),
//           SizedBox(height: 16.0),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               "Name",
//               style: TextStyle(
//                 color: Color(0XFF8EDB05),
//                 fontSize: 10,
//               ),
//             ),
//           ),
//           SizedBox(height: 5.0),
//           buildTextFieldWithIcon(
//             controller: _nameController,
//             hintText: 'Enter Name',
//             icon: Icons.person,
//           ),
//           SizedBox(height: 16.0),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               "Phone Number",
//               style: TextStyle(
//                 color: Color(0XFF8EDB05),
//                 fontSize: 10,
//               ),
//             ),
//           ),
//           SizedBox(height: 5.0),
//           buildTextFieldWithIcon(
//             controller: _phoneNumberController,
//             hintText: '+91 -',
//             icon: Icons.phone,
//             keyboardType: TextInputType.phone,
//           ),
//           SizedBox(height: 16.0),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Color(0XFF8EDB05),
//               padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 120),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               elevation: 5,
//             ),
//             onPressed: verifyPhone,
//             child: Text(
//               'Get Started',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 10.0),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => OTPPage()),
//               );
//             },
//             child: Text('Verify OTP Separately'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildTextFieldWithIcon({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     TextInputType? keyboardType,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade600),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: Colors.grey.shade600,
//             size: 15,
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               keyboardType: keyboardType,
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 17),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> verifyPhone() async {
//     try {
//       PhoneVerificationCompleted verificationCompleted =
//           (PhoneAuthCredential phoneAuthCredential) async {
//         await _auth.signInWithCredential(phoneAuthCredential);
//         // Handle auto-verification
//       };

//       PhoneVerificationFailed verificationFailed =
//           (FirebaseAuthException authException) {
//         print('Error: ${authException.message}');
//       };

//       PhoneCodeSent codeSent =
//           (String verificationId, [int? forceResendingToken]) async {
//         _verificationId = verificationId;
//         // Navigate to OTP input screen
//       };

//       PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//           (String verificationId) {
//         _verificationId = verificationId;
//       };
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => OTPPage()), // Navigate to SecondScreen
//       );

//       await _auth.verifyPhoneNumber(
//         phoneNumber: '+91${_phoneNumberController.text}',
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//       );
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: Icon(
//           Icons.arrow_back,
//           color: Colors.white,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 100.0),
//         child: Center(
//           child: Image.asset('assets/images/Logo.png'),
//         ),
//       ),
//     );
//   }
// }
