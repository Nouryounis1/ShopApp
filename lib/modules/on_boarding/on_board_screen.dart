import 'package:flutter/material.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String tittle;
  final String body;
  BoardingModel(
      {required this.image, required this.tittle, required this.body});
}

class onBoardingScreen extends StatefulWidget {
  @override
  _onBoardingScreenState createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/splash_1.png',
        tittle: 'Welcome',
        body: 'Welcome to Salaa, Let’s shop!'),
    BoardingModel(
        image: 'assets/images/splash_2.png',
        tittle: 'Support',
        body: 'We help people conect with store \naround the world'),
    BoardingModel(
        image: 'Shopping',
        tittle: 'We show the easy way to shop. \nJust stay at home with us"',
        body: 'On Board 3 Body'),
  ];
  bool isLast = false;

  var boardController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            defaultTextButton(
                onPressed: () {
                  submit();
                },
                text: 'SKIP')
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                  child: PageView.builder(
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                controller: boardController,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              )),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5.0,
                      activeDotColor: defaultColor,
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        boardController.nextPage(
                            duration: Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Image(
            image: AssetImage('${model.image}'),
          )),
          Text(
            '${model.tittle}',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            '${model.body}',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      );

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value) {
        navigateAndFinish(
          context,
          LoginScreen(),
        );
      }
    });
  }
}
