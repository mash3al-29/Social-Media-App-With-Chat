import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/modules/Login_Screen.dart';
import 'package:socialmedia_app/shared/components/components.dart';
import 'package:socialmedia_app/shared/components/constants.dart';
import 'package:socialmedia_app/shared/network/local/Cache_Helper.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
class New_Post extends StatefulWidget {
  @override
  _New_PostState createState() => _New_PostState();
}

class _New_PostState extends State<New_Post> {
  TextEditingController textcontroller = TextEditingController();

  var now = DateTime.now();

  var formkey = GlobalKey<FormState>();

  bool isverified = FirebaseAuth.instance.currentUser.emailVerified;

  @override
  Widget build(BuildContext context) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
    return BlocConsumer<LayoutCubit, Home_States>(
      listener: (context, state) {
        if(state is SocialCreatePostSuccessState){
          DefaultToast(message: 'Posted!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
        }
      },
      builder: (context, state) {
        if (isverified == false) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 5,
              title: Text(
                'New Post',
                style: TextStyle(fontFamily: 'Shitman'),
              ),
              leading: IconButton(
                onPressed: () {
                    Navigator.pop(context);
                },
                icon: Icon(IconBroken.Arrow___Left_2),
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.amber.withOpacity(0.6),
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(child: Text('Verify Your Email!')),
                        Column(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.currentUser
                                      .sendEmailVerification()
                                      .then((value) {
                                    DefaultToast(
                                        message:
                                        'Check Your Mail!',
                                        fontsize: 12,
                                        Backgroundcolor: Colors.grey[500]);
                                  });
                                },
                                child: Text(
                                  'Verify Now!',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    FirebaseAuth.instance.currentUser.reload();
                                    isverified = FirebaseAuth
                                        .instance.currentUser.emailVerified;
                                  });
                                },
                                child: Text('Already Verified?',
                                    style: TextStyle(color: Colors.grey[500])),
                              ),
                            ),
                          ],
                        )
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
            ),
          );
        } else {
          TextEditingController textcontroller = TextEditingController();
          return Form(
          key: formkey,
          child: Scaffold(
              appBar: AppBar(
                titleSpacing: 5,
                title: Text(
                  'New Post',
                  style: TextStyle(fontFamily: 'Shitman'),
                ),
                leading: IconButton(
                  onPressed: () {
                    if (state is SocialCreatePostLoadingState || state is SocialRemoverImageErrorState)
                      return null;
                    else
                      // LayoutCubit.get(context).posts = [];
                      // LayoutCubit.get(context).GetPosts();
                      Navigator.pop(context);
                  },
                  icon: Icon(IconBroken.Arrow___Left_2),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (state is SocialCreatePostLoadingState || state is SocialRemoverImageErrorState)
                          return null;
                        else if (LayoutCubit.get(context).Postimage == null) {
                          if (formkey.currentState.validate()) {
                            LayoutCubit.get(context)
                                .NewPostWithTextOnlyAfterWard(
                              text: textcontroller.text,
                              datetime: now.toString().substring(0,DateTime.now().toString().indexOf('.')),
                            );
                          }
                        } else {
                          LayoutCubit.get(context)
                              .NewPostWithTextAndImageOrImageOnlyAfterWard(
                            datetime: now.toString(),
                            text: textcontroller.text,
                          );
                          LayoutCubit.get(context).removeimage();
                        }
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(fontSize: 16),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              body: BlocConsumer<LayoutCubit, Home_States>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is GetUserLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).padding.top +
                                  kToolbarHeight +
                                  90),
                          child: Column(
                            children: [
                              if (state is SocialCreatePostLoadingState || state is SocialCreatePostLoadingState || state is SocialRemoverImageErrorState)
                                LinearProgressIndicator(),
                              if (state is SocialCreatePostLoadingState || state is SocialCreatePostLoadingState || state is SocialRemoverImageErrorState)
                                SizedBox(
                                  height: 10,
                                ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        LayoutCubit.get(context)
                                            .usermodel
                                            .image),
                                    radius: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                      child: Text(
                                    LayoutCubit.get(context).usermodel.name,
                                    style: TextStyle(fontSize: 15, height: 1.4),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Container(
                                  height: 120,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter Some Text Or Add A Photo!';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'What Is On Your Mind ...',
                                      border: InputBorder.none,
                                    ),
                                    controller: textcontroller,
                                  ),
                                ),
                              ),
                              if (LayoutCubit.get(context).Postimage != null)
                                Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Container(
                                      height: 400,
                                      width: double.infinity,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                LayoutCubit.get(context)
                                                    .Postimage),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.orangeAccent,
                                        radius: 20,
                                        child: IconButton(
                                          onPressed: () {
                                            LayoutCubit.get(context)
                                                .removeimage();
                                          },
                                          icon: Icon(Icons.close),
                                          iconSize: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        LayoutCubit.get(context)
                                            .getPostImage();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(IconBroken.Image),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Add A Photo'),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 45,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              )),
        );
        }
      },
    );
  }
}
