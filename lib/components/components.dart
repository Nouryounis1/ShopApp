import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/models/favoriesGet_model.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

Widget defaultButton(
        {double width = double.infinity,
        Color backgroundColor = Colors.blue,
        required VoidCallback onPressed,
        bool isUppercase = true,
        double radius = 0,
        required String text}) =>
    Container(
      height: 50.0,
      width: width,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUppercase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(radius)),
    );

Widget defaultFormField(
        {@required TextEditingController? controller,
        @required TextInputType? type,
        @required String? label,
        @required IconData? prefix,
        IconData? suffix,
        bool isPassword = false,
        @required String? validateText,
        dynamic onSubmmit,
        Function()? sufixPressed,
        bool isClicable = true}) =>
    TextFormField(
      controller: controller,
      style: !CacheHelper.getData(key: 'isDark')
          ? TextStyle(color: Colors.black)
          : TextStyle(color: Colors.white),
      onFieldSubmitted: onSubmmit,
      validator: (value) {
        if (value!.isEmpty) {
          return validateText;
        }
        return null;
      },
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClicable,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: !CacheHelper.getData(key: 'isDark')
                ? BorderSide(color: Colors.grey)
                : BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: defaultColor)),
        labelText: label,
        labelStyle: !CacheHelper.getData(key: 'isDark')
            ? TextStyle(color: Colors.grey)
            : TextStyle(color: Colors.white),
        prefixIcon: !CacheHelper.getData(key: 'isDark')
            ? Icon(
                prefix,
                color: Colors.grey,
              )
            : Icon(
                prefix,
                color: Colors.white,
              ),
        suffixIcon: IconButton(
          icon: !CacheHelper.getData(key: 'isDark')
              ? Icon(
                  suffix,
                  color: Colors.grey,
                )
              : Icon(
                  suffix,
                  color: Colors.white,
                ),
          onPressed: sufixPressed,
        ),
      ),
    );

Widget defaultTextButton({
  required VoidCallback onPressed,
  @required String? text,
}) =>
    TextButton(onPressed: onPressed, child: Text(text!));

void showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget myDivider() => Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(children: <Widget>[
        Expanded(
            child: Divider(
          color: Colors.grey[500],
        ))
      ]),
    );

Widget buildListProduct(
  model,
  context, {
  bool isOldPrice = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage('${model.image}'),
                  width: 120.0,
                  height: 120.0,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          model.oldPrice.toString(),
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id!);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              ShopCubit.get(context).favorites![model.id!]!
                                  ? defaultColor
                                  : Colors.grey,
                          child: Icon(
                            Icons.favorite_border,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

class EasyCard extends StatelessWidget {
  final Color prefixBadge;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color titleColor;
  final Color descriptionColor;

  const EasyCard(
    this.prefixBadge,
    this.title,
    this.description,
    this.backgroundColor,
    this.descriptionColor,
    this.titleColor,
  ) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {},
        child: Card(
          color: (this.backgroundColor != null)
              ? this.backgroundColor
              : Colors.white,
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              (this.prefixBadge != null)
                  ? Container(
                      width: 10.0,
                      height: 60.0,
                      color: this.prefixBadge,
                    )
                  : Container(
                      margin: const EdgeInsets.only(left: 20.0),
                    ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      (this.title != null)
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                this.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                    color: (this.titleColor != null)
                                        ? this.titleColor
                                        : Colors.black),
                              ),
                            )
                          : Container(),
                      (this.description != null)
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                this.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 13.0,
                                    color: (this.descriptionColor != null)
                                        ? this.descriptionColor
                                        : Colors.black87),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget Background(context) => Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/images/top1.png",
                width: MediaQuery.of(context).size.width),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/images/top2.png",
                width: MediaQuery.of(context).size.width),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/bottom1.png",
                width: MediaQuery.of(context).size.width),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/bottom2.png",
                width: MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
