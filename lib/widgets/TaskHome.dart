import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_study/Helper/ToastHelper.dart';
import 'package:todo_list_study/colors.dart';
import 'package:todo_list_study/interfaces/ITarefaStorageService.dart';
import 'Dialog.dart';
import '../models/Tarefa.dart';
import 'TaskList.dart';

class Taskhome extends StatefulWidget {
  const Taskhome({super.key});

  @override
  State<Taskhome> createState() => _TaskhomeState();
}

class _TaskhomeState extends State<Taskhome> {
  late ITarefaStorageService _tarefaStorageService;
  List<Tarefa> _tasks = [];
  List<Tarefa> _filteredTasks = [];
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearchVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tarefaStorageService = Provider.of<ITarefaStorageService>(context);
    _loadTask();
  }

  Future<void> _loadTask() async {
    final tasks = await _tarefaStorageService.loadTarefas();
    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;

      setState(() {
        if (_tasks.isNotEmpty) {
          _isSearchVisible = true;
        } else {
          _isSearchVisible = false;
        }
      });
    });
  }

  void _addTask() async {
    Tarefa? tarefa = await showTaskFormDialog(context);
    if (tarefa == null) {
      return;
    }
    setState(() async {
      await _tarefaStorageService.saveTarefa(tarefa);
      showSuccessToast('Tarefa adicionada com sucesso');
      await _loadTask();
    });
  }

  void _deleteTask(Tarefa tarefa) {
    setState(() async {
      var result = await exibirDialogconfirmacao(
        context,
        'Deletar tarefa',
        'Deseja realmente deletar a tarefa?',
      );
      if (result == true) {
        await _tarefaStorageService.deleteTarefa(tarefa);
        showSuccessToast('Tarefa deletada com sucesso');
        await _loadTask();
      }
    });
  }

  void _updateTask(Tarefa tarefa) {
    setState(() async {
      await _tarefaStorageService.updateTarefa(tarefa);
      showSuccessToast('Tarefa atualizada com sucesso');
      await _loadTask();
    });
  }

  void _onSearch(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredTasks = _tasks;
      } else {
        _filteredTasks =
            _tasks.where((task) => task.titulo.contains(value)).toList();
      }
    });
  }

  Future<void> _onDeleteAll() async {
    var result = await exibirDialogconfirmacao(
      context,
      'Deletar todas as tarefas',
      'Deseja realmente deletar todas as tarefas?',
    );
    setState(() async {
      if (result == true) {
        await _tarefaStorageService.deleteAllTarefas();
        showSuccessToast('Todas as tarefas foram deletadas com sucesso');
        await _loadTask();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Minhas Tarefas',
          style: TextStyle(color: AppColors.backgroundColor),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: _loadTask,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  enabled: _isSearchVisible,
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar tarefa',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _onSearch,
                ),
              ),
              Expanded(
                child: Tasklist(
                  tasks: _filteredTasks,
                  onDeleteTask: _deleteTask,
                  onUpdateTask: _updateTask,
                  onSearch: _onSearch,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        foregroundColor: AppColors.backgroundColor,
        backgroundColor: AppColors.primaryColor,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_task),
            label: 'Adicionar Tarefa',
            onTap: _addTask,
          ),
          SpeedDialChild(
            child: Icon(Icons.delete_sweep),
            label: 'Deletar Todas',
            onTap: _onDeleteAll,
          ),
        ],
      ),
    );
  }
}
