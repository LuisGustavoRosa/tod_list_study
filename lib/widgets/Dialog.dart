import 'package:flutter/material.dart';
import 'package:todo_list_study/colors.dart';
import 'package:todo_list_study/models/Tarefa.dart';

Future<bool> exibirDialogconfirmacao(
  BuildContext context,
  String titulo,
  String mensagem,
) async {
  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Não', style: TextStyle(color: AppColors.textColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Sim', style: TextStyle(color: AppColors.textColor)),
          ),
        ],
      );
    },
  );

  return result;
}

Future<Tarefa?> showTaskFormDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  bool _isCompleted = false;

  Tarefa? tarefa = await showDialog<Tarefa>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Adicionar Tarefa'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Título da Tarefa'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    activeColor: AppColors.primaryColor,
                    title: Text('Está concluída?'),
                    value: _isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCompleted = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.textColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final String title = _titleController.text;
                    final bool isCompleted = _isCompleted;
                    final tarefa = Tarefa(titulo: title, concluida: isCompleted);
                    Navigator.of(context).pop(tarefa);
                  }
                },
                child: Text('Adicionar', style: TextStyle(color: AppColors.backgroundColor)),
              ),
            ],
          );
        },
      );
    },
  );

  return tarefa;
}
