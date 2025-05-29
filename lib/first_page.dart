import 'package:flutter/material.dart';

import 'second_page.dart';

class FirstPage extends StatelessWidget{
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("最初のページ"),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SecondPage(),
                  ),
                );
              }, 
              icon: const Icon(Icons.arrow_forward))
        ],)
      ),
    );
  }
}