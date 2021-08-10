import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/modules/RefreshWidget.dart';

import 'chat_details.dart';
class Chats_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,Home_States>(
      listener: (context,state){},
      builder: (context,state){
        if (LayoutCubit.get(context).users != null && LayoutCubit.get(context).users.length > 0) {
              return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index) => BuildChatItem(LayoutCubit.get(context).users[index],context),
                  separatorBuilder: (context,state) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  itemCount: LayoutCubit.get(context).users.length,
              );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
      );
  }

  Widget BuildChatItem(CreateUserModelFirestore model,context){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Chat_Details(totymodel: model,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(model.image),
              radius: 30,
            ),
            SizedBox(width: 25,),
            Text(model.name,style: TextStyle(fontSize: 15,height: 1.4),),
          ],
        ),
      ),
    );
  }
}
