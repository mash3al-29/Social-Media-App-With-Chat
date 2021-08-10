import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialmedia_app/ImageAccepted.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:socialmedia_app/models/Message_Model.dart';
import 'package:socialmedia_app/modules/WebView.dart';
import 'package:socialmedia_app/shared/components/constants.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:webview_flutter/webview_flutter.dart';
class Chat_Details extends StatelessWidget {

  CreateUserModelFirestore totymodel = CreateUserModelFirestore();
  Chat_Details({
   this.totymodel
});
  TextEditingController controller = TextEditingController();
  var formkey = GlobalKey<FormState>();
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    LayoutCubit.get(context).totymodel = totymodel;
    return Builder(
      builder: (context){
        LayoutCubit.get(context).GetMessages(
          recieverId: totymodel.uID,
        );
        return BlocConsumer<LayoutCubit,Home_States>(
          listener: (context,state){
            var messageimage = LayoutCubit.get(context).MessageImage;
            if(messageimage != null && state is SocialMessageImageGetImageSuccessState)
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageAccepted()));
            else
              return null;
          },
          builder: (context,state){
            Timer(Duration(milliseconds: 50), () => _controller.jumpTo(_controller.position.maxScrollExtent));
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(IconBroken.Arrow___Left_2)),
                titleSpacing: 0,
                title:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(totymodel.image),
                        radius: 25,
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(totymodel.name,style: TextStyle(fontSize: 17,fontFamily: 'Shitman'),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: ConditionalBuilder(
                condition: totymodel != null,
                builder: (context) {
                  return Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              controller: _controller,
                              physics: BouncingScrollPhysics(),
                                itemBuilder: (context,index){
                                  var message = LayoutCubit.get(context).Messages[index];
                                  if(uID == message.senderid){
                                    return BuildMyMesssage(message,context);
                                  }
                                    return BuildMesssage(message,context);
                                },
                                separatorBuilder: (context,index){
                                  return SizedBox(height: 15,);
                                },
                                itemCount: LayoutCubit.get(context).Messages.length,
                            ),
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Expanded(
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
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: TextFormField(
                                            validator: (value){
                                              if(value.isEmpty || controller.text.trim() == ''){
                                                return 'Please Enter A Valid Message!';
                                              }
                                              return null;
                                            },
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
                                      SizedBox(width: 5,),
                                      MaterialButton(
                                        height: 50,
                                        elevation: 0,
                                        onPressed: (){
                                          LayoutCubit.get(context).getMessageImage();
                                          },
                                        minWidth:1,
                                        child: Icon(IconBroken.Camera,size: 16,color: Colors.white,),
                                        color: Colors.orangeAccent,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                height: 50,
                                elevation: 0,
                                onPressed: () {
                                    if(formkey.currentState.validate()) {
                                      LayoutCubit.get(context).GetTime(
                                        text: controller.text,
                                        recieverid: totymodel.uID,
                                      );
                                      controller.clear();
                                    }
                                },
                                minWidth:1,
                                child: Icon(IconBroken.Send,size: 16,color: Colors.white,),
                                color: Colors.orangeAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } ,
                fallback: (context) => Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget BuildMesssage(MessageModel model,context) => Align(
    alignment: AlignmentDirectional.centerStart,
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
      child: BuildImageOrText(model,context)
    ),
  );
  Widget BuildMyMesssage(MessageModel model,context) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      padding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.5),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
          ),
      ),
      child: BuildImageOrText(model,context)
    )
  );
}

Widget BuildImageOrText(MessageModel model,context){
  if(model.image == '' || model.image == null)
    return Text(model.text,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: 'Stix',
      ),
    );
  else if(model.text == '' || model.text == null)
    return InkWell(child: Image(image: NetworkImage(model.image),height: 200,),onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(model.image)));
    },);
  else if(model.text != '' && model.image != '')
    return Column(
      children: [
          InkWell(child: Image(image: NetworkImage(model.image),height: 200,width: 200,),onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(model.image)));
          },),
          SizedBox(height: 5,),
          Text(model.text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Stix',
          ),
        ),
      ],
    );
}
