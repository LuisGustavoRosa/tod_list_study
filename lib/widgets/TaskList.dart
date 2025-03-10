import 'package:flutter/material.dart';
import 'package:todo_list_study/colors.dart';
import 'package:todo_list_study/models/Tarefa.dart';

class Tasklist extends StatelessWidget {
  final List<Tarefa> tasks;
  final Function(Tarefa) onDeleteTask;
  final Function(Tarefa) onUpdateTask;
  final Function(String) onSearch;

  const Tasklist({super.key, required this.tasks, required this.onDeleteTask, required this.onUpdateTask, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children:
                tasks.map((tarefa) {
                  return ListTile(
                    title: Text(tarefa.titulo),
                    trailing: SizedBox(
                      width: 100, // Ajuste o tamanho conforme necessário
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(value: tarefa.concluida, activeColor: AppColors.primaryColor, onChanged: (value) {
                            tarefa.concluida = value!;
                            onUpdateTask(tarefa);
                          }),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              onDeleteTask(tarefa);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
