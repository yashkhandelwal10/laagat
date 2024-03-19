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
  List<String> food = ['swiggy', 'zomato', 'eatclub'];
  List<String> groceries = ['blinkit', 'zepto', 'dunzo', 'instamart'];
  List<String> investment = ['upstox', 'groww', 'zerodha', 'uti'];
  List<String> salary = ['salary'];
  List<String> ott = [
    'netflix',
    'prime',
    'zee',
    'hotstar',
    'jiocinema',
    'sonylib',
    'youtube'
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
  List<String> receivedTxn = ['received', 'credited', 'deposited'];

  late String _selectedMonth;
  late String _selectedYear;
  late List<String> _monthsList;
  late List<String> _yearsList;
  double _totalRedExpense = 0.0;
  double _totalGreenExpense = 0.0;
  double _totalMonthlyExpense = 0.0;
  double _totalFilteredDaysExpense = 0.0;
  String _selectedFilter = '1';
  Map<String, double> _categoryExpenses = {}; // Store expenses by category

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _initializeMonthsList();
    _initializeYearsList();
    _fetchSMS();
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // Display total expenses for each category
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categoryExpenses.entries.map((entry) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 2 - 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Amount: ${entry.value.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Total Expense: ${(_totalRedExpense - _totalGreenExpense).toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Monthly Expense: ${_totalMonthlyExpense.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (_selectedFilter != 'Exclude')
                Text(
                  'Total Filtered Days Expense: ${_totalFilteredDaysExpense.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 20),
              _messages.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        var message = _messages[index];
                        var sender = _getSenderName(message.body!);
                        var date = _formatDate(message.date!);
                        var body = message.body;

                        if (_containsKeyword(body!) && !_containsOTP(body)) {
                          Color textColor = _getTextColor(body);

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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchSMS,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _updateCategoryExpense(
      String category, Color textColor, double expense) {
    if (_categoryExpenses.containsKey(category)) {
      if (textColor == Colors.red) {
        _categoryExpenses[category] =
            (_categoryExpenses[category] ?? 0.0) + expense;
      } else if (textColor == Colors.green) {
        _categoryExpenses[category] =
            (_categoryExpenses[category] ?? 0.0) - expense;
      }
    }
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
      double filteredDaysExpense = 0.0;

      // Initialize category expenses map
      _categoryExpenses = {
        'Salary': 0.0,
        'Shopping': 0.0,
        'Ride': 0.0,
        'Food': 0.0,
        'Investment': 0.0,
        'OTT': 0.0,
        'Groceries': 0.0,
        'UPI': 0.0,
        'Others': 0.0,
      };

      // Initialize filtered messages list
      List<SmsMessage> filteredMessages = [];

      for (var message in messages) {
        if (_containsKeyword(message.body!) && !_containsOTP(message.body!)) {
          Color textColor = _getTextColor(message.body!);

          // Calculate expenses by category
          String category = _getSenderName(message.body!);
          double expense = double.parse(trimBody(message.body!) ?? '0.0');

          // Apply the selected filters
          var day = message.date!.day;
          var month = DateFormat('MMMM').format(message.date!);
          var year = DateFormat('yyyy').format(message.date!);

          if (_selectedFilter == 'Exclude') {
            if (month == _selectedMonth && year == _selectedYear) {
              _updateCategoryExpense(category, textColor, expense);
              filteredMessages.add(message); // Add message to filtered list
            }
          } else {
            if ((_selectedFilter == '1' && day >= 1 && day <= 10) ||
                (_selectedFilter == '2' && day >= 11 && day <= 20) ||
                (_selectedFilter == '3' && day >= 21 && day <= 30) ||
                (_selectedFilter == '4' && day == 31)) {
              if (month == _selectedMonth && year == _selectedYear) {
                _updateCategoryExpense(category, textColor, expense);
                filteredMessages.add(message); // Add message to filtered list
              }
            }
          }

          // Update total expenses based on text color
          if (textColor == Colors.red) {
            redExpense += expense;
          } else if (textColor == Colors.green) {
            greenExpense += expense;
          }

          // Update monthly expense based on text color
          if (month == _selectedMonth && year == _selectedYear) {
            if (textColor == Colors.red) {
              monthlyExpense += expense;
            } else if (textColor == Colors.green) {
              monthlyExpense -= expense;
            }
          }

          // Update filtered days expense based on text color and filter
          if ((_selectedFilter == '1' && day >= 1 && day <= 10) ||
              (_selectedFilter == '2' && day >= 11 && day <= 20) ||
              (_selectedFilter == '3' && day >= 21 && day <= 30) ||
              (_selectedFilter == '4' && day == 31)) {
            if (month == _selectedMonth && year == _selectedYear) {
              if (textColor == Colors.red) {
                filteredDaysExpense += expense;
              } else if (textColor == Colors.green) {
                filteredDaysExpense -= expense;
              }
            }
          }
        }
      }

      setState(() {
        _totalRedExpense = redExpense;
        _totalGreenExpense = greenExpense;
        _totalMonthlyExpense = monthlyExpense;
        _totalFilteredDaysExpense = filteredDaysExpense;
        _messages = filteredMessages; // Update messages list
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

  // String _getSenderName(String body) {
  //   for (String keyword in shopping) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Shopping';
  //     }
  //   }
  //   for (String keyword in ride) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Ride';
  //     }
  //   }
  //   for (String keyword in food) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Food';
  //     }
  //   }
  //   for (String keyword in investment) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Investment';
  //     }
  //   }
  //   for (String keyword in ott) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'OTT';
  //     }
  //   }
  //   for (String keyword in upi) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'UPI';
  //     }
  //   }
  //   for (String keyword in groceries) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'GROCERIES';
  //     }
  //   }
  //   for (String keyword in salary) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Salary';
  //     }
  //   }
  //   return 'Others';
  // }

  // String _getSenderName(String body) {
  //   // Check if the body contains UPI related keywords
  //   for (String keyword in upi) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       // Find the index of "trf to" and "Refno" in the body
  //       int trfToIndex = body.toLowerCase().indexOf(' trf to ');
  //       int refNoIndex = body.toLowerCase().indexOf(' refno ');

  //       // Check if both "trf to" and "Refno" are found in the body
  //       if (trfToIndex != -1 && refNoIndex != -1) {
  //         // Extract the vendor name between "trf to" and "Refno"
  //         String vendorName =
  //             body.substring(trfToIndex + 7, refNoIndex).trim().toUpperCase();
  //         return vendorName;
  //       } else {
  //         // If "trf to" condition is not present, return 'UPI'
  //         return 'UPI';
  //       }
  //     }
  //   }

  //   // If no UPI related keywords are found, return other categories
  //   for (String keyword in shopping) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Shopping';
  //     }
  //   }
  //   for (String keyword in ride) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Ride';
  //     }
  //   }
  //   for (String keyword in food) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Food';
  //     }
  //   }
  //   for (String keyword in investment) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Investment';
  //     }
  //   }
  //   for (String keyword in ott) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'OTT';
  //     }
  //   }
  //   for (String keyword in groceries) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'GROCERIES';
  //     }
  //   }
  //   for (String keyword in salary) {
  //     if (body.toLowerCase().contains(keyword.toLowerCase())) {
  //       return 'Salary';
  //     }
  //   }

  //   // Default return value if no specific category is matched
  //   return 'Others';
  // }

  String _getSenderName(String body) {
    // Check if the body contains UPI related keywords
    for (String keyword in upi) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        // Find the index of "trf to" and "Refno" in the body
        int trfToIndex = body.toLowerCase().indexOf(' trf to ');
        int refNoIndex = body.toLowerCase().indexOf(' refno ');
        // Check if the body contains the specific format for vendor name
        int debitedIndex = body.toLowerCase().indexOf('; ');
        int creditedIndex = body.toLowerCase().indexOf(' credited.');

        // Check if both "trf to" and "Refno" are found in the body
        if (trfToIndex != -1 && refNoIndex != -1) {
          // Extract the vendor name between "trf to" and "Refno"
          String vendorName =
              body.substring(trfToIndex + 7, refNoIndex).trim().toUpperCase();
          return vendorName;
        } else if (debitedIndex != -1 && creditedIndex != -1) {
          // Extract the vendor name between the amount debited and "credited"
          String vendorName = body
              .substring(debitedIndex + 2, creditedIndex)
              .trim()
              .toUpperCase();
          return vendorName;
        } else {
          // If "trf to" condition is not present, return 'UPI'
          return 'UPI';
        }
      }
    }

    // If no specific format is matched, return other categories
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
    for (String keyword in groceries) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        return 'GROCERIES';
      }
    }
    for (String keyword in salary) {
      if (body.toLowerCase().contains(keyword.toLowerCase())) {
        return 'Salary';
      }
    }

    // Default return value if no specific category is matched
    return 'Others';
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
    return Colors.black;
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
    int salaryIndex = body.toLowerCase().indexOf(' salary of rs. ');

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
    } else if (salaryIndex != -1) {
      int endIndex = body.indexOf(' ', salaryIndex + 15);
      trimmedBody = body.substring(
          salaryIndex + 15, endIndex != -1 ? endIndex : body.length);
    }

    RegExp otherTransactionRegex = RegExp(r'(\d+)(?:\.\d+)?');
    RegExp salaryRegex = RegExp(r'(\d{1,3}(,\d{3})*(\.\d+)?)');
    Match? otherTransactionMatch =
        otherTransactionRegex.firstMatch(trimmedBody);
    Match? salaryMatch = salaryRegex.firstMatch(trimmedBody);

    if (salaryMatch != null && salaryIndex != -1) {
      String salaryString = salaryMatch.group(0)!;
      salaryString = salaryString.replaceAll(
          RegExp(r','), ''); // Remove commas from salary string
      double salary = double.parse(salaryString);
      return salary
          .toStringAsFixed(2); // Assuming two decimal places for salary amount
    } else if (otherTransactionMatch != null) {
      double total = 0;
      for (Match match in otherTransactionRegex.allMatches(trimmedBody)) {
        total += double.parse(match.group(0)!);
      }
      return total.toStringAsFixed(0);
    } else {
      return '0';
    }
  }
}

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
//   List<String> food = ['swiggy', 'zomato', 'eatclub'];
//   List<String> groceries = ['blinkit', 'zepto', 'dunzo', 'instamart'];
//   List<String> investment = ['upstox', 'groww', 'zerodha', 'uti'];
//   List<String> ott = [
//     'netflix',
//     'prime',
//     'zee',
//     'hotstar',
//     'jiocinema',
//     'sonylib',
//     'youtube'
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
//   double _totalMonthlyExpense = 0.0;
//   double _totalFilteredDaysExpense = 0.0;
//   String _selectedFilter = '1';
//   Map<String, double> _categoryExpenses = {}; // Store expenses by category

//   late TextEditingController _cashController;

//   @override
//   void initState() {
//     super.initState();
//     _cashController = TextEditingController();
//     _getCurrentUser();
//     _initializeMonthsList();
//     _initializeYearsList();
//     _fetchSMS();
//   }

//   @override
//   void dispose() {
//     _cashController.dispose();
//     super.dispose();
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
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               // Handle editing cash category here
//               _cashController.clear();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: () {
//               // Handle saving cash amount here
//               _updateCashCategory(_cashController.text);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   DropdownButton<String>(
//                     value: _selectedMonth,
//                     items: _monthsList.map((String month) {
//                       return DropdownMenuItem<String>(
//                         value: month,
//                         child: Text(month),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedMonth = newValue!;
//                       });
//                       _fetchSMS();
//                     },
//                   ),
//                   SizedBox(width: 20),
//                   DropdownButton<String>(
//                     value: _selectedYear,
//                     items: _yearsList.map((String year) {
//                       return DropdownMenuItem<String>(
//                         value: year,
//                         child: Text(year),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedYear = newValue!;
//                       });
//                       _fetchSMS();
//                     },
//                   ),
//                   SizedBox(width: 20),
//                   DropdownButton<String>(
//                     value: _selectedFilter,
//                     items: ['1', '2', '3', '4', 'Exclude'].map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text('Filter $value'),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedFilter = newValue!;
//                       });
//                       _fetchSMS();
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               // Editable input field for 'Cash' category
//               TextFormField(
//                 controller: _cashController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'Enter amount for Cash category',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   // Handle updating cash category here
//                 },
//               ),
//               SizedBox(height: 20),
//               // Display total expenses for each category
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: _categoryExpenses.entries.map((entry) {
//                   return Container(
//                     padding: EdgeInsets.all(10),
//                     width: MediaQuery.of(context).size.width / 2 - 15,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.grey[200],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           entry.key,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           'Amount: ${entry.value.toStringAsFixed(2)}',
//                           style: TextStyle(
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Total Expense: ${(_totalRedExpense - _totalGreenExpense).toStringAsFixed(2)}',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 'Total Monthly Expense: ${_totalMonthlyExpense.toStringAsFixed(2)}',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               if (_selectedFilter != 'Exclude')
//                 Text(
//                   'Total Filtered Days Expense: ${_totalFilteredDaysExpense.toStringAsFixed(2)}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               SizedBox(height: 20),
//               _messages.isNotEmpty
//                   ? ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: _messages.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         var message = _messages[index];
//                         var sender = _getSenderName(message.body!);
//                         var date = _formatDate(message.date!);
//                         var body = message.body;

//                         if (_containsKeyword(body!) && !_containsOTP(body)) {
//                           Color textColor = _getTextColor(body);

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
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _fetchSMS,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }

//   void _updateCategoryExpense(
//       String category, Color textColor, double expense) {
//     if (_categoryExpenses.containsKey(category)) {
//       if (textColor == Colors.red) {
//         _categoryExpenses[category] =
//             (_categoryExpenses[category] ?? 0.0) + expense;
//       } else if (textColor == Colors.green) {
//         _categoryExpenses[category] =
//             (_categoryExpenses[category] ?? 0.0) - expense;
//       }
//     }
//   }

//   void _updateCashCategory(String value) {
//     double cashAmount = double.tryParse(value) ?? 0.0;
//     _categoryExpenses['Cash'] = cashAmount;

//     // Update other expenses based on 'Cash' category change
//     _totalRedExpense = _categoryExpenses['Shopping']! +
//         _categoryExpenses['Ride']! +
//         _categoryExpenses['Food']! +
//         _categoryExpenses['Investment']! +
//         _categoryExpenses['OTT']! +
//         _categoryExpenses['Groceries']! +
//         _categoryExpenses['UPI']! +
//         _categoryExpenses['Others']!;

//     // Update UI after category change
//     setState(() {});
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
//       double filteredDaysExpense = 0.0;

//       // Initialize category expenses map
//       _categoryExpenses = {
//         'Shopping': 0.0,
//         'Ride': 0.0,
//         'Food': 0.0,
//         'Investment': 0.0,
//         'OTT': 0.0,
//         'Groceries': 0.0,
//         'UPI': 0.0,
//         'Others': 0.0,
//       };

//       // Initialize filtered messages list
//       List<SmsMessage> filteredMessages = [];

//       for (var message in messages) {
//         if (_containsKeyword(message.body!) && !_containsOTP(message.body!)) {
//           Color textColor = _getTextColor(message.body!);

//           // Calculate expenses by category
//           String category = _getSenderName(message.body!);
//           double expense = double.parse(trimBody(message.body!) ?? '0.0');

//           // Apply the selected filters
//           var day = message.date!.day;
//           var month = DateFormat('MMMM').format(message.date!);
//           var year = DateFormat('yyyy').format(message.date!);

//           if (_selectedFilter == 'Exclude') {
//             if (month == _selectedMonth && year == _selectedYear) {
//               _updateCategoryExpense(category, textColor, expense);
//               filteredMessages.add(message); // Add message to filtered list
//             }
//           } else {
//             if ((_selectedFilter == '1' && day >= 1 && day <= 10) ||
//                 (_selectedFilter == '2' && day >= 11 && day <= 20) ||
//                 (_selectedFilter == '3' && day >= 21 && day <= 30) ||
//                 (_selectedFilter == '4' && day == 31)) {
//               if (month == _selectedMonth && year == _selectedYear) {
//                 _updateCategoryExpense(category, textColor, expense);
//                 filteredMessages.add(message); // Add message to filtered list
//               }
//             }
//           }

//           // Update total expenses based on text color
//           if (textColor == Colors.red) {
//             redExpense += expense;
//           } else if (textColor == Colors.green) {
//             greenExpense += expense;
//           }

//           // Update monthly expense based on text color
//           if (month == _selectedMonth && year == _selectedYear) {
//             if (textColor == Colors.red) {
//               monthlyExpense += expense;
//             } else if (textColor == Colors.green) {
//               monthlyExpense -= expense;
//             }
//           }

//           // Update filtered days expense based on text color and filter
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

//       setState(() {
//         _totalRedExpense = redExpense;
//         _totalGreenExpense = greenExpense;
//         _totalMonthlyExpense = monthlyExpense;
//         _totalFilteredDaysExpense = filteredDaysExpense;
//         _messages = filteredMessages; // Update messages list
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
//     for (String keyword in groceries) {
//       if (body.toLowerCase().contains(keyword.toLowerCase())) {
//         return 'GROCERIES';
//       }
//     }
//     return 'Others';
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
//     return Colors.black;
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


// String trimBody(String body) {
  //   String trimmedBody = '';
  //   int rsIndex = body.toLowerCase().indexOf(' rs. ');
  //   int rs1Index = body.toLowerCase().indexOf(' rs ');
  //   int inrIndex = body.toLowerCase().indexOf(' inr ');
  //   int inr1Index = body.toLowerCase().indexOf('inr ');
  //   int byIndex = body.toLowerCase().indexOf(' debited by ');
  //   int creditedIndex = body.toLowerCase().indexOf(' credited with rs');
  //   int forIndex = body.toLowerCase().indexOf(' debited for rs ');
  //   int sentIndex = body.toLowerCase().indexOf('sent rs.');
  //   // int salaryIndex = body.toLowerCase().indexOf(' salary of rs. ');

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
  //   } else if (inr1Index != -1) {
  //     int endIndex = body.indexOf(' ', inr1Index + 4);
  //     trimmedBody = body.substring(
  //         inr1Index + 4, endIndex != -1 ? endIndex : body.length);
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
  //   } else if (sentIndex != -1) {
  //     int endIndex = body.indexOf(' ', sentIndex + 8);
  //     trimmedBody = body.substring(
  //         sentIndex + 8, endIndex != -1 ? endIndex : body.length);
  //   }
  //   //else if (salaryIndex != -1) {
  //   //   int endIndex = body.indexOf(' ', salaryIndex + 15);
  //   //   trimmedBody = body.substring(
  //   //       salaryIndex + 15, endIndex != -1 ? endIndex : body.length);
  //   // }

  //   RegExp regex = RegExp(r'(\d+)(?:\.\d+)?');
  //   List<Match> matches = regex.allMatches(trimmedBody).toList();

  //   if (matches.isNotEmpty) {
  //     double total = 0;
  //     for (Match match in matches) {
  //       total += double.parse(match.group(0)!);
  //     }
  //     return total.toStringAsFixed(0);
  //   } else {
  //     return '0';
  //   }
  // }

  // String trimBody(String body) {
  //   String trimmedBody = '';
  //   int rsIndex = body.toLowerCase().indexOf(' rs. ');
  //   int rs1Index = body.toLowerCase().indexOf(' rs ');
  //   int inrIndex = body.toLowerCase().indexOf(' inr ');
  //   int inr1Index = body.toLowerCase().indexOf('inr ');
  //   int byIndex = body.toLowerCase().indexOf(' debited by ');
  //   int creditedIndex = body.toLowerCase().indexOf(' credited with rs');
  //   int forIndex = body.toLowerCase().indexOf(' debited for rs ');
  //   int sentIndex = body.toLowerCase().indexOf('sent rs.');
  //   int salaryIndex = body.toLowerCase().indexOf(' salary of rs. ');

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
  //   } else if (inr1Index != -1) {
  //     int endIndex = body.indexOf(' ', inr1Index + 4);
  //     trimmedBody = body.substring(
  //         inr1Index + 4, endIndex != -1 ? endIndex : body.length);
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
  //   } else if (sentIndex != -1) {
  //     int endIndex = body.indexOf(' ', sentIndex + 8);
  //     trimmedBody = body.substring(
  //         sentIndex + 8, endIndex != -1 ? endIndex : body.length);
  //   } else if (salaryIndex != -1) {
  //     int endIndex = body.indexOf(' ', salaryIndex + 15);
  //     trimmedBody = body.substring(
  //         salaryIndex + 15, endIndex != -1 ? endIndex : body.length);
  //   }

  //   RegExp otherTransactionRegex = RegExp(r'(\d+)(?:\.\d+)?');
  //   RegExp salaryRegex = RegExp(r'(\d{1,3}(,\d{3})*(\.\d+)?)');
  //   Match? otherTransactionMatch =
  //       otherTransactionRegex.firstMatch(trimmedBody);
  //   Match? salaryMatch = salaryRegex.firstMatch(trimmedBody);

  //   if (salaryMatch != null) {
  //     String salaryString = salaryMatch.group(0)!;
  //     salaryString = salaryString.replaceAll(
  //         RegExp(r','), ''); // Remove commas from salary string
  //     double salary = double.parse(salaryString);
  //     return salary
  //         .toStringAsFixed(2); // Assuming two decimal places for salary amount
  //   } else if (otherTransactionMatch != null) {
  //     double total = 0;
  //     for (Match match in otherTransactionRegex.allMatches(trimmedBody)) {
  //       total += double.parse(match.group(0)!);
  //     }
  //     return total.toStringAsFixed(0);
  //   } else {
  //     return '0';
  //   }
  // }

