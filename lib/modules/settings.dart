import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:socialmedia_app/modules/Login_Screen.dart';
import 'package:socialmedia_app/modules/New_Post.dart';
import 'package:socialmedia_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/shared/components/constants.dart';
import 'package:socialmedia_app/shared/network/local/Cache_Helper.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'Edit_Profile.dart';
class Settings_Screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,Home_States>(
      listener: (context,state){},
      builder: (context,state){
        var model = LayoutCubit.get(context).usermodel;
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  fit:BoxFit.cover,
                                  image: NetworkImage('${model.cover}',
                                  )
                              )
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(backgroundImage: NetworkImage(
                            '${model.image}' ),
                          radius: 60,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  '${model.name}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${model.Bio}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 6,),
                              Text(
                                'Posts',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: (){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '265',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 6,),
                              Text(
                                'Photos',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: (){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '100k',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 6,),
                              Text(
                                'Followers',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: (){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '55',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 6,),
                              Text(
                                'Friends',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: (){},
                        ),
                      ),
                    ],
                  ),

                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    SizedBox(width: 5,),
                    Expanded(child: OutlinedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => New_Post()));
                    }, child: Text('Add Photos',),)),
                    SizedBox(width: 10,),
                    OutlinedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_Profile()));
                    }, child: Icon(IconBroken.Edit,color: Colors.orangeAccent,),),
                  ],
                ),
                SizedBox(height: 40,),
                Row(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
