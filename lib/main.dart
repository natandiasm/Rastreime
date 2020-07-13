import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/home_screen.dart';
import 'package:rastreimy/screens/order_detail.dart';
import 'package:rastreimy/util/themeData_util.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statusbar/statusbar.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'loja',
      'store',
      'venda',
      'eletronico',
      'smartphone',
      'shop',
      'tenis'
    ],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    nonPersonalizedAds: false,
    testDevices: <String>["24C631C52CF80D836BDF8824C1088486"],
  );

  BannerAd myBanner;

  void startBanner() {
    myBanner = BannerAd(
      adUnitId: "ca-app-pub-6043006820068692/5608481609",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.opened) {}
      },
    );
  }

  void showBanner() {
    myBanner
      ..load()
      ..show(
        anchorOffset: 00.0,
        horizontalCenterOffset: 00.0,
        anchorType: AnchorType.bottom,
      );
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6043006820068692~9899327824");
    startBanner();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch");
        if (message['data']['click_action'] == 'FLUTTER_NOTIFICATION_CLICK') {
          await Future.delayed(Duration(seconds: 1));
          OrderModel.getOrderById(id: message['data']['idOrder'], onFail: () {})
              .then((data) {
            Get.to(OrderDetailScreen(
              orderData: data,
            ));
          });
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume");
        if (message['data']['click_action'] == 'FLUTTER_NOTIFICATION_CLICK') {
          await Future.delayed(Duration(seconds: 1));
          OrderModel.getOrderById(id: message['data']['idOrder'], onFail: () {})
              .then((data) {
            Get.to(OrderDetailScreen(
              orderData: data,
            ));
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    StatusBar.color(Color.fromARGB(255, 32, 57, 204));
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ScopedModel<UserModel>(
            model: UserModel(),
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Rastreimy',
              theme: ThemeDataUtil.themeDefault(),
              darkTheme: ThemeDataUtil.themeDark(),
              themeMode: snapshot.data.getBool("themeDark") == null
                  ? ThemeMode.system
                  : snapshot.data.getBool("themeDark")
                      ? ThemeMode.dark
                      : ThemeMode.light,
              home: home(snapshot),
            ),
          );
        } else {
          return Center(
            child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.white,
                child: Image.asset(
                  'assets/images/title.png',
                  fit: BoxFit.fill,
                )),
          );
        }
      },
    );
  }

  Widget home(snapshot) {
    if (snapshot.data.getBool("tutorial") == null ||
        snapshot.data.getBool("tutorial") == true) {
      List<Slide> slides = new List();
      slides.add(
        new Slide(
          title: "Arraste e veja.",
          styleTitle: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          centerWidget: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.black26.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5)),
            child: FlareActor("assets/flare/tutorial-screen-1.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "play"),
          ),
          description:
              "Arraste para o lado e os botões de excluir e editar sua encomenda aparecem.",
          styleDescription: TextStyle(color: Colors.black, fontSize: 18),
          backgroundColor: Colors.white,
        ),
      );
      slides.add(
        new Slide(
          title: "Modo Escuro",
          styleTitle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          description:
              "Com um toque você alterna entre o modo escuro e o modo claro.",
          styleDescription: TextStyle(fontSize: 18),
          centerWidget: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.black26.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5)),
            child: FlareActor("assets/flare/tutorial-screen-2.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "play"),
          ),
          backgroundColor: Colors.black,
        ),
      );
      slides.add(
        new Slide(
          title: "Pronto",
          styleTitle: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          centerWidget: Container(
            width: 300,
            height: 300,
            child: Image.asset(
              'assets/images/ok-sucess.png',
              fit: BoxFit.cover,
            ),
          ),
          description: "Você já pode usar o melhor aplicativo de rastreamento.",
          styleDescription: TextStyle(color: Colors.white, fontSize: 18),
          backgroundColor: Color.fromARGB(255, 32, 57, 204),
        ),
      );
      return IntroSlider(
        slides: slides,
        colorPrevBtn: Color.fromARGB(255, 32, 57, 204),
        colorSkipBtn: Color.fromARGB(255, 32, 57, 204),
        isShowNextBtn: false,
        colorDot: Color.fromARGB(255, 32, 57, 204).withOpacity(0.2),
        colorActiveDot: Color.fromARGB(255, 32, 57, 204),
        nameDoneBtn: "Começar",
        nameSkipBtn: "Pular",
        onDonePress: () {
          showBanner();
          snapshot.data.setBool("tutorial", false);
          Get.to(HomeScreen());
        },
      );
    } else {
      showBanner();
      return SplashScreen.navigate(
        name: 'assets/flare/splash-screen.flr',
        next: (_) => HomeScreen(),
        backgroundColor: Colors.white,
        fit: BoxFit.cover,
        until: () => Future.delayed(Duration(seconds: 0)),
        startAnimation: 'play',
      );
    }
  }
}

void main() => runApp(MyApp());
