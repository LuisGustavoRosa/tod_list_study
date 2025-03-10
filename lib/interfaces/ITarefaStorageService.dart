import 'package:todo_list_study/models/Tarefa.dart';

abstract class ITarefaStorageService {
  Future<void> saveTarefa(Tarefa tarefa);
  Future<List<Tarefa>> loadTarefas();
  Future<void> deleteTarefa(Tarefa tarefa);
  Future<void> updateTarefa(Tarefa tarefa);
  Future<void> deleteAllTarefas();
}