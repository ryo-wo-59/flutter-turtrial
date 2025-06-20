import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: FirstScreen(),
  ));
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirstScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('number = $_number'),
            ElevatedButton(
              child: const Text('次へ'),
              onPressed: () async {
                final newNumber = await Navigator.of(context).push<int>(
                  MaterialPageRoute(
                    builder: (_) => SecondScreen(number: _number)
                  ),
                );
                setState(() {
                  if (newNumber != null) {
                    _number = newNumber;
                  }
                });
              },
            )
          ],
        ) 
      )
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IncrementScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(number + 1);
              }, 
              child: const Text('Increment')
            ),
            ElevatedButton(
              child: const Text('Dcrement'),
              onPressed: () {
                Navigator.of(context).pop(number - 1);
              },
            )
          ],
        )
      )
    );
  }
}

