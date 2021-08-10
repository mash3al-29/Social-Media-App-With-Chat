import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';

class ListOfLikes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, Home_States>(
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
            onWillPop: (){
              LayoutCubit.get(context).listoflikesofacertainpost = [];
              Navigator.pop(context);
              return null;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Likes',
                  style: TextStyle(fontFamily: 'Benne'),
                ),
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      LayoutCubit.get(context).listoflikesofacertainpost = [];
                      Navigator.pop(context);
                    },
                    icon: Icon(IconBroken.Arrow___Left_2)),
              ),
              body :
                   ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => BuildChatItem(
                          LayoutCubit.get(context).listoflikesofacertainpost[index], context
                      ),
                      separatorBuilder: (context, state) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      itemCount: LayoutCubit.get(context).listoflikesofacertainpost.length,
                    ),
            ),
          );
        });
  }

  Widget BuildChatItem(CreateUserModelFirestore model, context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(model.image),
              radius: 30,
            ),
            SizedBox(
              width: 25,
            ),
            Text(
              model.name,
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
