import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/modules/Full_Account_Screen.dart';

import 'chat_details.dart';
class Users_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,Home_States>(
        listener: (context,state){},
        builder: (context,state){
          if (LayoutCubit.get(context).usersincludingme != null && LayoutCubit.get(context).usersincludingme.length > 0) {
              return ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index) => BuildChatItem(LayoutCubit.get(context).usersincludingme[index],context,index),
              separatorBuilder: (context,state) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              itemCount: LayoutCubit.get(context).usersincludingme.length,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  Widget BuildChatItem(CreateUserModelFirestore model,context,index){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Account_Screen(index)));
        },
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
