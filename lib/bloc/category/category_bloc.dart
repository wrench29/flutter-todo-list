import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:testproject/bloc/category/category_event.dart';
import 'package:testproject/bloc/category/category_state.dart';
import 'package:testproject/repos/auth_repo.dart';
import 'package:testproject/repos/category_repo.dart';
import 'package:testproject/repos/todo_repo.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepository categoryRepository;
  AuthRepository authRepository;
  TodoRepository todoRepository;

  CategoryBloc(
      this.categoryRepository, this.authRepository, this.todoRepository)
      : super(const CategoryInitial()) {
    on<AddCategoryPressed>(_onAddCategoryPressed);
    on<RemoveCategoryPressed>(_onRemoveCategoryPressed);
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CategoryState> emitter,
  ) async {
    final user = authRepository.getCurrentUser();
    final categoryModelsList = categoryRepository.getCategoryModelsList(user);
    if (categoryModelsList.isEmpty) {
      emitter(CategoryChanged(const [], user));
      return;
    }
    emitter(CategoryChanged(categoryModelsList, user));
  }

  void _onAddCategoryPressed(
      AddCategoryPressed event, Emitter<CategoryState> emitter) {
    final user = authRepository.getCurrentUser();
    categoryRepository.addCategoryModel(user, event.name, event.color);
    categoryRepository.writeCategoryListToMemory(user);
    emitter(
        CategoryChanged(categoryRepository.getCategoryModelsList(user), user));
  }

  void _onRemoveCategoryPressed(
    RemoveCategoryPressed event,
    Emitter<CategoryState> emitter,
  ) {
    final user = authRepository.getCurrentUser();
    final categoryModelsList = categoryRepository.getCategoryModelsList(user);
    if (event.index >= categoryModelsList.length) {
      return;
    }

    categoryRepository.removeCategoryModel(user, event.index);
    categoryRepository.writeCategoryListToMemory(user);
    emitter(CategoryChanged(categoryModelsList, user));
  }
}
