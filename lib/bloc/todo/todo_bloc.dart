import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:testproject/bloc/todo/todo_event.dart';
import 'package:testproject/bloc/todo/todo_state.dart';
import 'package:testproject/models/todo_model.dart';
import 'package:testproject/repos/auth_repo.dart';
import 'package:testproject/repos/category_repo.dart';
import 'package:testproject/repos/todo_repo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoRepository todoRepository;
  AuthRepository authRepository;
  CategoryRepository categoryRepository;

  String _searchFilter = "";

  TodoBloc(
    this.todoRepository,
    this.authRepository,
    this.categoryRepository,
  ) : super(const TodoInitial()) {
    on<AddTodoPressed>(_onAddTodoPressed);
    on<RemoveTodoPressed>(_onRemoveTodoPressed);
    on<FetchTodos>(_onFetchTodos);
    on<UpdateCategories>(_onUpdateCategories);
    on<SortByCategory>(_sortByCategory);
    on<SortByText>(_sortByText);
    on<SetSearchFilter>(_setSearchFilter);
  }

  Future<void> _onFetchTodos(
    FetchTodos event,
    Emitter<TodoState> emitter,
  ) async {
    final user = authRepository.getCurrentUser();
    await todoRepository.readFromMemoryAndInitialize(user);
    await categoryRepository.readFromMemoryAndInitialize(user);
    final todoModelsList = todoRepository.getTodoModelsList(user);
    if (todoModelsList.isEmpty) {
      emitter(TodoChanged(
        const [],
        user,
        categoryRepository.getCategoryModelsList(user),
      ));
      return;
    }
    _emitDefault(emitter);
  }

  void _onUpdateCategories(UpdateCategories event, Emitter<TodoState> emitter) {
    _emitDefault(emitter);
  }

  void _onAddTodoPressed(AddTodoPressed event, Emitter<TodoState> emitter) {
    if (event.text == "") {
      return;
    }
    final user = authRepository.getCurrentUser();
    todoRepository.addTodoModel(
      user,
      TodoModel(todoText: event.text, categoryId: event.categoryId),
    );
    todoRepository.writeTodoListToMemory(user);
    _emitDefault(emitter);
  }

  void _onRemoveTodoPressed(
    RemoveTodoPressed event,
    Emitter<TodoState> emitter,
  ) {
    final user = authRepository.getCurrentUser();
    final todoModelsList = todoRepository.getTodoModelsList(user);
    if (event.index >= todoModelsList.length) {
      return;
    }

    todoRepository.removeTodoModel(user, event.index);
    todoRepository.writeTodoListToMemory(user);
    _emitDefault(emitter);
  }

  void _sortByCategory(
    SortByCategory event,
    Emitter<TodoState> emitter,
  ) {
    todoRepository.sortByCategories(authRepository.getCurrentUser());
    _emitDefault(emitter);
  }

  void _sortByText(
    SortByText event,
    Emitter<TodoState> emitter,
  ) {
    todoRepository.sortByText(authRepository.getCurrentUser());
    _emitDefault(emitter);
  }

  void _setSearchFilter(SetSearchFilter event, Emitter<TodoState> emitter) {
    _searchFilter = event.searchText;
    _emitDefault(emitter);
  }

  List<TodoModel> _filterTodos(List<TodoModel> list, String searchText) {
    List<TodoModel> newList = [];

    if (searchText.isEmpty) {
      return list;
    }

    for (final model in list) {
      if (model.todoText.contains(searchText)) {
        newList.add(model);
      }
    }

    return [...newList];
  }

  void _emitDefault(Emitter<TodoState> emitter) {
    final user = authRepository.getCurrentUser();
    emitter(TodoChanged(
      _filterTodos(todoRepository.getTodoModelsList(user), _searchFilter),
      user,
      categoryRepository.getCategoryModelsList(user),
    ));
  }
}
