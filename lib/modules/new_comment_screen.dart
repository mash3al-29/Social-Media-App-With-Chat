import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class New_Comment extends StatelessWidget {

  var textcontroller = TextEditingController();
  var now = DateTime.now();
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,Home_States>(
      listener: (context,state){

      },
      builder: (context,state){
        return Form(
          key: formkey,
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 5,
              title: Text(
                'New Post', style: TextStyle(fontFamily: 'Shitman'),),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  IconBroken.Arrow___Left_2,
                ),
              ),
              actions: [
                TextButton(onPressed: () {
                  if(formkey.currentState.validate()){
                    LayoutCubit.get(context).AddAComment(
                      text: textcontroller.text,
                      postId: LayoutCubit.get(context).postsids[LayoutCubit.get(context).indexo],
                    );
                    Navigator.pop(context);
                  }
                }, child: Text('Post', style: TextStyle(fontSize: 16),)),
                SizedBox(width: 15,),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(
                      LayoutCubit.get(context).usermodel.image,
                    ),
                      radius: 30,
                    ),
                    SizedBox(width: 15,),
                    Expanded(child: Text( LayoutCubit.get(context).usermodel.name,style: TextStyle(fontSize: 15,height: 1.4),)),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Write A Comment ...',
                        border: InputBorder.none,
                      ),
                      controller: textcontroller,
                    ),
                  ),
                ),
              ],),
            ),
          ),
        );
      },
    );
  }
}
