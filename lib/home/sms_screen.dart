import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SmsMessage {
  final String sender;
  final String originalBody;
  final String trimmedBody;
  final DateTime date;

  SmsMessage({
    required this.sender,
    required this.originalBody,
    required this.trimmedBody,
    required this.date,
  });
}

class SMSScreen extends StatefulWidget {
  SMSScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<SMSScreen> createState() => _SMSScreenState();
}

class _SMSScreenState extends State<SMSScreen> {
  List<SmsMessage> _messages = [];
  bool _savingInProgress = false;
  bool _fetchingData = false;
  List<String> sentTxn = [
    'sent',
    'debit',
    'debited',
    'purchase',
    'deducted',
    'spent',
    'paid'
  ];
  List<String> receivedTxn = ['received', 'credited'];

  Color determineColor(String body) {
    if (containsAnyKeyword(body, sentTxn)) {
      return Colors.red;
    } else if (containsAnyKeyword(body, receivedTxn)) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }

  bool containsAnyKeyword(String text, List<String> keywords) {
    for (String keyword in keywords) {
      if (text.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  String trimBody(String body) {
    String trimmedBody = '';
    int rsIndex = body.toLowerCase().indexOf(' rs. ');
    int rs1Index = body.toLowerCase().indexOf(' rs ');
    int inrIndex = body.toLowerCase().indexOf(' inr ');
    int byIndex = body.toLowerCase().indexOf(' debited by ');
    int creditedIndex = body.toLowerCase().indexOf(' credited with rs');
    int forIndex = body.toLowerCase().indexOf(' debited for rs ');

    if (rsIndex != -1) {
      int endIndex = body.indexOf(' ', rsIndex + 5);
      trimmedBody =
          body.substring(rsIndex + 5, endIndex != -1 ? endIndex : body.length);
    } else if (rs1Index != -1) {
      int endIndex = body.indexOf(' ', rs1Index + 4);
      trimmedBody =
          body.substring(rs1Index + 4, endIndex != -1 ? endIndex : body.length);
    } else if (inrIndex != -1) {
      int endIndex = body.indexOf(' ', inrIndex + 5);
      trimmedBody =
          body.substring(inrIndex + 5, endIndex != -1 ? endIndex : body.length);
    } else if (byIndex != -1) {
      int endIndex = body.indexOf(' ', byIndex + 12);
      trimmedBody =
          body.substring(byIndex + 12, endIndex != -1 ? endIndex : body.length);
    } else if (creditedIndex != -1) {
      int endIndex = body.indexOf(' ', creditedIndex + 17);
      trimmedBody = body.substring(
          creditedIndex + 17, endIndex != -1 ? endIndex : body.length);
    } else if (forIndex != -1) {
      int endIndex = body.indexOf(' ', forIndex + 16);
      trimmedBody = body.substring(
          forIndex + 16, endIndex != -1 ? endIndex : body.length);
    }
    return trimmedBody.trim();
  }

  Future<void> _fetchData() async {
    setState(() {
      _fetchingData = true;
    });

    try {
      final phoneNumber = widget.user.phoneNumber ?? '';
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      DocumentSnapshot userDocument =
          await userCollection.doc(phoneNumber).get();
      if (!userDocument.exists) {
        print('User document not found for phone number: $phoneNumber');
        return;
      }

      CollectionReference smsCollection =
          userDocument.reference.collection('SMS_Details');

      QuerySnapshot smsSnapshot =
          await smsCollection.orderBy('date', descending: true).get();

      List<SmsMessage> messages = [];

      smsSnapshot.docs.forEach((smsDoc) {
        String sender = smsDoc['sender'];
        Timestamp timestamp = smsDoc['date'];
        String originalBody = smsDoc['body'];
        String trimmedBody = trimBody(originalBody);

        if (trimmedBody.isNotEmpty) {
          // Check if the SMS body contains any keywords from sentTxn or receivedTxn
          if (containsAnyKeyword(originalBody, sentTxn) ||
              containsAnyKeyword(originalBody, receivedTxn)) {
            messages.add(
              SmsMessage(
                sender: sender,
                originalBody: originalBody,
                trimmedBody: trimmedBody,
                date: timestamp.toDate(),
              ),
            );
          }
        }
      });

      setState(() {
        _messages = messages;
        _fetchingData = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _fetchingData = false;
      });
    }
  }

  Future<void> _saveSMSToFirestore() async {
    setState(() {
      _savingInProgress = true;
    });

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    final phoneNumber = widget.user.phoneNumber ?? '';
    final name = widget.user.displayName ?? '';

    CollectionReference smsCollection =
        userCollection.doc(phoneNumber).collection('SMS_Details');

    for (SmsMessage message in _messages) {
      Timestamp timestamp = Timestamp.fromDate(message.date);

      await smsCollection.add({
        'name': name,
        'phoneNumber': phoneNumber,
        'SMS': {
          'sender': message.sender,
          'date': timestamp,
          'originalBody': message.originalBody,
          'trimmedBody': message.trimmedBody,
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

  Future<void> _checkAndRequestSMSPermission() async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      await Permission.sms.request();
    }
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
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchingData ? null : _fetchData,
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _savingInProgress || _fetchingData,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    SmsMessage message = _messages[index];
                    return ListTile(
                      title: Text(
                        'Trimmed Body: ${message.trimmedBody}',
                        style: TextStyle(
                            color: determineColor(message.originalBody)),
                      ),
                      subtitle: Text(
                        'From: ${message.sender}\nDate: ${DateFormat('yyyy-MM-dd – kk:mm').format(message.date)}',
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No messages to show.\nTap "Fetch Data" button to load messages.',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkAndRequestSMSPermission,
        child: Icon(Icons.sms),
      ),
    );
  }
}


