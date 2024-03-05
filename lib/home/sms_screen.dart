// // Dashboard page :

// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:intl/intl.dart';
// import 'package:laagat/message_view_list.dart';
// import 'package:permission_handler/permission_handler.dart';
// // import 'package:trackernew/dashboard/message_view_list.dart';

// class SMSScreen extends StatefulWidget {
//   SMSScreen({Key? key, required this.messages, required this.user})
//       : super(key: key);
//   final User user;
//   final List<SmsMessage> messages;

//   @override
//   State<SMSScreen> createState() => _SMSScreenState();
// }

// class _SMSScreenState extends State<SMSScreen> {
//   final SmsQuery _query = SmsQuery();
//   List<SmsMessage> _messages = [];

//   Future<void> _saveSMSToFirestore() async {
//     CollectionReference smsCollection =
//         FirebaseFirestore.instance.collection('sms');

//     // var smsCollection = FirebaseFirestore.instance
//     //     .collection('messages')
//     //     .orderBy('date', descending: true);

//     // Get the last saved SMS message's date
//     DateTime? lastSavedDate;
//     QuerySnapshot lastSMS =
//         await smsCollection.orderBy('date', descending: true).limit(1).get();
//     if (lastSMS.docs.isNotEmpty) {
//       lastSavedDate = (lastSMS.docs.first['date'] as Timestamp).toDate();
//     }

//     // Filter new messages based on the last saved date
//     List<SmsMessage> newMessages = _messages.where((message) {
//       return lastSavedDate == null ||
//           message.date!.millisecondsSinceEpoch >
//               lastSavedDate.millisecondsSinceEpoch;
//     }).toList();

//     // Sort the new messages by their dates
//     // newMessages.sort((a, b) => a.date!.compareTo(b.date));
//     newMessages.sort(
//         (a, b) => (a.date ?? DateTime(0)).compareTo(b.date ?? DateTime(0)));

//     // Save only the new messages to Firestore
//     for (var message in newMessages) {
//       // Convert message date to Firestore Timestamp
//       Timestamp timestamp = Timestamp.fromDate(message.date!);

//       // Format date as string for display
//       String formattedDate =
//           DateFormat('yyyy-MM-dd – kk:mm').format(message.date!);
//       await smsCollection.add({
//         'sender': message.sender,
//         'date': message.date,
//         'body': message.body,
//         // 'formattedDate': formattedDate,
//       });
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('New SMS data saved to Firestore'),
//       ),
//     );
//   }

//   // Future<void> _saveSMSToFirestore(String phoneNumber, String name) async {
//   //   CollectionReference smsCollection =
//   //       FirebaseFirestore.instance.collection('SMS_Details');

//   //   // Check if the user already exists in the 'users' collection
//   //   DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//   //       .collection('users')
//   //       .doc(phoneNumber)
//   //       .get();

//   //   // If the user exists, get the name from the user document
//   //   if (userSnapshot.exists) {
//   //     name = userSnapshot['name'];
//   //   } else {
//   //     // If the user does not exist, create a new user document
//   //     await FirebaseFirestore.instance
//   //         .collection('users')
//   //         .doc(phoneNumber)
//   //         .set({
//   //       'name': name,
//   //       'phoneNumber': phoneNumber,
//   //     });
//   //   }

//   //   // Get the last saved SMS message's date
//   //   DateTime? lastSavedDate;
//   //   QuerySnapshot lastSMS = await smsCollection
//   //       .where('phoneNumber', isEqualTo: phoneNumber)
//   //       .orderBy('date', descending: true)
//   //       .limit(1)
//   //       .get();
//   //   if (lastSMS.docs.isNotEmpty) {
//   //     lastSavedDate = (lastSMS.docs.first['date'] as Timestamp).toDate();
//   //   }

//   //   // Filter new messages based on the last saved date
//   //   List<SmsMessage> newMessages = _messages.where((message) {
//   //     return lastSavedDate == null ||
//   //         message.date!.millisecondsSinceEpoch >
//   //             lastSavedDate.millisecondsSinceEpoch;
//   //   }).toList();

