// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:socialmedia_app/modules/Login_Screen.dart';
//
// import 'feeds.dart';
// class AuthService{
//   handleauth(){
//     return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
//     builder: (context,snapshot){
//       if(snapshot.hasData){
//         return Feeds_Screen();
//       }else{
//         return Login_Screen();
//       }
//     }
//     ,);
//
//
//   }
//   signin(AuthCredential authCredential){
//     FirebaseAuth.instance.signInWithCredential(authCredential);
//   }
// }