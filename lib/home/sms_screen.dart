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
//   List<String> shopping = ['amazon', 'flipkart', 'myntra', 'meesho', 'ajio'];
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
//     'credited'
//   ];
//   List<String> otpKeywords = ['otp', 'code', 'ipo', 'autopay'];
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

//   late String _selectedMonth;
//   late String _selectedYear;
//   late List<String> _monthsList;
//   late List<String> _yearsList;
//   double _totalRedExpense = 0.0;
//   double _totalGreenExpense = 0.0;
//   double _totalMonthlyExpense = 0.0; // Added for total monthly expense

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//     _initializeMonthsList();
//     _initializeYearsList();
//   }

//   void _initializeMonthsList() {
//     _monthsList = [];
//     for (int i = 1; i <= 12; i++) {
//       _monthsList
//           .add(DateFormat('MMMM').format(DateTime(DateTime.now().year, i)));
//     }
//     _selectedMonth = _monthsList[DateTime.now().month - 1];
//   }

//   void _initializeYearsList() {
//     int currentYear = DateTime.now().year;
//     _yearsList = [];
//     for (int i = currentYear; i >= 2000; i--) {
//       _yearsList.add(i.toString());
//     }
//     _selectedYear = currentYear.toString();
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
//         child: Column(
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
//               ],
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Total Expense: ${(_totalRedExpense - _totalGreenExpense).toStringAsFixed(2)}',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text(
//               'Total Monthly Expense: ${_totalMonthlyExpense.toStringAsFixed(2)}', // Display total monthly expense
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: _messages.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: _messages.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         var message = _messages[index];
//                         var sender = _getSenderName(message.body!);
//                         var date = _formatDate(message.date!);
//                         var body = message.body;

//                         if (_containsKeyword(body!) && !_containsOTP(body)) {
//                           Color textColor = _getTextColor(body);

//                           if (textColor == Colors.red) {
//                             _totalRedExpense += double.parse(trimBody(body));
//                           } else if (textColor == Colors.green) {
//                             _totalGreenExpense += double.parse(trimBody(body));
//                           }

//                           return ListTile(
//                             subtitle: Text('$sender [$date]'),
//                             title: Text(
//                               '${trimBody(body)}',
//                               style: TextStyle(color: textColor),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       },
//                     )
//                   : Center(
//                       child: Text(
//                         'No messages to show.\n Tap refresh button...',
//                         style: Theme.of(context).textTheme.headline6,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _fetchSMS,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }

//   void _fetchSMS() async {
//     var permission = await Permission.sms.status;
//     if (permission.isGranted) {
//       final messages = await _query.querySms(
//         kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
//         count: 1000,
//       );
//       debugPrint('sms inbox messages: ${messages.length}');
//       _saveUniqueSMSToFirestore(messages);

//       double redExpense = 0.0;
//       double greenExpense = 0.0;
//       double monthlyExpense = 0.0;

//       for (var message in messages) {
//         if (_containsKeyword(message.body!) && !_containsOTP(message.body!)) {
//           Color textColor = _getTextColor(message.body!);

//           if (textColor == Colors.red) {
//             redExpense += double.parse(trimBody(message.body!)) ?? 0.0;
//           } else if (textColor == Colors.green) {
//             greenExpense += double.parse(trimBody(message.body!)) ?? 0.0;
//           }

//           // Calculate total monthly expense
//           if (DateFormat('MMMM').format(message.date!) == _selectedMonth &&
//               DateFormat('yyyy').format(message.date!) == _selectedYear) {
//             if (textColor == Colors.red) {
//               monthlyExpense += double.parse(trimBody(message.body!)) ?? 0.0;
//             } else if (textColor == Colors.green) {
//               monthlyExpense -= double.parse(trimBody(message.body!)) ?? 0.0;
//             }
//           }
//         }
//       }

//       setState(() {
//         _messages = messages.where((message) {
//           return DateFormat('MMMM').format(message.date!) == _selectedMonth &&
//               DateFormat('yyyy').format(message.date!) == _selectedYear;
//         }).toList();

//         _totalRedExpense = redExpense;
//         _totalGreenExpense = greenExpense;
//         _totalMonthlyExpense = monthlyExpense; // Update total monthly expense
//       });
//     } else {
//       await Permission.sms.request();
//     }
//   }

//   String _formatDate(DateTime date) {
//     return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
//   }

//   Future<void> _saveUniqueSMSToFirestore(List<SmsMessage> messages) async {
//     CollectionReference userCollection =
//         FirebaseFirestore.instance.collection('users');
//     String currentUserPhoneNumber = _currentUser.phoneNumber!;
//     CollectionReference smsCollection =
//         userCollection.doc(currentUserPhoneNumber).collection('SMS_Details');

//     for (SmsMessage message in messages) {
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

//   Future<bool> _checkIfSMSExists(
//       CollectionReference smsCollection, SmsMessage message) async {
//     QuerySnapshot querySnapshot = await smsCollection
//         .where('sender', isEqualTo: message.sender)
//         .where('date', isEqualTo: Timestamp.fromDate(message.date!))
//         .where('body', isEqualTo: message.body)
//         .get();

