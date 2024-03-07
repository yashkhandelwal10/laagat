// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Dashboard extends StatefulWidget {
//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   List<Map<String, dynamic>> userData = [];

//   List<String> sentTxn = [
//     'sent',
//     'debit',
//     'debited',
//     'purchase',
//     'deducted',
//     'spent'
//   ];

//   List<String> receivedTxn = ['received', 'credit', 'credited'];

//   bool containsAnyKeyword(String text, List<String> keywords) {
//     print("Text: $text");
//     for (String keyword in keywords) {
//       print("Checking keyword: $keyword");
//       if (text.toLowerCase().contains(keyword.toLowerCase())) {
//         print("Keyword found: $keyword");
//         return true;
//       }
//     }
//     return false;
//   }
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 fetchData();
//               },
//               child: Text('Fetch Data'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: userData.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('  Body: ${userData[index]['body']}',style: TextStyle(
//                           color: containsAnyKeyword(paragraph, sentTxn)
//                               ? Colors.red
//                               : Colors.green,
//                         ),),
//                         Text(
//                             '  Date: ${userData[index]['formattedDate'] ?? 'N/A'}'),
//                         Text('  Sender: ${userData[index]['sender']}'),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> fetchData() async {
//     try {
//       // Check if the user is authenticated
//       User? user = _auth.currentUser;
//       if (user == null) {
//         print('User not authenticated.');
//         return;
//       }

//       // Clear existing data before fetching new data
//       setState(() {
//         userData.clear();
//       });

//       // Reference to the Firestore collection "users"
//       CollectionReference usersCollection =
//           FirebaseFirestore.instance.collection('users');

//       // Fetch documents from the "user_sms" collection under the current user
//       QuerySnapshot userSmsSnapshot =
//           await usersCollection.doc(user.uid).collection('user_sms').get();

//       // Iterate through each document in the "user_sms" collection
//       userSmsSnapshot.docs.forEach((smsDoc) {
//         // Check if the SMS body contains keywords 'Rs.' or 'INR'
//         String body = trimBody(smsDoc['body'] ?? '');
//         if (body.isNotEmpty) {
//           // Extract data from each document
//           Map<String, dynamic> smsData = {
//             'body': body,
//             'date': (smsDoc['date'] as Timestamp?)?.toDate(),
//             'formattedDate': (smsDoc['date'] as Timestamp?) != null
//                 ? DateFormat.yMd()
//                     .add_jm()
//                     .format((smsDoc['date'] as Timestamp).toDate())
//                 : null,
//             'sender': smsDoc['sender'],
//           };

//           // Add the data to the list
//           setState(() {
//             userData.add(smsData);
//           });
//         }
//       });

//       // Print the fetched data
//       print('User SMS Data: $userData');
//     } catch (error) {
//       print('Error fetching data: $error');
//       // Optionally, you can show a snackbar or dialog to inform the user about the error
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
//     }
//   }

//   String trimBody(String body) {
//     // Trims the body to contain only one word after keywords like ' Rs. ' or ' INR '
//     String trimmedBody = '';
//     int rsIndex = body.toLowerCase().indexOf(' rs. ');
//     int inrIndex = body.toLowerCase().indexOf(' inr ');
//     int byIndex = body.toLowerCase().indexOf(' debited by ');

