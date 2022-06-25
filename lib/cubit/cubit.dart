import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/add_address_model.dart';
import 'package:shop_app/models/address_model.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_cart_model.dart';
import 'package:shop_app/models/faqs_models.dart';
import 'package:shop_app/models/favoriesGet_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/notifaction_model.dart';
import 'package:shop_app/models/proifle_model.dart';
import 'package:shop_app/modules/address/addaddress_screen.dart';
import 'package:shop_app/modules/cart/cart_screen.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/network/endpoints/end_points.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitalState());
  static ShopCubit get(context) => BlocProvider.of(context);
  HomeModel? homeModel;
  CategoriesModel? categoriesModel;
  ChangeFavoritesModel? changeFavoritesModel;
  FavoritesModel? favoritesModel;
  ProfileModel? profileModel;
  int counter = 1;
  int activeIndex = 0;
  bool isExpanded = false;
  int currentIndex = 0;
  List<Widget> bottomScreens = [
    ProductsScreen(),
    CartScreen(),
    FavoritesScreen(),
    SettingsScreen()
  ];

  void changeDarkMode(bool value) {
    isDarkmode = value;
    print(isDarkmode);
    CacheHelper.saveData(key: 'isDark', value: isDarkmode);
    emit(ChangeDarkModeState());
  }

  void changeIndicatorIndex(int index) {
    activeIndex = index;
    emit(ShopChangeIndiactorState());
  }

  void plus() {
    if (counter >= 1) {
      counter++;
      emit(PlusState());
    }
  }

  void minus() {
    if (counter <= 1) {
    } else {
      counter--;
      emit(Minustate());
    }
  }

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  void changePanel() {
    isExpanded = !isExpanded;
    emit(ShopChangeExpansionPanelState());
  }

  Map<int, bool>? favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites!.addAll({element.id!: element.inFavorites!});
        cart!.addAll({element.id!: element.inCart!});
      });

      print(favorites.toString());
      print(cart.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErorHomeDataState());
    });
  }

  void getCategoriesData() {
    DioHelper.getData(
      url: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      print(categoriesModel?.data?.data.length);
      emit(ShopSuccessCategoriesaState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  void changeFavorites(int productId) {
    favorites![productId] = !favorites![productId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
            url: FAVORITES, data: {'product_id': productId}, token: token)
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel!.status!) {
        favorites![productId] = !favorites![productId]!;
      } else {
        getFavorites();
      }

      emit(ShopSuccessFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites![productId] = !favorites![productId]!;

      emit(ShopErrorFavoritesState());
    });
  }

  Map<int, bool>? cart = {};

  ChangeCartModel? changecartModel;
  void changeCart(int productId) {
    cart![productId] = !cart![productId]!;

    emit(ShopChangeCartState());

    DioHelper.postData(url: CART, data: {'product_id': productId}, token: token)
        .then((value) {
      changecartModel = ChangeCartModel.fromJson(value.data);

      if (!changecartModel!.status!) {
        cart![productId] = !cart![productId]!;
      } else {
        getCart();
      }

      emit(ShopSuccessCartState(changecartModel!));
    }).catchError((error) {
      cart![productId] = !cart![productId]!;

      emit(ShopErrorCartState());
    });
  }

  CartModel? cartModel;

  void getCart() {
    emit(ShopLoadingGetCartState());

    DioHelper.getData(
      url: CART,
      token: token,
    ).then((value) {
      cartModel = CartModel.fromJson(value.data);
      //printFullText(value.data.toString());

      emit(ShopSuccessGetCartState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetCartState());
    });
  }

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      //printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  void getPorfile() {
    emit(ShopLoadingProfileState());
    DioHelper.getData(url: PROFILE, token: token).then((value) {
      profileModel = ProfileModel.fromJson(value.data);
      print(profileModel!.data!.email);
      emit(ShopSuccessProfileState(profileModel!));
    }).catchError((error) {
      emit(ShopErrorProfileState());
    });
  }

  void updatePorfile(
    String name,
    String email,
    String phone,
  ) {
    emit(ShopLoadingUpdateProfileState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      profileModel = ProfileModel.fromJson(value.data);

      emit(ShopSuccessUpdateProfileState(profileModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUpdateProfileState());
    });
  }

  void updatePorfileName(
    String? name,
  ) {
    emit(ShopLoadingUpdateProfileState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
      },
    ).then((value) {
      profileModel = ProfileModel.fromJson(value.data);

      emit(ShopSuccessUpdateProfileState(profileModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUpdateProfileState());
    });
  }

  FaqsModel? faqsModel;

  void getFAQs() {
    emit(ShopLoadingFAQsDataState());
    DioHelper.getData(url: FAQS, token: token).then((value) {
      faqsModel = FaqsModel.fromJson(value.data);
      emit(ShopSuccessFAQsDataState());
    }).catchError((error) {
      emit(ShopErorFAQsDataState());
    });
  }

  NotifiactionModel? notifiactionModel;

  void getNotifications() {
    emit(ShopLoadingNotificationsDataState());
    DioHelper.getData(url: NOTIFACTIONS, token: token).then((value) {
      notifiactionModel = NotifiactionModel.fromJson(value.data);
      emit(ShopSuccessNotificationsDataState());
    }).catchError((error) {
      emit(ShopErorNotificationsDataState());
    });
  }

  AddressModel? addressModel;

  void getAddress() {
    emit(ShopLoadingAddressDataState());
    DioHelper.getData(url: ADDRESS, token: token).then((value) {
      addressModel = AddressModel.fromJson(value.data);
      print(addressModel!.data!.data);
      emit(ShopSuccessAddressDataState());
    }).catchError((error) {
      emit(ShopErorAddressDataState());
    });
  }

  Future<void> refreshAddress() async {
    emit(ShopLoadingAddressDataState());
    DioHelper.getData(url: ADDRESS, token: token).then((value) {
      addressModel = AddressModel.fromJson(value.data);
      emit(ShopSuccessAddressDataState());
    }).catchError((error) {
      emit(ShopErorAddressDataState());
    });
  }

  AddAddressModel? addAddressModel;

  void addNewAddress(
      {required String? name,
      required String? city,
      required String region,
      required String? details,
      required String? notes,
      required String? latitude,
      required String? longitude}) {
    emit(ShopLoadingAddAddressDataState());
    DioHelper.postData(
      url: ADDRESS,
      token: token,
      data: {
        'name': name,
        'city': city,
        'region': region,
        'details': details,
        'notes': notes,
        'latitude': latitude,
        'longitude': longitude
      },
    ).then((value) {
      addAddressModel = AddAddressModel.fromJson(value.data);

      emit(ShopSuccessAddAddressDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErorAddAddressDataState(error.toString()));
    });
  }

  var latitude = 0.0;
  var longitude = 0.0;

  void getCurrentLocation() async {
    var postion = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    var lastPostion = await Geolocator.getLastKnownPosition();
    print(lastPostion);
    latitude = postion.latitude;
    longitude = postion.longitude;
    print(latitude);
    print(longitude);
    emit(ShopChagePostionState());
  }

  AddAddressModel? deleteeAddress;
  void deleteAddress(int? id) {
    emit(ShopLoadingDeleteAddressDataState());
    DioHelper.deleteData(url: '${DELETE_ADDRESS}$id', token: token)
        .then((value) {
      deleteeAddress = AddAddressModel.fromJson(value.data);
      print(deleteeAddress!.message);
      getAddress();
      emit(ShopSuccessDeleteAddressDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErorDeleteAddressDataState());
    });
  }

  AddAddressModel? updateeAddress;

  void updateAddress(
    String name,
    String city,
    String region,
    String details,
    String notes,
    String latitude,
    String longitude,
    int id,
  ) {
    emit(ShopLoadingUpdateAddressDataState());

    DioHelper.putData(
      url: '${DELETE_ADDRESS}$id',
      token: token,
      data: {
        'name': name,
        'city': city,
        'region': region,
        'details': details,
        'latitude': latitude,
        'longitude': longitude,
      },
    ).then((value) {
      updateeAddress = AddAddressModel.fromJson(value.data);
      print(updateeAddress!.message);
      getAddress();
      emit(ShopSuccessUpdateAddressDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErorUpdateAddressDataState());
    });
  }
}
