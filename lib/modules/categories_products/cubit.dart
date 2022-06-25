import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/models/categories_products_model.dart';
import 'package:shop_app/models/favoriesGet_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories_products/states.dart';
import 'package:shop_app/network/endpoints/end_points.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsStates> {
  CategoryProductsCubit() : super(CategoryProductsInitalState());
  CategoryProductsModel? categoryProductsModel;
  static CategoryProductsCubit get(context) => BlocProvider.of(context);

  ChangeFavoritesModel? changeFavoritesModel;
  FavoritesModel? favoritesModel;

  void getCatProductsData(int id, context) {
    emit(CategoryProductsLoadingState());
    print('$CATEGORY_PRODUCTS$id');
    DioHelper.getData(url: '$CATEGORY_PRODUCTS$id', token: token).then((value) {
      categoryProductsModel = CategoryProductsModel.fromJson(value.data);
      categoryProductsModel!.data!.data!.forEach((element) {
        ShopCubit.get(context)
            .favorites!
            .addAll({element.id!: element.inFavorites!});
      });

      print(ShopCubit.get(context).favorites.toString());
      print(ShopCubit.get(context).favorites.toString());

      emit(CategoryProductsSucessState());
    }).catchError((error) {
      print(error.toString());
      emit(CategoryProductsErrorState());
    });
  }

  void changeFavorites(int productId, context) {
    ShopCubit.get(context).favorites![productId] =
        !ShopCubit.get(context).favorites![productId]!;

    emit(CategoryChangeFavoritesState());

    DioHelper.postData(
            url: FAVORITES, data: {'product_id': productId}, token: token)
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel!.status!) {
        ShopCubit.get(context).favorites![productId] =
            !ShopCubit.get(context).favorites![productId]!;
      } else {
        ShopCubit.get(context).getFavorites();
      }

      emit(CategorySuccessFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      ShopCubit.get(context).favorites![productId] =
          !ShopCubit.get(context).favorites![productId]!;

      emit(CategorypErrorFavoritesState());
    });
  }
}