//     if (rsIndex != -1) {
//       int endIndex = body.indexOf(' ', rsIndex + 5);
//       trimmedBody =
//           body.substring(rsIndex + 5, endIndex != -1 ? endIndex : body.length);
//     } else if (inrIndex != -1) {
//       int endIndex = body.indexOf(' ', inrIndex + 5);
//       trimmedBody =
//           body.substring(inrIndex + 5, endIndex != -1 ? endIndex : body.length);
//     } else if (byIndex != -1) {
//       int endIndex = body.indexOf(' ', byIndex + 12);
//       trimmedBody =
//           body.substring(byIndex + 12, endIndex != -1 ? endIndex : body.length);
//     }
//     return trimmedBody.trim();
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Dashboard extends StatefulWidget {
//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   List<Map<String, dynamic>> userData = [];
//   List<String> sentTxn = [
//     'sent',
//     'debit',
//     'debited',
//     'purchase',
//     'deducted',
//     'spent',
//     'paid'
//   ];
//   List<String> receivedTxn = ['received', 'credit', 'credited'];

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 fetchData();
//               },
//               child: Text('Fetch Data'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: userData.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '  Body: ${userData[index]['coloredBody'] ?? 'N/A'}',
//                           style: TextStyle(
//                             color: userData[index]['color'],
//                           ),
//                         ),
//                         Text(
//                           '  Date: ${userData[index]['formattedDate'] ?? 'N/A'}',
//                         ),
//                         Text(
//                           '  Sender: ${userData[index]['sender'] ?? 'N/A'}',
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> fetchData() async {
//     try {
//       // Check if the user is authenticated
//       User? user = _auth.currentUser;
//       if (user == null) {
//         print('User not authenticated.');
//         return;
//       }

//       // Clear existing data before fetching new data
//       setState(() {
//         userData.clear();
//       });

//       // Reference to the Firestore collection "users"
//       CollectionReference usersCollection =
//           FirebaseFirestore.instance.collection('users');
//       // Combine "+91" prefix with the user's phone number
//       String phoneNumberWithCountryCode = "+91${user.phoneNumber}";

//       // Fetch documents from the "users" collection using the combined phone number
//       DocumentSnapshot userDocument =
//           await usersCollection.doc(phoneNumberWithCountryCode).get();

//       // Fetch documents from the "user_sms" collection under the current user
//       QuerySnapshot userSmsSnapshot = await usersCollection
//           // .doc(user.uid)
//           .doc(phoneNumberWithCountryCode)
//           .collection('SMS_Details')
//           .orderBy('date',
//               descending: true) // Order by date in descending order
//           .get();

//       // Iterate through each document in the "user_sms" collection
//       userSmsSnapshot.docs.forEach((smsDoc) {
//         // Extract data from each document
//         String body = smsDoc['body'] ?? '';
//         String coloredBody = trimBody(body);
//         Color color = determineColor(body);

//         if (coloredBody.isNotEmpty) {
//           // Add the data to the list
//           setState(() {
//             userData.add({
//               'coloredBody': coloredBody,
//               'formattedDate': (smsDoc['date'] as Timestamp?) != null
//                   ? DateFormat.yMd()
//                       .add_jm()
//                       .format((smsDoc['date'] as Timestamp).toDate())
//                   : null,
//               'sender': smsDoc['sender'],
//               'color': color,
//             });
//           });
//         }
//       });

//       // Print the fetched data
//       print('User SMS Data: $userData');
//     } catch (error) {
//       print('Error fetching data: $error');
//       // Optionally, you can show a snackbar or dialog to inform the user about the error
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
//     }
//   }

//   String trimBody(String body) {
//     // Trims the body to contain only one word after keywords like ' Rs. ' or ' INR '
//     String trimmedBody = '';
//     int rsIndex = body.toLowerCase().indexOf(' rs. ');
//     int inrIndex = body.toLowerCase().indexOf(' inr ');
//     int byIndex = body.toLowerCase().indexOf(' debited by ');

//     if (rsIndex != -1) {
//       int endIndex = body.indexOf(' ', rsIndex + 5);
//       trimmedBody =
//           body.substring(rsIndex + 5, endIndex != -1 ? endIndex : body.length);
//     } else if (inrIndex != -1) {
//       int endIndex = body.indexOf(' ', inrIndex + 5);
//       trimmedBody =
//           body.substring(inrIndex + 5, endIndex != -1 ? endIndex : body.length);
//     } else if (byIndex != -1) {
//       int endIndex = body.indexOf(' ', byIndex + 12);
//       trimmedBody =
//           body.substring(byIndex + 12, endIndex != -1 ? endIndex : body.length);
//     }
//     return trimmedBody.trim();
//   }

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
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Dashboard extends StatefulWidget {
//   Dashboard({Key? key, required this.user}) : super(key: key);
//   final User user;
//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   List<Map<String, dynamic>> userData = [];
//   List<String> sentTxn = [
//     'sent',
//     'debit',
//     'debited',
//     'purchase',
//     'deducted',
//     'spent',
//     'paid'
//   ];
//   List<String> receivedTxn = ['received', 'credit', 'credited'];

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 fetchData();
//               },
//               child: Text('Fetch Data'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: userData.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '  Body: ${userData[index]['body'] ?? 'N/A'}',
//                           style: TextStyle(
//                             color: userData[index]['color'] ?? Colors.black,
//                           ),
//                         ),
//                         Text(
//                           '  Date: ${userData[index]['formattedDate'] ?? 'N/A'}',
//                         ),
//                         Text(
//                           '  Sender: ${userData[index]['sender'] ?? 'N/A'}',
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Future<void> fetchData() async {
//   //   try {
//   //     // Check if the user is authenticated
//   // User? user = _auth.currentUser;
//   // if (user == null) {
//   //   print('User not authenticated.');
//   //   return;
//   // }

//   //     // Clear existing data before fetching new data
//   //     setState(() {
//   //       userData.clear();
//   //     });

//   //     // Combine "+91" prefix with the user's phone number
//   //     String phoneNumberWithCountryCode = "+91${user.phoneNumber}";

//   //     // Reference to the Firestore collection "users"
//   //     CollectionReference usersCollection =
//   //         FirebaseFirestore.instance.collection('users');

//   //     // Fetch documents from the "SMS_Details" collection under the current user
//   //     QuerySnapshot smsDetailsSnapshot = await usersCollection
//   //         .doc(phoneNumberWithCountryCode)
//   //         .collection('SMS_Details')
//   //         .orderBy('date', descending: true)
//   //         .get();

//   //     // Iterate through each document in the "SMS_Details" collection
//   //     smsDetailsSnapshot.docs.forEach((smsDoc) {
//   //       // Extract data from each document
//   //       String sender = smsDoc['sender'] ?? 'N/A';
//   //       String body = smsDoc['body'] ?? 'N/A';
//   //       Timestamp date = smsDoc['date'] ?? Timestamp.now(); // Default to current time

//   //       // Determine color based on keywords
//   //       Color color = determineColor(body);

//   //       // Format date
//   //       String formattedDate =
//   //           DateFormat.yMd().add_jm().format(date.toDate());

//   //       // Add the data to the list
//   //       setState(() {
//   //         userData.add({
//   //           'sender': sender,
//   //           'body': body,
//   //           'formattedDate': formattedDate,
//   //           'color': color,
//   //         });
//   //       });
//   //     });

//   //     // Print the fetched data
//   //     print('User SMS Data: $userData');
//   //   } catch (error) {
//   //     print('Error fetching data: $error');
//   //     // Optionally, you can show a snackbar or dialog to inform the user about the error
//   //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
//   //   }
//   // }
//   Future<void> fetchData() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) {
//         print('User not authenticated.');
//         return;
//       }
//       final phoneNumber = widget.user.phoneNumber ?? '';
//       // Reference to the Firestore collection "users"
//       CollectionReference userCollection =
//           FirebaseFirestore.instance.collection('users');

//       // Fetch the document corresponding to the user's phone number
//       DocumentSnapshot userDocument =
//           await userCollection.doc(phoneNumber).get();
//       if (!userDocument.exists) {
//         print('User document not found for phone number: $phoneNumber');
//         return;
//       }

//       // Reference to the SMS details collection inside the user's document
//       CollectionReference smsCollection =
//           userDocument.reference.collection('SMS_Details');

//       // Fetch documents from the SMS details collection
//       QuerySnapshot smsSnapshot =
//           await smsCollection.orderBy('date', descending: true).get();

//       // Iterate through each document
//       smsSnapshot.docs.forEach((smsDoc) {
//         // Extract necessary data from the document
//         String sender = smsDoc['sender'];
//         Timestamp timestamp = smsDoc['date'];
//         String body = smsDoc['body'];

//         // Add the extracted data to your list or use it directly
//         // For example, you can add it to your 'userData' list
//         setState(() {
//           userData.add({
//             'sender': sender,
//             'date': timestamp.toDate(),
//             'body': body,
//           });
//         });
//       });
//     } catch (error) {
//       print('Error fetching data: $error');
//       // Handle any errors that occur during fetching
//     }
//   }

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
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> userData = [];
  List<String> sentTxn = [
    'sent',
    'debit',
    'debited',
    'purchase',
    'deducted',
    'spent',
    'paid'
  ];
  List<String> receivedTxn = ['received', 'credit', 'credited'];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '  Body: ${userData[index]['body'] ?? 'N/A'}',
                          style: TextStyle(
                            color: userData[index]['color'] ?? Colors.black,
                          ),
                        ),
                        Text(
                          '  Date: ${userData[index]['formattedDate'] ?? 'N/A'}',
                        ),
                        Text(
                          '  Sender: ${userData[index]['sender'] ?? 'N/A'}',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('User not authenticated.');
        return;
      }
      final phoneNumber = widget.user.phoneNumber ?? '';
      // Reference to the Firestore collection "users"
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      // Fetch the document corresponding to the user's phone number
      DocumentSnapshot userDocument =
          await userCollection.doc(phoneNumber).get();
      if (!userDocument.exists) {
        print('User document not found for phone number: $phoneNumber');
        return;
      }

      // Reference to the SMS details collection inside the user's document
      CollectionReference smsCollection =
          userDocument.reference.collection('SMS_Details');

      // Fetch documents from the SMS details collection
      QuerySnapshot smsSnapshot =
          await smsCollection.orderBy('date', descending: true).get();

      // Iterate through each document
      smsSnapshot.docs.forEach((smsDoc) {
        // Extract necessary data from the document
        String sender = smsDoc['sender'];
        Timestamp timestamp = smsDoc['date'];
        String body = smsDoc['body'];

        // Add the extracted data to your list or use it directly
        // For example, you can add it to your 'userData' list
        setState(() {
          userData.add({
            'sender': sender,
            'date': timestamp.toDate(),
            'body': body,
          });
        });
      });
    } catch (error) {
      print('Error fetching data: $error');
      // Handle any errors that occur during fetching
    }
  }

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
}