//     return querySnapshot.docs.isNotEmpty;
//   }

//   bool _containsKeyword(String message) {
//     for (String keyword in txn) {
//       if (message.toLowerCase().contains(keyword.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

//   bool _containsOTP(String message) {
//     for (String otpKeyword in otpKeywords) {
//       if (message.toLowerCase().contains(otpKeyword.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

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

//     // Using regular expression to extract numerical values and removing commas
//     RegExp regex = RegExp(r'(\d+)(?:\.\d+)?');
//     List<Match> matches = regex.allMatches(trimmedBody).toList();

//     if (matches.isNotEmpty) {
//       double total = 0;
//       for (Match match in matches) {
//         total += double.parse(match.group(0)!);
//       }
//       return total.toStringAsFixed(0);
//     } else {
//       return '0';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SMSScreen extends StatefulWidget {
  const SMSScreen({Key? key}) : super(key: key);

  @override
  State<SMSScreen> createState() => _SMSScreenState();
}

class _SMSScreenState extends State<SMSScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  late User _currentUser;
  List<String> shopping = ['amazon', 'flipkart', 'myntra', 'meesho', 'ajio'];
  List<String> upi = [' upi'];
  List<String> ride = ['uber', 'ola', 'rapido'];
  List<String> food = ['swiggy', 'zomato', 'eatclub', 'bse'];
  List<String> investment = ['upstox', 'groww', 'zerodha', 'uti'];
  List<String> ott = [
    'netflix',
    'prime',
    'zee',
    'hotstar',
    'jiocinema',
    'sonylib'
  ];
  List<String> txn = [
    'sent',
    'debit',
    'debited',
    'purchase',
    'deducted',
    'spent',
    'paid',
    'Received',
    'credited'
  ];
  List<String> otpKeywords = ['otp', 'code', 'ipo', 'autopay'];
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

  late String _selectedMonth;
  late String _selectedYear;
  late List<String> _monthsList;
  late List<String> _yearsList;
  double _totalRedExpense = 0.0;
  double _totalGreenExpense = 0.0;
  double _totalMonthlyExpense = 0.0; // Added for total monthly expense
  String _selectedFilter = '1';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _initializeMonthsList();
    _initializeYearsList();
  }

  void _initializeMonthsList() {
    _monthsList = [];
    for (int i = 1; i <= 12; i++) {
      _monthsList
          .add(DateFormat('MMMM').format(DateTime(DateTime.now().year, i)));
    }
    _selectedMonth = _monthsList[DateTime.now().month - 1];
  }

  void _initializeYearsList() {
    int currentYear = DateTime.now().year;
    _yearsList = [];
    for (int i = currentYear; i >= 2000; i--) {
      _yearsList.add(i.toString());
    }
    _selectedYear = currentYear.toString();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Inbox Example'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedMonth,
                  items: _monthsList.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue!;
                    });
                    _fetchSMS();
                  },
                ),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedYear,
                  items: _yearsList.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYear = newValue!;
                    });
                    _fetchSMS();
                  },
                ),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: ['1', '2', '3', '4', 'Exclude'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Filter $value'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                    _fetchSMS();
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total Expense: ${(_totalRedExpense - _totalGreenExpense).toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Total Monthly Expense: ${_totalMonthlyExpense.toStringAsFixed(2)}', // Display total monthly expense
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _messages.isNotEmpty
                  ? ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        var message = _messages[index];
                        var sender = _getSenderName(message.body!);
                        var date = _formatDate(message.date!);
                        var body = message.body;

                        if (_containsKeyword(body!) && !_containsOTP(body)) {
                          Color textColor = _getTextColor(body);

                          if (textColor == Colors.red) {
                            _totalRedExpense += double.parse(trimBody(body));
                          } else if (textColor == Colors.green) {
                            _totalGreenExpense += double.parse(trimBody(body));
                          }

                          return ListTile(
                            subtitle: Text('$sender [$date]'),
                            title: Text(
                              '${trimBody(body)}',
                              style: TextStyle(color: textColor),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  : Center(
                      child: Text(
                        'No messages to show.\n Tap refresh button...',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchSMS,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _fetchSMS() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
        count: 1000,
      );
      debugPrint('sms inbox messages: ${messages.length}');
      _saveUniqueSMSToFirestore(messages);

      double redExpense = 0.0;
      double greenExpense = 0.0;
      double monthlyExpense = 0.0;

      for (var message in messages) {
        if (_containsKeyword(message.body!) && !_containsOTP(message.body!)) {
          Color textColor = _getTextColor(message.body!);

          if (textColor == Colors.red) {
            redExpense += double.parse(trimBody(message.body!)) ?? 0.0;
          } else if (textColor == Colors.green) {
            greenExpense += double.parse(trimBody(message.body!)) ?? 0.0;
          }

          // Calculate total monthly expense
          if (DateFormat('MMMM').format(message.date!) == _selectedMonth &&
              DateFormat('yyyy').format(message.date!) == _selectedYear) {
            if (textColor == Colors.red) {
              monthlyExpense += double.parse(trimBody(message.body!)) ?? 0.0;
            } else if (textColor == Colors.green) {
              monthlyExpense -= double.parse(trimBody(message.body!)) ?? 0.0;
            }
          }
        }
      }

      setState(() {
        _messages = messages.where((message) {
          // Filter messages based on selected filter option
          var day = message.date!.day;
          var month = DateFormat('MMMM').format(message.date!);
          var year = DateFormat('yyyy').format(message.date!);
          if (_selectedFilter == '1') {
            return day >= 1 &&
                day <= 10 &&
                month == _selectedMonth &&
                year == _selectedYear;
          } else if (_selectedFilter == '2') {
            return day >= 11 &&
                day <= 20 &&
                month == _selectedMonth &&
                year == _selectedYear;
          } else if (_selectedFilter == '3') {
            return day >= 21 &&
                day <= 30 &&
                month == _selectedMonth &&
                year == _selectedYear;
          } else if (_selectedFilter == '4') {
            return day == 31 &&
                month == _selectedMonth &&
                year == _selectedYear;
          } else {
            return true; // Exclude filter, show all messages
          }
        }).toList();

        _totalRedExpense = redExpense;
        _totalGreenExpense = greenExpense;
        _totalMonthlyExpense = monthlyExpense; // Update total monthly expense
      });
    } else {
      await Permission.sms.request();
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  Future<void> _saveUniqueSMSToFirestore(List<SmsMessage> messages) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    String currentUserPhoneNumber = _currentUser.phoneNumber!;
    CollectionReference smsCollection =
        userCollection.doc(currentUserPhoneNumber).collection('SMS_Details');

    for (SmsMessage message in messages) {
      bool smsExists = await _checkIfSMSExists(smsCollection, message);

      if (!smsExists) {
        Timestamp timestamp = Timestamp.fromDate(message.date!);

        await smsCollection.add({
          'sender': message.sender,
          'date': timestamp,
          'body': message.body,
        });
      }
    }
  }

  Future<bool> _checkIfSMSExists(
      CollectionReference smsCollection, SmsMessage message) async {
    QuerySnapshot querySnapshot = await smsCollection
        .where('sender', isEqualTo: message.sender)
        .where('date', isEqualTo: Timestamp.fromDate(message.date!))
        .where('body', isEqualTo: message.body)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  bool _containsKeyword(String message) {
    for (String keyword in txn) {
      if (message.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  bool _containsOTP(String message) {
    for (String otpKeyword in otpKeywords) {
      if (message.toLowerCase().contains(otpKeyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  String _getSenderName(String body) {
    for (String keyword in shopping) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        return 'Shopping';
      }
    }
    for (String keyword in ride) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        return 'Ride';
      }
    }
    for (String keyword in food) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        return 'Food';
      }
    }
    for (String keyword in investment) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        return 'Investment';
      }
    }
    for (String keyword in ott) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        return 'OTT';
      }
    }
    for (String keyword in upi) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        return 'UPI';
      }
    }
    return 'Others'; // Default category
  }

  Color _getTextColor(String message) {
    for (String keyword in sentTxn) {
      if (message.toLowerCase().contains(keyword.toLowerCase())) {
        return Colors.red;
      }
    }
    for (String keyword in receivedTxn) {
      if (message.toLowerCase().contains(keyword.toLowerCase())) {
        return Colors.green;
      }
    }
    return Colors.black; // Default color
  }

  String trimBody(String body) {
    String trimmedBody = '';
    int rsIndex = body.toLowerCase().indexOf(' rs. ');
    int rs1Index = body.toLowerCase().indexOf(' rs ');
    int inrIndex = body.toLowerCase().indexOf(' inr ');
    int inr1Index = body.toLowerCase().indexOf('inr ');
    int byIndex = body.toLowerCase().indexOf(' debited by ');
    int creditedIndex = body.toLowerCase().indexOf(' credited with rs');
    int forIndex = body.toLowerCase().indexOf(' debited for rs ');
    int sentIndex = body.toLowerCase().indexOf('sent rs.');

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
    } else if (inr1Index != -1) {
      int endIndex = body.indexOf(' ', inr1Index + 4);
      trimmedBody = body.substring(
          inr1Index + 4, endIndex != -1 ? endIndex : body.length);
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
    } else if (sentIndex != -1) {
      int endIndex = body.indexOf(' ', sentIndex + 8);
      trimmedBody = body.substring(
          sentIndex + 8, endIndex != -1 ? endIndex : body.length);
    }

    // Using regular expression to extract numerical values and removing commas
    RegExp regex = RegExp(r'(\d+)(?:\.\d+)?');
    List<Match> matches = regex.allMatches(trimmedBody).toList();

    if (matches.isNotEmpty) {
      double total = 0;
      for (Match match in matches) {
        total += double.parse(match.group(0)!);
      }
      return total.toStringAsFixed(0);
    } else {
      return '0';
    }
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: SMSScreen(),
//   ));
// }
