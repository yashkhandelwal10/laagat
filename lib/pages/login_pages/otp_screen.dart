import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'A one-time password (OTP) has been sent to your registered mobile number.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => buildOtpDigitField(context, index),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Implement OTP verification logic here
              },
              child: Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Implement resend OTP logic here
              },
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOtpDigitField(BuildContext context, int index) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: '*',
          hintStyle: TextStyle(fontSize: 20),
        ),
        onChanged: (value) {
          // Automatically move focus to the next input field when a digit is entered
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SmsMessage {
//   final String sender;
//   final String originalBody;
//   final String trimmedBody;
//   final DateTime date;

//   SmsMessage({
//     required this.sender,
//     required this.originalBody,
//     required this.trimmedBody,
//     required this.date,
//   });
// }

// class SMSScreen extends StatefulWidget {
//   SMSScreen({Key? key, required this.user}) : super(key: key);
//   final User user;

//   @override
//   State<SMSScreen> createState() => _SMSScreenState();
// }

// class _SMSScreenState extends State<SMSScreen> {
//   List<SmsMessage> _messages = [];
//   bool _savingInProgress = false;
//   bool _fetchingData = false;
  // List<String> sentTxn = [
  //   'sent',
  //   'debit',
  //   'debited',
  //   'purchase',
  //   'deducted',
  //   'spent',
  //   'paid'
  // ];
  // List<String> receivedTxn = ['received', 'credited'];

//   Color determineColor(String body) {
//     if (containsAnyKeyword(body, sentTxn)) {
//       return Colors.red;
//     } else if (containsAnyKeyword(body, receivedTxn)) {
//       return Colors.green;
//     } else {
//       return Colors.black;
//     }
//   }

//   bool containsAnyKeyword(String text, List<String> keywords) {
//     for (String keyword in keywords) {
//       if (text.toLowerCase().contains(keyword.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

  // String trimBody(String body) {
  //   String trimmedBody = '';
  //   int rsIndex = body.toLowerCase().indexOf(' rs. ');
  //   int rs1Index = body.toLowerCase().indexOf(' rs ');
  //   int inrIndex = body.toLowerCase().indexOf(' inr ');
  //   int byIndex = body.toLowerCase().indexOf(' debited by ');
  //   int creditedIndex = body.toLowerCase().indexOf(' credited with rs');
  //   int forIndex = body.toLowerCase().indexOf(' debited for rs ');

  //   if (rsIndex != -1) {
  //     int endIndex = body.indexOf(' ', rsIndex + 5);
  //     trimmedBody =
  //         body.substring(rsIndex + 5, endIndex != -1 ? endIndex : body.length);
  //   } else if (rs1Index != -1) {
  //     int endIndex = body.indexOf(' ', rs1Index + 4);
  //     trimmedBody =
  //         body.substring(rs1Index + 4, endIndex != -1 ? endIndex : body.length);
  //   } else if (inrIndex != -1) {
  //     int endIndex = body.indexOf(' ', inrIndex + 5);
  //     trimmedBody =
  //         body.substring(inrIndex + 5, endIndex != -1 ? endIndex : body.length);
  //   } else if (byIndex != -1) {
  //     int endIndex = body.indexOf(' ', byIndex + 12);
  //     trimmedBody =
  //         body.substring(byIndex + 12, endIndex != -1 ? endIndex : body.length);
  //   } else if (creditedIndex != -1) {
  //     int endIndex = body.indexOf(' ', creditedIndex + 17);
  //     trimmedBody = body.substring(
  //         creditedIndex + 17, endIndex != -1 ? endIndex : body.length);
  //   } else if (forIndex != -1) {
  //     int endIndex = body.indexOf(' ', forIndex + 16);
  //     trimmedBody = body.substring(
  //         forIndex + 16, endIndex != -1 ? endIndex : body.length);
  //   }
  //   return trimmedBody.trim();
  // }

//   Future<void> _fetchData() async {
//     setState(() {
//       _fetchingData = true;
//     });

//     try {
//       final phoneNumber = widget.user.phoneNumber ?? '';
//       CollectionReference userCollection =
//           FirebaseFirestore.instance.collection('users');

//       DocumentSnapshot userDocument =
//           await userCollection.doc(phoneNumber).get();
//       if (!userDocument.exists) {
//         print('User document not found for phone number: $phoneNumber');
//         return;
//       }

//       CollectionReference smsCollection =
//           userDocument.reference.collection('SMS_Details');

//       QuerySnapshot smsSnapshot =
//           await smsCollection.orderBy('date', descending: true).get();

//       List<SmsMessage> messages = [];

//       smsSnapshot.docs.forEach((smsDoc) {
//         String sender = smsDoc['sender'];
//         Timestamp timestamp = smsDoc['date'];
//         String originalBody = smsDoc['body'];
//         String trimmedBody = trimBody(originalBody);

//         if (trimmedBody.isNotEmpty) {
//           // Check if the SMS body contains any keywords from sentTxn or receivedTxn
//           if (containsAnyKeyword(originalBody, sentTxn) ||
//               containsAnyKeyword(originalBody, receivedTxn)) {
//             messages.add(
//               SmsMessage(
//                 sender: sender,
//                 originalBody: originalBody,
//                 trimmedBody: trimmedBody,
//                 date: timestamp.toDate(),
//               ),
//             );
//           }
//         }
//       });

//       setState(() {
//         _messages = messages;
//         _fetchingData = false;
//       });
//     } catch (error) {
//       print('Error fetching data: $error');
//       setState(() {
//         _fetchingData = false;
//       });
//     }
//   }

  // Future<void> _saveSMSToFirestore() async {
  //   setState(() {
  //     _savingInProgress = true;
  //   });

  //   CollectionReference userCollection =
  //       FirebaseFirestore.instance.collection('users');
  //   final phoneNumber = widget.user.phoneNumber ?? '';
  //   final name = widget.user.displayName ?? '';

  //   CollectionReference smsCollection =
  //       userCollection.doc(phoneNumber).collection('SMS_Details');

  //   for (SmsMessage message in _messages) {
  //     Timestamp timestamp = Timestamp.fromDate(message.date);

  //     await smsCollection.add({
  //       'name': name,
  //       'phoneNumber': phoneNumber,
  //       'SMS': {
  //         'sender': message.sender,
  //         'date': timestamp,
  //         'originalBody': message.originalBody,
  //         'trimmedBody': message.trimmedBody,
  //       },
  //     });
  //   }

//     setState(() {
//       _savingInProgress = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('All SMS data saved to Firestore'),
//       ),
//     );
//   }

//   Future<void> _checkAndRequestSMSPermission() async {
//     var status = await Permission.sms.status;
//     if (status.isDenied) {
//       await Permission.sms.request();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SMS Inbox Example'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.upload),
//             onPressed: _savingInProgress ? null : _saveSMSToFirestore,
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _fetchingData ? null : _fetchData,
//           ),
//         ],
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: _savingInProgress || _fetchingData,
//         child: Container(
//           padding: const EdgeInsets.all(10.0),
//           child: _messages.isNotEmpty
//               ? ListView.builder(
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     SmsMessage message = _messages[index];
//                     return ListTile(
//                       title: Text(
//                         'Trimmed Body: ${message.trimmedBody}',
//                         style: TextStyle(
//                             color: determineColor(message.originalBody)),
//                       ),
//                       subtitle: Text(
//                         'From: ${message.sender}\nDate: ${DateFormat('yyyy-MM-dd – kk:mm').format(message.date)}',
//                       ),
//                     );
//                   },
//                 )
//               : Center(
//                   child: Text(
//                     'No messages to show.\nTap "Fetch Data" button to load messages.',
//                     style: Theme.of(context).textTheme.subtitle1,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _checkAndRequestSMSPermission,
//         child: Icon(Icons.sms),
//       ),
//     );
//   }
// }

//Before filteration code ....


// import 'package:flutter/material.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class SMSScreen extends StatefulWidget {
//   const SMSScreen({Key? key}) : super(key: key);

//   @override
//   State<SMSScreen> createState() => _SMSScreenState();
// }

// class _SMSScreenState extends State<SMSScreen> {
//   final SmsQuery _query = SmsQuery();
//   List<SmsMessage> _messages = [];
//   late User _currentUser;
//   List<String> shopping = [
//     'amazon',
//     'flipkart',
//     'myntra',
//     'meesho',
//     'ajio',
//   ];

//   List<String> upi = [' upi'];

//   List<String> ride = ['uber', 'ola', 'rapido'];

//   List<String> food = ['swiggy', 'zomato', 'eatclub', 'bse'];

//   List<String> investment = ['upstox', 'groww', 'zerodha', 'uti'];

//   List<String> ott = [
//     'netflix',
//     'prime',
//     'zee',
//     'hotstar',
//     'jiocinema',
//     'sonylib'
//   ];
//   List<String> txn = [
//     'sent',
//     'debit',
//     'debited',
//     'purchase',
//     'deducted',
//     'spent',
//     'paid',
//     'Received',
//     'credited',
//   ];

//   List<String> otpKeywords = [
//     'otp',
//     'code',
//     'ipo',
//     'autopay'
//   ]; // Keywords indicating OTP

//   List<String> sentTxn = [
//     'sent',
//     'debit',
//     'debited',
//     'purchase',
//     'deducted',
//     'spent',
//     'paid'
//   ];
//   List<String> receivedTxn = ['received', 'credited'];

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   Future<void> _getCurrentUser() async {
//     _currentUser = FirebaseAuth.instance.currentUser!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SMS Inbox Example'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10.0),
//         child: _messages.isNotEmpty
//             ? ListView.builder(
//                 itemCount: _messages.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   var message = _messages[index];
//                   var sender =
//                       // message.sender!;
//                       _getSenderName(message.body!); // Update sender name
//                   var date = _formatDate(message.date!);
//                   var body = message.body;

//                   // Check if the message contains any keyword and exclude OTPs
//                   if (_containsKeyword(body!) && !_containsOTP(body)) {
//                     // Determine the text color based on the presence of keywords
//                     Color textColor = _getTextColor(body);

//                     return ListTile(
//                       subtitle: Text('$sender [$date]'),
//                       title: Text(
//                         'Amount: ${trimBody(body)}', // Using trimBody function
//                         style: TextStyle(color: textColor),
//                       ),
//                     );
//                   } else {
//                     // If the message doesn't meet the criteria, return an empty container
//                     return Container();
//                   }
//                 },
//               )
//             : Center(
//                 child: Text(
//                   'No messages to show.\n Tap refresh button...',
//                   style: Theme.of(context).textTheme.headline6,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           var permission = await Permission.sms.status;
//           if (permission.isGranted) {
//             final messages = await _query.querySms(
//               kinds: [
//                 SmsQueryKind.inbox,
//                 SmsQueryKind.sent,
//               ],
//               count: 1000,
//             );
//             debugPrint('sms inbox messages: ${messages.length}');

//             // Save unique SMS to Firestore
//             _saveUniqueSMSToFirestore(messages);

//             setState(() => _messages = messages);
//           } else {
//             await Permission.sms.request();
//           }
//         },
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }

//   // Function to format date
//   String _formatDate(DateTime date) {
//     return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
//   }

//   // Function to save unique SMS to Firestore
//   Future<void> _saveUniqueSMSToFirestore(List<SmsMessage> messages) async {
//     CollectionReference userCollection =
//         FirebaseFirestore.instance.collection('users');

//     String currentUserPhoneNumber = _currentUser.phoneNumber!;
//     CollectionReference smsCollection =
//         userCollection.doc(currentUserPhoneNumber).collection('SMS_Details');

//     for (SmsMessage message in messages) {
//       // Check if the SMS already exists
//       bool smsExists = await _checkIfSMSExists(smsCollection, message);

//       if (!smsExists) {
//         Timestamp timestamp = Timestamp.fromDate(message.date!);

//         await smsCollection.add({
//           'sender': message.sender,
//           'date': timestamp,
//           'body': message.body,
//         });
//       }
//     }
//   }

//   // Function to check if SMS already exists
//   Future<bool> _checkIfSMSExists(
//       CollectionReference smsCollection, SmsMessage message) async {
//     QuerySnapshot querySnapshot = await smsCollection
//         .where('sender', isEqualTo: message.sender)
//         .where('date', isEqualTo: Timestamp.fromDate(message.date!))
//         .where('body', isEqualTo: message.body)
//         .get();

//     return querySnapshot.docs.isNotEmpty;
//   }

//   // Function to check if the message contains any keyword
//   bool _containsKeyword(String message) {
//     for (String keyword in txn) {
//       if (message.toLowerCase().contains(keyword.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

//   // Function to check if the message contains any OTP
//   bool _containsOTP(String message) {
//     for (String otpKeyword in otpKeywords) {
//       if (message.toLowerCase().contains(otpKeyword.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

//   // Function to determine sender name based on keywords
//   String _getSenderName(String body) {
//     for (String keyword in shopping) {
//       if (body.toLowerCase().contains(keyword.toLowerCase())) {
//         return 'Shopping';
//       }
//     }
//     for (String keyword in ride) {
//       if (body.toLowerCase().contains(keyword.toLowerCase())) {
//         return 'Ride';
//       }
//     }
//     for (String keyword in food) {
//       if (body.toLowerCase().contains(keyword.toLowerCase())) {
//         return 'Food';
//       }
//     }
//     for (String keyword in investment) {
//       if (body.toLowerCase().contains(keyword.toLowerCase())) {
//         return 'Investment';
//       }
//     }
//     for (String keyword in ott) {
//       if (body.toLowerCase().contains(keyword.toLowerCase())) {
//         return 'OTT';
//       }
//     }
//     for (String keyword in upi) {
//       if (body.toLowerCase().contains(keyword.toLowerCase())) {
//         return 'UPI';
//       }
//     }
//     return 'Others'; // Default category
//   }

//   // Function to determine text color based on keywords
//   Color _getTextColor(String message) {
//     for (String keyword in sentTxn) {
//       if (message.toLowerCase().contains(keyword.toLowerCase())) {
//         return Colors.red;
//       }
//     }
//     for (String keyword in receivedTxn) {
//       if (message.toLowerCase().contains(keyword.toLowerCase())) {
//         return Colors.green;
//       }
//     }
//     return Colors.black; // Default color
//   }

//   // Function to trim SMS body
//   String trimBody(String body) {
//     String trimmedBody = '';
//     int rsIndex = body.toLowerCase().indexOf(' rs. ');
//     int rs1Index = body.toLowerCase().indexOf(' rs ');
//     int inrIndex = body.toLowerCase().indexOf(' inr ');
//     int inr1Index = body.toLowerCase().indexOf('inr ');
//     int byIndex = body.toLowerCase().indexOf(' debited by ');
//     int creditedIndex = body.toLowerCase().indexOf(' credited with rs');
//     int forIndex = body.toLowerCase().indexOf(' debited for rs ');
//     int sentIndex = body.toLowerCase().indexOf('sent rs.');

//     if (rsIndex != -1) {
//       int endIndex = body.indexOf(' ', rsIndex + 5);
//       trimmedBody =
//           body.substring(rsIndex + 5, endIndex != -1 ? endIndex : body.length);
//     } else if (rs1Index != -1) {
//       int endIndex = body.indexOf(' ', rs1Index + 4);
//       trimmedBody =
//           body.substring(rs1Index + 4, endIndex != -1 ? endIndex : body.length);
//     } else if (inrIndex != -1) {
//       int endIndex = body.indexOf(' ', inrIndex + 5);
//       trimmedBody =
//           body.substring(inrIndex + 5, endIndex != -1 ? endIndex : body.length);
//     } else if (inr1Index != -1) {
//       int endIndex = body.indexOf(' ', inr1Index + 4);
//       trimmedBody = body.substring(
//           inr1Index + 4, endIndex != -1 ? endIndex : body.length);
//     } else if (byIndex != -1) {
//       int endIndex = body.indexOf(' ', byIndex + 12);
//       trimmedBody =
//           body.substring(byIndex + 12, endIndex != -1 ? endIndex : body.length);
//     } else if (creditedIndex != -1) {
//       int endIndex = body.indexOf(' ', creditedIndex + 17);
//       trimmedBody = body.substring(
//           creditedIndex + 17, endIndex != -1 ? endIndex : body.length);
//     } else if (forIndex != -1) {
//       int endIndex = body.indexOf(' ', forIndex + 16);
//       trimmedBody = body.substring(
//           forIndex + 16, endIndex != -1 ? endIndex : body.length);
//     } else if (sentIndex != -1) {
//       int endIndex = body.indexOf(' ', sentIndex + 8);
//       trimmedBody = body.substring(
//           sentIndex + 8, endIndex != -1 ? endIndex : body.length);
//     }
//     return trimmedBody.trim();
//   }
// }

// fetchSMS functions before category expense logic applied :

// void _fetchSMS() async {
  //   var permission = await Permission.sms.status;
  //   if (permission.isGranted) {
  //     final messages = await _query.querySms(
  //       kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
  //       count: 1000,
  //     );
  //     debugPrint('sms inbox messages: ${messages.length}');
  //     _saveUniqueSMSToFirestore(messages);

  //     double redExpense = 0.0;
  //     double greenExpense = 0.0;
  //     double monthlyExpense = 0.0;
  //     double filteredDaysExpense = 0.0;

  //     // Initialize category expenses map
  //     _categoryExpenses = Map.fromIterable(
  //       [
  //         'Shopping',
  //         'Ride',
  //         'Food',
  //         'Investment',
  //         'OTT',
  //         'Groceries',
  //         'UPI',
  //         'Others'
  //       ],
  //       key: (category) => category.toString(),
  //       value: (category) => 0.0,
  //     );

  //     for (var message in messages) {
  //       if (_containsKeyword(message.body!) && !_containsOTP(message.body!)) {
  //         Color textColor = _getTextColor(message.body!);

  //         // Calculate expenses by category
  //         String category = _getSenderName(message.body!);
  //         // Add the expense to the respective category
  //         double expense = double.parse(trimBody(message.body!) ?? '0.0');
  //         _categoryExpenses.update(category, (value) => value + expense,
  //             ifAbsent: () => expense);

  //         if (textColor == Colors.red) {
  //           redExpense += double.parse(trimBody(message.body!) ?? '0.0');
  //         } else if (textColor == Colors.green) {
  //           greenExpense += double.parse(trimBody(message.body!) ?? '0.0');
  //         }

  //         if (DateFormat('MMMM').format(message.date!) == _selectedMonth &&
  //             DateFormat('yyyy').format(message.date!) == _selectedYear) {
  //           if (textColor == Colors.red) {
  //             monthlyExpense += double.parse(trimBody(message.body!) ?? '0.0');
  //           } else if (textColor == Colors.green) {
  //             monthlyExpense -= double.parse(trimBody(message.body!) ?? '0.0');
  //           }
  //         }

  //         if (_selectedFilter != 'Exclude') {
  //           var day = message.date!.day;
  //           var month = DateFormat('MMMM').format(message.date!);
  //           var year = DateFormat('yyyy').format(message.date!);
  //           if ((_selectedFilter == '1' && day >= 1 && day <= 10) ||
  //               (_selectedFilter == '2' && day >= 11 && day <= 20) ||
  //               (_selectedFilter == '3' && day >= 21 && day <= 30) ||
  //               (_selectedFilter == '4' && day == 31)) {
  //             if (month == _selectedMonth && year == _selectedYear) {
  //               if (textColor == Colors.red) {
  //                 filteredDaysExpense +=
  //                     double.parse(trimBody(message.body!) ?? '0.0');
  //               } else if (textColor == Colors.green) {
  //                 filteredDaysExpense -=
  //                     double.parse(trimBody(message.body!) ?? '0.0');
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }

  //     List<SmsMessage> filteredMessages = messages.where((message) {
  //       var day = message.date!.day;
  //       var month = DateFormat('MMMM').format(message.date!);
  //       var year = DateFormat('yyyy').format(message.date!);
  //       if (_selectedFilter == 'Exclude') {
  //         return month == _selectedMonth && year == _selectedYear;
  //       } else {
  //         if ((_selectedFilter == '1' && day >= 1 && day <= 10) ||
  //             (_selectedFilter == '2' && day >= 11 && day <= 20) ||
  //             (_selectedFilter == '3' && day >= 21 && day <= 30) ||
  //             (_selectedFilter == '4' && day == 31)) {
  //           return month == _selectedMonth && year == _selectedYear;
  //         } else {
  //           return false;
  //         }
  //       }
  //     }).toList();

  //     setState(() {
  //       _messages = filteredMessages;

  //       _totalRedExpense = redExpense;
  //       _totalGreenExpense = greenExpense;
  //       _totalMonthlyExpense = monthlyExpense;

  //       if (_selectedFilter != 'Exclude') {
  //         _totalFilteredDaysExpense = filteredDaysExpense;
  //       }
  //     });
  //   } else {
  //     await Permission.sms.request();
  //   }
  // }
  // void _fetchSMS() async {
  //   var permission = await Permission.sms.status;
  //   if (permission.isGranted) {
  //     final messages = await _query.querySms(
  //       kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
  //       count: 1000,
  //     );
  //     debugPrint('sms inbox messages: ${messages.length}');
  //     _saveUniqueSMSToFirestore(messages);

  //     double redExpense = 0.0;
  //     double greenExpense = 0.0;
  //     double monthlyExpense = 0.0;
  //     double filteredDaysExpense = 0.0;

  //     // Initialize category expenses map
  //     _categoryExpenses = {
  //       'Shopping': 0.0,
  //       'Ride': 0.0,
  //       'Food': 0.0,
  //       'Investment': 0.0,
  //       'OTT': 0.0,
  //       'Groceries': 0.0,
  //       'UPI': 0.0,
  //       'Others': 0.0,
  //     };

  //     for (var message in messages) {
  //       if (_containsKeyword(message.body!) && !_containsOTP(message.body!)) {
  //         Color textColor = _getTextColor(message.body!);

  //         // Calculate expenses by category
  //         String category = _getSenderName(message.body!);
  //         double expense = double.parse(trimBody(message.body!) ?? '0.0');

  //         // Apply the selected filters
  //         var day = message.date!.day;
  //         var month = DateFormat('MMMM').format(message.date!);
  //         var year = DateFormat('yyyy').format(message.date!);

  //         if (_selectedFilter == 'Exclude') {
  //           if ((_selectedFilter == '1' && day >= 1 && day <= 10) ||
  //               (_selectedFilter == '2' && day >= 11 && day <= 20) ||
  //               (_selectedFilter == '3' && day >= 21 && day <= 30) ||
  //               (_selectedFilter == '4' && day == 31)) {
  //             _updateCategoryExpense(category, textColor, expense);
  //           }
  //         } else if (month == _selectedMonth && year == _selectedYear) {
  //           if ((_selectedFilter == '1' && day >= 1 && day <= 10) ||
  //               (_selectedFilter == '2' && day >= 11 && day <= 20) ||
  //               (_selectedFilter == '3' && day >= 21 && day <= 30) ||
  //               (_selectedFilter == '4' && day == 31)) {
  //             _updateCategoryExpense(category, textColor, expense);
  //           }
  //         }

  //         // Update total expenses based on text color
  //         if (textColor == Colors.red) {
  //           redExpense += expense;
  //         } else if (textColor == Colors.green) {
  //           greenExpense += expense;
  //         }

  //         // Update monthly expense based on text color
  //         if (month == _selectedMonth && year == _selectedYear) {
  //           if (textColor == Colors.red) {
  //             monthlyExpense += expense;
  //           } else if (textColor == Colors.green) {
  //             monthlyExpense -= expense;
  //           }
  //         }

  //         // Update filtered days expense based on text color and filter
  //         if (_selectedFilter != 'Exclude') {
  //           if ((_selectedFilter == '1' && day >= 1 && day <= 10) ||
  //               (_selectedFilter == '2' && day >= 11 && day <= 20) ||
  //               (_selectedFilter == '3' && day >= 21 && day <= 30) ||
  //               (_selectedFilter == '4' && day == 31)) {
  //             if (month == _selectedMonth && year == _selectedYear) {
  //               if (textColor == Colors.red) {
  //                 filteredDaysExpense += expense;
  //               } else if (textColor == Colors.green) {
  //                 filteredDaysExpense -= expense;
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }

  //     setState(() {
  //       _totalRedExpense = redExpense;
  //       _totalGreenExpense = greenExpense;
  //       _totalMonthlyExpense = monthlyExpense;
  //       _totalFilteredDaysExpense = filteredDaysExpense;
  //     });
  //   } else {
  //     await Permission.sms.request();
  //   }
  // }
 
 // build function of SMS SCreen before category logic applied :

 
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('SMS Inbox Example'),
  //     ),
  //     body: SingleChildScrollView(
  //       child: Container(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 DropdownButton<String>(
  //                   value: _selectedMonth,
  //                   items: _monthsList.map((String month) {
  //                     return DropdownMenuItem<String>(
  //                       value: month,
  //                       child: Text(month),
  //                     );
  //                   }).toList(),
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       _selectedMonth = newValue!;
  //                     });
  //                     _fetchSMS();
  //                   },
  //                 ),
  //                 SizedBox(width: 20),
  //                 DropdownButton<String>(
  //                   value: _selectedYear,
  //                   items: _yearsList.map((String year) {
  //                     return DropdownMenuItem<String>(
  //                       value: year,
  //                       child: Text(year),
  //                     );
  //                   }).toList(),
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       _selectedYear = newValue!;
  //                     });
  //                     _fetchSMS();
  //                   },
  //                 ),
  //                 SizedBox(width: 20),
  //                 DropdownButton<String>(
  //                   value: _selectedFilter,
  //                   items: ['1', '2', '3', '4', 'Exclude'].map((String value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value,
  //                       child: Text('Filter $value'),
  //                     );
  //                   }).toList(),
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       _selectedFilter = newValue!;
  //                     });
  //                     _fetchSMS();
  //                   },
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 20),
  //             // Display total expenses for each category
  //             Wrap(
  //               spacing: 10,
  //               runSpacing: 10,
  //               children: _categoryExpenses.entries.map((entry) {
  //                 return Container(
  //                   padding: EdgeInsets.all(10),
  //                   width: MediaQuery.of(context).size.width / 2 - 15,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: Colors.grey[200],
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         entry.key,
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       SizedBox(height: 5),
  //                       Text(
  //                         'Amount: ${entry.value.toStringAsFixed(2)}',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }).toList(),
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               'Total Expense: ${(_totalRedExpense - _totalGreenExpense).toStringAsFixed(2)}',
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               'Total Monthly Expense: ${_totalMonthlyExpense.toStringAsFixed(2)}',
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //             if (_selectedFilter != 'Exclude')
  //               Text(
  //                 'Total Filtered Days Expense: ${_totalFilteredDaysExpense.toStringAsFixed(2)}',
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //             SizedBox(height: 20),
  //             _messages.isNotEmpty
  //                 ? ListView.builder(
  //                     shrinkWrap: true,
  //                     physics: NeverScrollableScrollPhysics(),
  //                     itemCount: _messages.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       var message = _messages[index];
  //                       var sender = _getSenderName(message.body!);
  //                       var date = _formatDate(message.date!);
  //                       var body = message.body;

  //                       if (_containsKeyword(body!) && !_containsOTP(body)) {
  //                         Color textColor = _getTextColor(body);

  //                         return ListTile(
  //                           subtitle: Text('$sender [$date]'),
  //                           title: Text(
  //                             '${trimBody(body)}',
  //                             style: TextStyle(color: textColor),
  //                           ),
  //                         );
  //                       } else {
  //                         return Container();
  //                       }
  //                     },
  //                   )
  //                 : Center(
  //                     child: Text(
  //                       'No messages to show.\n Tap refresh button...',
  //                       style: Theme.of(context).textTheme.headline6,
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _fetchSMS,
  //       child: const Icon(Icons.refresh),
  //     ),
  //   );
  // }