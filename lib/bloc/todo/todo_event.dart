import 'package:equatable/equatable.dart';
import 'package:testproject/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class FetchTodos extends TodoEvent {
  const FetchTodos();

  @override
  List<Object> get props => [];
}

class UpdateCategories extends TodoEvent {
  const UpdateCategories();

  @override
  List<Object> get props => [];
}

class SetSearchFilter extends TodoEvent {
  final String searchText;

  const SetSearchFilter({required this.searchText});

  @override
  List<Object> get props => [searchText];
}

class AddTodoPressed extends TodoEvent {
  final String text;
  final int categoryId;

  const AddTodoPressed({required this.text, required this.categoryId});

  @override
  List<Object> get props => [text, categoryId];
}

class RemoveTodoPressed extends TodoEvent {
  final int index;

  const RemoveTodoPressed({required this.index}) : assert(index >= 0);

  @override
  List<Object> get props => [index];
}

class SortByCategory extends TodoEvent {
  const SortByCategory();

  @override
  List<Object> get props => [];
}

class SortByText extends TodoEvent {
  const SortByText();

  @override
  List<Object> get props => [];
}
