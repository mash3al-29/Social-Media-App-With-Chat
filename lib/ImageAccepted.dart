import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/Layout_Cubit/states.dart';
import 'modules/chat_details.dart';
class ImageAccepted extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CreateUserModelFirestore totymodel = LayoutCubit.get(context).totymodel;
    return BlocConsumer<LayoutCubit,Home_States>(
      listener: (context,state) {},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              if(state is SocialMessageImageUploadImageLoadingState){
                return null;
              }
              else{
                LayoutCubit.get(context).MessageImage = null;
                return Navigator.pop(context);
              }
            }, icon: Icon(IconBroken.Arrow___Left_2),),
            actions: [
              TextButton(onPressed: (){
                if(state is SocialMessageImageUploadImageLoadingState){
                  return null;
                }
                else{
                 return  LayoutCubit.get(context).uploadmessageimage(
                    text: controller.text,
                    recieverid: totymodel.uID,
                    datetime: DateTime.now().toString().substring(0,DateTime.now().toString().indexOf('.')),
                  );
                }
                }, child: Text('Send',style: TextStyle(
                color: Colors.orangeAccent,
                fontFamily: 'Benne',
              ),),),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if(state is SocialMessageImageUploadImageLoadingState)
                  LinearProgressIndicator(),
                if(state is SocialMessageImageUploadImageLoadingState)
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Image(image: FileImage(LayoutCubit.get(context).MessageImage),height: 600,),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type Your Message Here ...',
                            hintStyle: TextStyle(
                                fontFamily: 'Stix'
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
