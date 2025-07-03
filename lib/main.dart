import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    MaterialApp.router(
      routerConfig: _router,
    )
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FirstScreen(),
      routes: [
        GoRoute(
          path: 'second',
          builder: (context, state) => const SecondScreen(),
          routes: [
            GoRoute(
              path: '/third',
              builder: (context, state) => const ThirdScreen()
            )
          ]
        )
      ]
    ),
    // GoRoute(
    //   path: '/second',
    //   builder: (context, state) => const SecondScreen(),
    // ),
    // GoRoute(
    //   path: '/third',
    //   builder: (context, state) => const ThirdScreen(),
    // ),
  ],
);

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
            ElevatedButton(onPressed: (){ GoRouter.of(context).push('/'); }, child: const Text("FirstからFirstへ")),
            ElevatedButton(onPressed: (){ GoRouter.of(context).push('/second'); }, child: const Text("FirstからSecondへ")),
            ElevatedButton(onPressed: (){ GoRouter.of(context).go('/second/third'); }, child: const Text("FirstからThirdへ"))
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
            ElevatedButton(onPressed: (){ GoRouter.of(context).push('/second'); }, child: const Text("SecondからSecondへ")),
            ElevatedButton(onPressed: (){ GoRouter.of(context).push('/second/third'); }, child: const Text("SecondからThirdへ")),
            ElevatedButton(onPressed: (){
              GoRouter.of(context).pop();
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
              GoRouter.of(context).pop();
            },
            child: const Text("戻る")
            ),
          ],
        )
      )
    );
  }
}