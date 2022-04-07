import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:testproject/bloc/category/category_event.dart';
import 'package:testproject/bloc/category/category_state.dart';
import 'package:testproject/repos/auth_repo.dart';
import 'package:testproject/repos/category_repo.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepository categoryRepository;
  AuthRepository authRepository;

  CategoryBloc(this.categoryRepository, this.authRepository)
      : super(const CategoryInitial()) {
    on<AddCategoryPressed>(_onAddCategoryPressed);
    on<RemoveCategoryPressed>(_onRemoveCategoryPressed);
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CategoryState> emitter,
  ) async {
    await categoryRepository
        .readFromMemoryAndInitialize(authRepository.getCurrentUser());
    if (categoryRepository
        .getCategoryModelsList(authRepository.getCurrentUser())
        .isEmpty) {
      emitter(CategoryChanged(const [], authRepository.getCurrentUser()));
      return;
    }
    emitter(const CategoryInitial());

    emitter(CategoryChanged(
        categoryRepository
            .getCategoryModelsList(authRepository.getCurrentUser()),
        authRepository.getCurrentUser()));
  }

  void _onAddCategoryPressed(
      AddCategoryPressed event, Emitter<CategoryState> emitter) {
    categoryRepository.addCategoryModel(
        authRepository.getCurrentUser(), event.name, event.color);
    categoryRepository
        .writeCategoryListToMemory(authRepository.getCurrentUser());
    emitter(CategoryChanged(
        categoryRepository
            .getCategoryModelsList(authRepository.getCurrentUser()),
        authRepository.getCurrentUser()));
  }

  void _onRemoveCategoryPressed(
    RemoveCategoryPressed event,
    Emitter<CategoryState> emitter,
  ) {
    if (event.index >=
        categoryRepository
            .getCategoryModelsList(authRepository.getCurrentUser())
            .length) {
      return;
    }

    categoryRepository.removeCategoryModel(
        authRepository.getCurrentUser(), event.index);
    categoryRepository
        .writeCategoryListToMemory(authRepository.getCurrentUser());
    emitter(CategoryChanged(
        categoryRepository
            .getCategoryModelsList(authRepository.getCurrentUser()),
        authRepository.getCurrentUser()));
  }
}
