import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
class ListOfComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, Home_States>(
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
            onWillPop: (){
              LayoutCubit.get(context).commentsnona = [];
              LayoutCubit.get(context).listofcommentsofacertainpost = [];
              Navigator.pop(context);
              return null;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Comments',
                  style: TextStyle(fontFamily: 'Benne'),
                ),
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      LayoutCubit.get(context).commentsnona = [];
                      LayoutCubit.get(context).listofcommentsofacertainpost = [];
                    },
                    icon: Icon(IconBroken.Arrow___Left_2)),
              ),
              body :
                  ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => BuildChatItem(
                    LayoutCubit.get(context).listofcommentsofacertainpost[index],LayoutCubit.get(context).commentsnona[index]
                ),
                    separatorBuilder: (context, state) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  itemCount: LayoutCubit.get(context).commentsnona.length,
              ),
            ),
          );
        });
  }

  Widget BuildChatItem(CreateUserModelFirestore model,String text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
      InkWell(
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
      ),
      Align(
      alignment: AlignmentDirectional.center,
      child: Container(
      padding: EdgeInsets.symmetric(
      vertical: 5,
      horizontal: 10,
      ),
      decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadiusDirectional.only(
      bottomEnd: Radius.circular(10),
      topEnd: Radius.circular(10),
      topStart: Radius.circular(10),
      )
      ),
      child: Text(text,
      textAlign: TextAlign.left,
      style: TextStyle(
      fontFamily: 'Stix',
      ),
      ),
      ),
      ),
        ],
      ),
    );

  }
}