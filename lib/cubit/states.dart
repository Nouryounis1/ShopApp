import 'package:shop_app/models/address_model.dart';
import 'package:shop_app/models/change_cart_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/proifle_model.dart';

abstract class ShopStates {}

class ShopInitalState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ChangeDarkModeState extends ShopStates {}

class ShopChangeIndiactorState extends ShopStates {}

class ShopChangeExpansionPanelState extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesaState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

class ShopSuccessFavoritesState extends ShopStates {
  final ChangeFavoritesModel model;
  ShopSuccessFavoritesState(this.model);
}

class ShopChangeFavoritesState extends ShopStates {}

class ShopErrorFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessProfileState extends ShopStates {
  final ProfileModel model;
  ShopSuccessProfileState(this.model);
}

class ShopErrorProfileState extends ShopStates {}

class ShopLoadingProfileState extends ShopStates {}

class ShopSuccessUpdateProfileState extends ShopStates {
  final ProfileModel model;
  ShopSuccessUpdateProfileState(this.model);
}

class ShopErrorGetUpdateProfileState extends ShopStates {}

class ShopLoadingUpdateProfileState extends ShopStates {}

class PlusState extends ShopStates {}

class Minustate extends ShopStates {}

class ShopLoadingFAQsDataState extends ShopStates {}

class ShopSuccessFAQsDataState extends ShopStates {}

class ShopErorFAQsDataState extends ShopStates {}

class ShopLoadingNotificationsDataState extends ShopStates {}

class ShopSuccessNotificationsDataState extends ShopStates {}

class ShopErorNotificationsDataState extends ShopStates {}

class ShopLoadingAddressDataState extends ShopStates {}

class ShopSuccessAddressDataState extends ShopStates {}

class ShopErorAddressDataState extends ShopStates {}

class ShopLoadingAddAddressDataState extends ShopStates {}

class ShopSuccessAddAddressDataState extends ShopStates {}

class ShopErorAddAddressDataState extends ShopStates {
  final String error;

  ShopErorAddAddressDataState(this.error);
}

class ShopChagePostionState extends ShopStates {}

class ShopLoadingDeleteAddressDataState extends ShopStates {}

class ShopSuccessDeleteAddressDataState extends ShopStates {}

class ShopErorDeleteAddressDataState extends ShopStates {}

class ShopLoadingUpdateAddressDataState extends ShopStates {}

class ShopSuccessUpdateAddressDataState extends ShopStates {}

class ShopErorUpdateAddressDataState extends ShopStates {}

class ShopSuccessCartState extends ShopStates {
  final ChangeCartModel model;
  ShopSuccessCartState(this.model);
}

class ShopChangeCartState extends ShopStates {}

class ShopErrorCartState extends ShopStates {}

class ShopSuccessGetCartState extends ShopStates {}

class ShopErrorGetCartState extends ShopStates {}

class ShopLoadingGetCartState extends ShopStates {}
