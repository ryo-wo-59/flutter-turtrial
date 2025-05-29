import 'package:flutter/material.dart';

import 'first_page.dart';

class SecondPage extends StatelessWidget{
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("次のページ"),
            IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              icon: const Icon(Icons.arrow_back))
        ],)
      ),
    );
  }
}