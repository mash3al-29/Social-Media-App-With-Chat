import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:socialmedia_app/modules/Login_Screen.dart';
import 'package:socialmedia_app/modules/New_Post.dart';
import 'package:socialmedia_app/modules/WebView.dart';
import 'package:socialmedia_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/shared/components/constants.dart';
import 'package:socialmedia_app/shared/network/local/Cache_Helper.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'Edit_Profile.dart';
class Full_Account_Screen extends StatelessWidget {

  int index;
  Full_Account_Screen(this.index);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,Home_States>(
      listener: (context,state){},
      builder: (context,state){
        var model = LayoutCubit.get(context).usersincludingme;
        return Scaffold(
          appBar: AppBar(
            title: Text(model[index].name,style: TextStyle(fontFamily: 'Shitman'),),
            leading: IconButton(icon: Icon(IconBroken.Arrow___Left_2), onPressed: () {
              Navigator.pop(context);
            },
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(model[index].cover)));
                            },
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit:BoxFit.cover,
                                      image: NetworkImage('${model[index].cover}',
                                      ),
                                  )
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(model[index].image)));
                          },
                          child: CircleAvatar(
                            radius: 64,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(backgroundImage: NetworkImage(
                                '${model[index].image}'
                            ),
                              radius: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '${model[index].name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${model[index].Bio}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
