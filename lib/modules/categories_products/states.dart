import 'package:shop_app/models/favorites_model.dart';

abstract class CategoryProductsStates {}

class CategoryProductsInitalState extends CategoryProductsStates {}

class CategoryProductsLoadingState extends CategoryProductsStates {}

class CategoryProductsSucessState extends CategoryProductsStates {}

class CategoryProductsErrorState extends CategoryProductsStates {}

class CategoryChangeFavoritesState extends CategoryProductsStates {}

class CategorySuccessFavoritesState extends CategoryProductsStates {
  final ChangeFavoritesModel model;
  CategorySuccessFavoritesState(this.model);
}

class CategorypErrorFavoritesState extends CategoryProductsStates {}

class CategoryLoadingGetFavoritesState extends CategoryProductsStates {}

class CategorySuccessGetFavoritesState extends CategoryProductsStates {}

class CategoryErrorGetFavoritesState extends CategoryProductsStates {}
