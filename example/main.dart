import 'package:flutter/material.dart';
import 'package:integrate_platform/integrate_platform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data = 'None';
  String path = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(IntegratePlatform.operatingSystemVersion)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(data),
          ElevatedButton(
            child: const Text("Write to File"),
            onPressed: () async {
              final result =
                  await IntegratePlatform.writeFile("hello world", "hello.txt");
              path = result.path.toString();
              setState(() {});
            },
          ),
          Text(path),
          ElevatedButton(
            child: const Text("Read a File"),
            onPressed: () async {
              final result = await IntegratePlatform.readFile();
              if (result.success) {
                data = result.content.toString();
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
