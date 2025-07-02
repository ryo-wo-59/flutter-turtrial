import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/second/third',
    routes: {
      '/': (context) => const FirstScreen(),
      '/second': (context) => const SecondScreen(),
      '/second/third': (context) => const ThirdScreen(),
    }
  ));
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){ Navigator.of(context).pushNamed('/second'); }, child: const Text("FirstからSecondへ")),
            ElevatedButton(onPressed: (){ Navigator.of(context).pushNamed('/second/third'); }, child: const Text("FirstからThirdへ"))
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){ Navigator.of(context).pushNamed('/second/third'); }, child: const Text("SecondからThirdへ")),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: const Text("戻る"))
          ],
        )
      )
    );
  }
}

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("戻る")
            ),
          ],
        )
      )
    );
  }
}