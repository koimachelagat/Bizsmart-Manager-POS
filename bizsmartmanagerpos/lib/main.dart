import 'package:flutter/material.dart';

void main() {
  runApp(const BizsmartApp());
}

class BizsmartApp extends StatelessWidget {
  const BizsmartApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biz Smart Manager',
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        body: Center(
          child: Text('Welcome to Biz Smart Manager!')
        ),
      ),
    );
  }
}
   