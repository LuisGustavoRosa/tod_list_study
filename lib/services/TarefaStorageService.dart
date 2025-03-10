import 'package:todo_list_study/interfaces/ITarefaStorageService.dart';
import 'package:todo_list_study/models/Tarefa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TarefaStorageService implements ITarefaStorageService {
  @override
  Future<void> saveTarefa(Tarefa tarefa) async {
    final prefs = await SharedPreferences.getInstance();
    final tarefas = await loadTarefas();
    tarefas.add(tarefa);
    final tarefasJson = jsonEncode(tarefas.map((t) => t.toJson()).toList());
    await prefs.setString('tarefas', tarefasJson);
  }

  @override
  Future<List<Tarefa>> loadTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    final tarefasJson = prefs.getString('tarefas');
    if (tarefasJson != null) {
      final List<dynamic> tarefasList = jsonDecode(tarefasJson);
      return tarefasList.map((json) => Tarefa.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> deleteTarefa(Tarefa tarefa) async {
    final prefs = await SharedPreferences.getInstance();
    final tarefas = await loadTarefas();
    final novasTarefa = tarefas.where((t) => t.titulo != tarefa.titulo).toList();
    final tarefasJson = jsonEncode(novasTarefa.map((t) => t.toJson()).toList());
    await prefs.setString('tarefas', tarefasJson);
  }

  @override
  Future<void> updateTarefa(Tarefa tarefa) async {
    final prefs = await SharedPreferences.getInstance();
    final tarefas = await loadTarefas();
    final index = tarefas.indexWhere((t) => t.titulo == tarefa.titulo);
    tarefas[index] = tarefa;
    final tarefasJson = jsonEncode(tarefas.map((t) => t.toJson()).toList());
    await prefs.setString('tarefas', tarefasJson);
  }

  @override
  Future<void> deleteAllTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tarefas');
  }



}