//   //   // Sort the new messages by their dates
//   //   newMessages.sort(
//   //       (a, b) => (a.date ?? DateTime(0)).compareTo(b.date ?? DateTime(0)));

//   //   // Save only the new messages to Firestore
//   //   for (var message in newMessages) {
//   //     // Convert message date to Firestore Timestamp
//   //     Timestamp timestamp = Timestamp.fromDate(message.date!);

//   //     // Format date as string for display
//   //     String formattedDate =
//   //         DateFormat('yyyy-MM-dd – kk:mm').format(message.date!);
//   //     await smsCollection.add({
//   //       'name': name,
//   //       'phoneNumber': phoneNumber,
//   //       'SMS': {
//   //         'sender': message.sender,
//   //         'date': message.date,
//   //         'body': message.body,
//   //       },
//   //     });
//   //   }

//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(
//   //       content: Text('New SMS data saved to Firestore'),
//   //     ),
//   //   );
//   // }

//   // Future<void> saveSMSToFirestore(
//   //     {required String phoneNumber, required List<SmsMessage> messages}) async {
//   //   CollectionReference smsCollection = FirebaseFirestore.instance
//   //       .collection('sms')
//   //       .doc(phoneNumber)
//   //       .collection('messages');

//   //   // Get the last saved SMS message's date
//   //   DateTime? lastSavedDate;
//   //   QuerySnapshot lastSMS =
//   //       await smsCollection.orderBy('date', descending: true).limit(1).get();
//   //   if (lastSMS.docs.isNotEmpty) {
//   //     lastSavedDate = (lastSMS.docs.first['date'] as Timestamp).toDate();
//   //   }

//   //   // Filter new messages based on the last saved date
//   //   List<SmsMessage> newMessages = messages.where((message) {
//   //     return lastSavedDate == null ||
//   //         message.date!.millisecondsSinceEpoch >
//   //             lastSavedDate.millisecondsSinceEpoch;
//   //   }).toList();

//   //   // Sort the new messages by their dates
//   //   newMessages.sort(
//   //       (a, b) => (a.date ?? DateTime(0)).compareTo(b.date ?? DateTime(0)));

//   //   // Save only the new messages to Firestore
//   //   for (var message in newMessages) {
//   //     // Convert message date to Firestore Timestamp
//   //     Timestamp timestamp = Timestamp.fromDate(message.date!);

//   //     // Format date as string for display
//   //     String formattedDate =
//   //         DateFormat('yyyy-MM-dd – kk:mm').format(message.date!);
//   //     await smsCollection.add({
//   //       'sender': message.sender,
//   //       'date': timestamp,
//   //       'body': message.body,
//   //       'formattedDate': formattedDate,
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // var xyz = _messages.;
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('SMS Inbox Example'),
//             IconButton(
//               icon: Icon(Icons.upload),
//               onPressed: () {
//                 _saveSMSToFirestore;
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10.0),
//         child: _messages.isNotEmpty
//             ? MessagesListView(
//                 messages: _messages,
//               )
//             : Center(
//                 child: Text(
//                   'No messages to show.\n Tap refresh button...',
//                   style: Theme.of(context).textTheme.headlineSmall,
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
//               // address: '+254712345789',
//               count: 50,
//             );
//             debugPrint('sms inbox messages: ${messages.length}');

//             setState(() => _messages = messages);
//           } else {
//             await Permission.sms.request();
//           }
//         },
//         child: const Icon(Icons.refresh),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () async {
//       //     var permission = await Permission.sms.status;
//       //     if (permission.isGranted) {
//       //       final messages = await _query.querySms(
//       //         kinds: [
//       //           SmsQueryKind.inbox,
//       //           SmsQueryKind.sent,
//       //         ],
//       //         count: 50,
//       //       );
//       //       debugPrint('sms inbox messages: ${messages.length}');

