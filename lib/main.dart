import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialmedia_app/Bloc_Observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/layout/Home_Layout.dart';
import 'package:socialmedia_app/modules/Login_Screen.dart';
import 'package:socialmedia_app/shared/components/constants.dart';
import 'package:socialmedia_app/shared/network/local/Cache_Helper.dart';
import 'package:socialmedia_app/shared/network/remote/Dio_Helper.dart';
import 'package:socialmedia_app/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'layout/Layout_Cubit/cubit.dart';
import 'modules/Login_Cubit/cubit.dart';
import 'modules/Register_Cubit/cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
 main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await CacheHelper.init();
   await DioHelper.init();
    await Firebase.initializeApp();
   //  var token = await FirebaseMessaging.instance.getToken();
   //  FirebaseMessaging.onMessage.listen((event) {
   //    print(event.data.toString());
   //  });
   // FirebaseMessaging.onMessageOpenedApp.listen((event) {
   //   print(event.data.toString());
   // });
   //
   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   //
   //  print(token);
    Bloc.observer = MyBlocObserver();
   uID = CacheHelper.GetData(key: 'uID');
   Widget StartWidget;
    if(uID == null){
      StartWidget = Login_Screen();
    }else{
      StartWidget = Home_Layout();
    }
    runApp(Phoenix(child: MyApp(StartWidget)));
}

class MyApp extends StatelessWidget {
    Widget startWidget;
   MyApp(
       this.startWidget,
       );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (BuildContext context) => RegisterCubit()),
        BlocProvider(create: (BuildContext context) => LayoutCubit()..GetUserData()..GetPosts()..GetAllUsersIncludingMe()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: LightTheme,
        home: startWidget,
      ),
    );
  }
}



