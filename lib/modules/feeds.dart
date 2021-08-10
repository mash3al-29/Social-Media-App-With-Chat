import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Post_Model.dart';
import 'package:socialmedia_app/modules/ConstantsForPopupMenu.dart';
import 'package:socialmedia_app/modules/List%20of%20comments.dart';
import 'package:socialmedia_app/modules/ListOfLikes.dart';
import 'package:socialmedia_app/modules/RefreshWidget.dart';
import 'package:socialmedia_app/modules/WebView.dart';
import 'package:socialmedia_app/modules/new_comment_screen.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
class Feeds_Screen extends StatelessWidget {
  bool likeww;
  Widget BuildPostItem(PostModel model,context,index){
    void choiceAction(String choice){
      if(choice == Constantsforepopupmenu.DeletePost){
        LayoutCubit.get(context).DeletePost(LayoutCubit.get(context).postsids[index]);
      }else{
        LayoutCubit.get(context).LoopThroughThem(LayoutCubit.get(context).postsids[index]);
      }
    }
    return Container(
      width: double.infinity,
      child: Card(
        margin : EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(model.profileimage),
                    radius: 30,
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
                              Text(model.name,style: TextStyle(fontSize: 15,height: 1.4),),
                              SizedBox(width: 5,),
                              SingleChildScrollView(scrollDirection: Axis.horizontal,child: Icon(Icons.check_circle,color: Colors.orangeAccent,size: 18,))
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(model.datetime,
                          style: Theme.of(context).textTheme.caption.copyWith(
                              color: Colors.grey
                          ),),

                      ],
                    ),
                  ),
                  SizedBox(width: 15,),
                  PopupMenuButton<String>(itemBuilder: (BuildContext context) {
                    return Constantsforepopupmenu.choices.map((String choice) {
                      return PopupMenuItem<String>(
                      value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },icon: Icon(Icons.more_horiz),
                  onSelected: choiceAction,
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SelectableText(
                  model.text,
                  style: TextStyle(
                    fontFamily: 'Benne',
                    height: 1.3,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              if(model.postimage != '')
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>WebViewScreen(model.postimage)));
                  },
                  child: Container(
                    height: 500,
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            fit:BoxFit.cover,
                            image: NetworkImage(model.postimage,
                            )
                        )
                    ),
                  ),
                ),
              )
              else
                SizedBox(height : 15),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            Icon(IconBroken.Heart,size: 28,color: Colors.red,),
                            SizedBox(width: 9,),
                            Text('${LayoutCubit.get(context).likes[index].toString()} likes',style: Theme.of(context).textTheme.caption.copyWith(
                            color: Colors.grey
                        )
                        ),
                        ],
                        ),
                        onTap: (){
                          LayoutCubit.get(context).GetLikes(
                            LayoutCubit.get(context).postsids[index],context
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(IconBroken.Chat,size: 28,color: Colors.orange,),
                              SizedBox(width: 9,),
                              Text('${LayoutCubit.get(context).comments[index].toString()} comments',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey
                              ),)
                            ],
                          ),
                          onTap: (){
                            LayoutCubit.get(context).GetComments(LayoutCubit.get(context).postsids[index],context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[400],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Row(
                        children: [
                          CircleAvatar(backgroundImage: NetworkImage(
                              LayoutCubit.get(context).usermodel.image
                          ),
                            radius: 20,
                          ),
                          SizedBox(width: 9,),
                          Text('Write A Comment ...',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey
                            ),),
                        ],
                      ),
                      onTap: (){
                        LayoutCubit.get(context).Getindex(index);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => New_Comment()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      child: Row(
                        children: [
                          Icon(IconBroken.Heart,size: 23,color: Colors.red,),
                          SizedBox(width: 9,),
                          Text('Like',style: TextStyle(fontSize: 14,color: Colors.grey),)
                        ],
                      ),
                      onTap: () {
                        LayoutCubit.get(context).GetLikeStatus(LayoutCubit.get(context).postsids[index],context,index);
                      }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,Home_States>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
          condition: LayoutCubit.get(context).posts != null && LayoutCubit.get(context).posts.length > 0,
          builder: (context)
          {
                return RefreshWidget(
                  onRefresh: (){
                    Future.delayed(Duration(milliseconds: 1000)).then((value) {
                      LayoutCubit.get(context).posts = [];
                      LayoutCubit.get(context).postsids = [];
                      LayoutCubit.get(context).likes = [];
                      LayoutCubit.get(context).comments = [];
                      LayoutCubit.get(context).GetPosts();
                    });
                    return null;
                  },
                  child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: double.infinity,
                        child: Card(
                          margin: EdgeInsets.all(8),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 10,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Image(
                                width: double.infinity,
                                image: NetworkImage(
                                    'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg'),
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Communicate With Friends!',
                                  style:
                                      TextStyle(fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => BuildPostItem(
                              LayoutCubit.get(context).posts[index],
                              context,
                              index
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                          ),
                          itemCount: LayoutCubit.get(context).posts.length,
                        ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
            ),
                );
          },
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
