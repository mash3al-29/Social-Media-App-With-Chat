import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/modules/feeds.dart';
import 'package:socialmedia_app/shared/components/components.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
class Edit_Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocConsumer<LayoutCubit,Home_States>(
      listener: (context,state) {},
      builder: (context,state) {
        var model = LayoutCubit.get(context).usermodel;
        var namecontroller = TextEditingController();
        var Biocontroller = TextEditingController();
        var Phonecontroller = TextEditingController();
        var profileimage = LayoutCubit.get(context).profileImage;
        var coverimage = LayoutCubit.get(context).coverimage;
        var formkey = GlobalKey<FormState>();
        namecontroller.text = model.name;
        Biocontroller.text = model.Bio;
        Phonecontroller.text = model.phone;
        return Form(
          key: formkey,
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 5,
              title: Text('Edit Profile',style: TextStyle(fontFamily: 'Shitman'),),
              leading: IconButton(
                onPressed: (){
                  if(state is SocialUserUpdateLoadingState){
                    return null;
                  }
                  Navigator.pop(context);
                },
                icon: Icon(
                    IconBroken.Arrow___Left_2
                ),
              ),
              actions: [
                TextButton(onPressed: (){
                  if(state is SocialUserUpdateLoadingState){
                    return null;
                  }
                  if(formkey.currentState.validate()){
                    LayoutCubit.get(context).updateUser(phone: Phonecontroller.text, name: namecontroller.text, bio: Biocontroller.text,context: context);
                  }
                }, child: Text('Update',style: TextStyle(fontSize: 16),)
                ),
                SizedBox(width: 15,),
              ],
            ),
            body:
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    if(state is SocialUserUpdateLoadingState || state is TriggerTheBomb)
                      LinearProgressIndicator(),
                    if(state is SocialUserUpdateLoadingState || state is TriggerTheBomb)
                      SizedBox(height: 10,),
                    Container(
                      height: 200,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
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
                                          image: coverimage == null ? NetworkImage('${model.cover}',) : FileImage(coverimage)
                                      )
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.orangeAccent,
                                  radius: 25,
                                    child: IconButton(onPressed: (){
                                      LayoutCubit.get(context).getCoverImage();
                                    }, icon: Icon(IconBroken.Camera),iconSize: 27,color: Colors.black,),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(backgroundImage: profileimage == null ? NetworkImage(
                                    '${model.image}') : FileImage(profileimage),
                                  radius: 60,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.orangeAccent,
                                  radius: 20,
                                  child: IconButton(onPressed: (){
                                    LayoutCubit.get(context).getProfileImage();
                                  }, icon: Icon(IconBroken.Camera),iconSize: 22,color: Colors.black,),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(height: 20,),
                    DefaultTextFormField(
                      prefixicon: IconBroken.User,
                        color: Colors.orangeAccent,
                        controller: namecontroller,
                        type: TextInputType.name,
                        LabelText: 'Name',
                        validate: (String value){
                          if (value.isEmpty){
                            return 'Name Must Not Be Empty!';
                          }
                        },
                    ),
                    SizedBox(height: 20,),
                    DefaultTextFormField(
                      prefixicon: IconBroken.Info_Circle,
                      color: Colors.orangeAccent,
                      controller: Biocontroller,
                      type: TextInputType.name,
                      LabelText: 'Bio',
                      validate: (String value){
                        if (value.isEmpty){
                          return 'Bio Must Not Be Empty!';
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    DefaultTextFormField(
                      prefixicon: IconBroken.Call,
                      color: Colors.orangeAccent,
                      controller: Phonecontroller,
                      type: TextInputType.phone,
                      LabelText: 'Phone',
                      validate: (String value){
                        if (value.isEmpty){
                          return 'Phone Must Not Be Empty!';
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    Text('Note : The App Will Refresh Automatically For The Changes To Take Place!',
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                      height: 1.4
                    ),),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}