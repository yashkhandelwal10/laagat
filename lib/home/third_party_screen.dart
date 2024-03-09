import 'package:flutter/material.dart';


class ThirdPartyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is the Third Party Screen'),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_sms/flutter_sms.dart';
// import 'package:laagat/home/sms_screen.dart';
// import 'package:permission_handler/permission_handler.dart';

// class SMSFetchScreen extends StatefulWidget {
//   @override
//   _SMSFetchScreenState createState() => _SMSFetchScreenState();
// }

// class _SMSFetchScreenState extends State<SMSFetchScreen> {
//   List<String> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchSMSMessages();
//   }

//   Future<void> _fetchSMSMessages() async {
//     if (await Permission.sms.request().isGranted) {
//       try {
//         List<SmsMessage> smsList = await FlutterSms.listSms(
//           // filter: Filter.address,
//         );

//         setState(() {
//           _messages = smsList.map((message) => message.body ?? '').toList();
//         });
//       } on PlatformException catch (e) {
//         print("Failed to get SMS: '${e.message}'.");
//       }
//     } else {
//       print('Permission not granted');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SMS Inbox'),
//       ),
//       body: ListView.builder(
//         itemCount: _messages.length,
//         itemBuilder: (context, index) {
//           String message = _messages[index];
//           return ListTile(
//             title: Text(message),
//           );
//         },
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: SMSFetchScreen(),
//   ));
// }
