import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_study/services/TarefaStorageService.dart';
import 'package:todo_list_study/widgets/TaskHome.dart';

import 'interfaces/ITarefaStorageService.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ITarefaStorageService>(
          create: (_) => TarefaStorageService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Taskhome(),
    );
  }
}
