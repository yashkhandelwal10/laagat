import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThirdPartyScreen extends StatefulWidget {
  final User user;

  ThirdPartyScreen({required this.user});

  @override
  State<ThirdPartyScreen> createState() => _ThirdPartyScreenState();
}

class _ThirdPartyScreenState extends State<ThirdPartyScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _smsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSmsDetails();
  }

  Future<void> fetchSmsDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // String currentUserPhoneNumber = '+91' + (widget.user.phoneNumber ?? '');
      String currentUserPhoneNumber = (widget.user.phoneNumber ?? '');

      CollectionReference smsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserPhoneNumber)
          .collection('SMS_Details');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await smsCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      List<Map<String, dynamic>> smsDetails = querySnapshot.docs
          .where((doc) =>
              doc.data().containsKey('trimmed_body') &&
              doc.data().containsKey('filtered_sender'))
          .map((doc) => {
                'trimmed_body': doc['trimmed_body'],
                'filtered_sender': doc['filtered_sender'],
                // Add more fields as needed
              })
          .toList();

      setState(() {
        _smsList = smsDetails;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching SMS details: $error');
      // Handle the error as needed, such as showing a snackbar or retry option
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.phoneNumber!),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _smsList.isEmpty
                ? Text('No SMS details found')
                : ListView.builder(
                    itemCount: _smsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> sms = _smsList[index];
                      return ListTile(
                        title: Text(sms['trimmed_body'] ?? ''),
                        subtitle: Text(sms['filtered_sender'] ?? ''),
                        // Add more fields as needed
                      );
                    },
                  ),
      ),
    );
  }
}
