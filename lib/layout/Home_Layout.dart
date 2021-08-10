import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/modules/Login_Screen.dart';
import 'package:socialmedia_app/modules/New_Post.dart';
import 'package:socialmedia_app/modules/RefreshWidget.dart';
import 'package:socialmedia_app/modules/chats.dart';
import 'package:socialmedia_app/modules/feeds.dart';
import 'package:socialmedia_app/modules/notifcations.dart';
import 'package:socialmedia_app/modules/search.dart';
import 'package:socialmedia_app/modules/settings.dart';
import 'package:socialmedia_app/modules/users.dart';
import 'package:socialmedia_app/shared/components/components.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:socialmedia_app/shared/components/constants.dart';
import 'package:socialmedia_app/shared/network/local/Cache_Helper.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'Layout_Cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
class Home_Layout extends StatefulWidget {

  @override
  _Home_LayoutState createState() => _Home_LayoutState();
}

class _Home_LayoutState extends State<Home_Layout> {
  int currentindex = 0;
  bool isverified = FirebaseAuth.instance.currentUser.emailVerified;
  List<Widget> Screens = [
    Feeds_Screen(),
    Chats_Screen(),
    New_Post(),
    Users_Screen(),
    Settings_Screen()
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'New Post',
    'Users',
    'Settings'
  ];
  // dynamic Build(){
  //   return Container(
  //     color: Colors.amber.withOpacity(0.6),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       child: Row(
  //         children: [
  //           Icon(Icons.info_outline),
  //           SizedBox(width: 15,),
  //           Expanded(child: Text('Please Verify Your Email!')),
  //           SizedBox(width: 20,),
  //           TextButton(onPressed: (){
  //             FirebaseAuth.instance.currentUser.sendEmailVerification().then((value) {
  //               DefaultToast(message: 'Check Your Mail!', fontsize: 14,Backgroundcolor: Colors.orangeAccent);
  //             });
  //           }, child: Text('Verify Now!'),),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocConsumer<LayoutCubit,Home_States>(
        listener: (context,state) {},
        builder: (context,state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                titles[currentindex],
                style: TextStyle(
                  fontFamily: 'Shitman',
                ),
              ),
              actions: [
              ],
            ),
            body: ConditionalBuilder(
              condition: LayoutCubit.get(context).usermodel != null,
              builder: (context) {
                if(isverified == false){
                  return Column(
                    children: [
                      Container(
                        color: Colors.amber.withOpacity(0.6),
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline),
                              SizedBox(width: 15,),
                              Expanded(child: Text('Verify Your Email!')),
                              Column(
                                children: [
                                  Expanded(
                                    child: TextButton(onPressed: (){
                                      FirebaseAuth.instance.currentUser.sendEmailVerification().then((value) {
                                        DefaultToast(message: 'Check Your Mail!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
                                      }).catchError((error){
                                        DefaultToast(message: error.toString(), fontsize: 12,Backgroundcolor: Colors.grey[500]);
                                      });
                                    }, child: Text('Verify Now!',style: TextStyle(color: Colors.grey[500]),),),
                                  ),
                                  Expanded(
                                    child: TextButton(child: Text('Already Verified?',style: TextStyle(color: Colors.grey[500])),onPressed: (){
                                      setState(() {
                                        FirebaseAuth.instance.currentUser.reload();
                                        isverified = FirebaseAuth.instance.currentUser.emailVerified;
                                      });
                                    }),
                                  ),
                                ],
                              ),
                            ],

                          ),
                        ),

                      ),
                      SizedBox(height: 200,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(onPressed: (){
                                uIDmy = CacheHelper.sharedPreferences.get('uID');
                                CacheHelper.sharedPreferences.clear().then((value) async{
                                  await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login_Screen()), (route) => false).then((value) {
                                    Future.delayed(Duration(seconds: 2));
                                    Phoenix.rebirth(context);
                                  });
                                });
                                if(uIDmy != null){
                                  return null;
                                }else{
                                  Phoenix.rebirth(context);
                                }
                              }, child: Text('Sign Out')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }else{
                  return Screens[currentindex];
                }
                },
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
              BottomNavigationBarItem(icon: Icon(IconBroken.Home),label: 'Home'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Chat),label: 'Chats'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Paper_Upload),label: 'Post'),
              BottomNavigationBarItem(icon: Icon(IconBroken.User),label: 'Users'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Setting),label: 'Settings'),
            ],
              currentIndex: currentindex,
              onTap: (int index){
                setState(() {
                  if(index == 1 || index == 0)
                    LayoutCubit.get(context).GetAllUsers();
                  LayoutCubit.get(context).GetAllUsersIncludingMe();
                  if(index == 2){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => New_Post()));
                  }else{
                    currentindex = index;
                  }
                });
              },
            ),
          );
        },

    );
  }
}