//       //       setState(() => _messages = messages);

//       //       // Get the phone number and name associated with the user
//       //       // In this example, I assume you have a method to retrieve this information
//       //       String phoneNumber =
//       //           widget.user.displayName ?? 'users'; // Example phone number
//       //       String name = widget.user.displayName ?? 'users'; // Example name

//       //       // Save SMS data to Firestore
//       //       await _saveSMSToFirestore(phoneNumber, name);
//       //     } else {
//       //       await Permission.sms.request();
//       //     }
//       //   },
//       //   child: const Icon(Icons.upload),
//       // ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:intl/intl.dart';
// import 'package:laagat/message_view_list.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SMSScreen extends StatefulWidget {
//   SMSScreen({Key? key, required this.user}) : super(key: key);
//   final User user;

//   @override
//   State<SMSScreen> createState() => _SMSScreenState();
// }

// class _SMSScreenState extends State<SMSScreen> {
//   final SmsQuery _query = SmsQuery();
//   List<SmsMessage> _messages = [];

//   bool _savingInProgress = false;

//   Future<void> _saveSMSToFirestore() async {
//     setState(() {
//       _savingInProgress = true;
//     });

//     CollectionReference smsCollection =
//         FirebaseFirestore.instance.collection('SMS_Details');

//     final phoneNumber = widget.user.phoneNumber ?? '';
//     final name = widget.user.displayName ?? '';

//     for (SmsMessage message in _messages) {
//       Timestamp timestamp = Timestamp.fromDate(message.date ?? DateTime.now());

//       await smsCollection.add({
//         'name': name,
//         'phoneNumber': phoneNumber,
//         'SMS': {
//           'sender': message.sender,
//           'date': timestamp,
//           'body': message.body,
//         },
//       });
//     }

//     setState(() {
//       _savingInProgress = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('All SMS data saved to Firestore'),
//       ),
//     );
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
//         ],
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: _savingInProgress,
//         child: Container(
//           padding: const EdgeInsets.all(10.0),
//           child: _messages.isNotEmpty
//               ? MessagesListView(
//                   messages: _messages,
//                 )
//               : Center(
//                   child: Text(
//                     'No messages to show.\n Tap refresh button...',
//                     style: Theme.of(context).textTheme.headline6,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//         ),
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
//               count: 50,
//             );
//             setState(() => _messages = messages);
//           } else {
//             await Permission.sms.request();
//           }
//         },
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';
import 'package:laagat/message_view_list.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SMSScreen extends StatefulWidget {
  SMSScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<SMSScreen> createState() => _SMSScreenState();
}

class _SMSScreenState extends State<SMSScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  bool _savingInProgress = false;

  Future<void> _saveSMSToFirestore() async {
    setState(() {
      _savingInProgress = true;
    });

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    final phoneNumber = widget.user.phoneNumber ?? '';
    final name = widget.user.displayName ?? '';

    // Create the SMS details collection inside the user's document
    CollectionReference smsCollection =
        userCollection.doc(phoneNumber).collection('SMS_Details');

    for (SmsMessage message in _messages) {
      Timestamp timestamp = Timestamp.fromDate(message.date ?? DateTime.now());

      await smsCollection.add({
        'name': name,
        'phoneNumber': phoneNumber,
        'SMS': {
          'sender': message.sender,
          'date': timestamp,
          'body': message.body,
        },
      });
    }

    setState(() {
      _savingInProgress = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All SMS data saved to Firestore'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Inbox Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: _savingInProgress ? null : _saveSMSToFirestore,
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _savingInProgress,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? MessagesListView(
                  messages: _messages,
                )
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button...',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var permission = await Permission.sms.status;
          if (permission.isGranted) {
            final messages = await _query.querySms(
              kinds: [
                SmsQueryKind.inbox,
                SmsQueryKind.sent,
              ],
              count: 50,
            );
            setState(() => _messages = messages);
          } else {
            await Permission.sms.request();
          }
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
