import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/states.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia_app/models/Message_Model.dart';
import 'package:socialmedia_app/models/Post_Model.dart';
import 'package:socialmedia_app/models/timemodel.dart';
import 'package:socialmedia_app/modules/AuthService.dart';
import 'package:socialmedia_app/modules/List%20of%20comments.dart';
import 'package:socialmedia_app/modules/ListOfLikes.dart';
import 'package:socialmedia_app/shared/components/components.dart';
import 'package:socialmedia_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:socialmedia_app/shared/network/remote/Dio_Helper.dart';
class LayoutCubit extends Cubit<Home_States>{
  // /data/user/0/com.penguininc.socialmediaapp.socialmedia_app/cache/image_picker8358899014325534508.jpg
  LayoutCubit() : super(Initial_State());

  static LayoutCubit get(context) => BlocProvider.of(context);
  CreateUserModelFirestore usermodel = CreateUserModelFirestore();
  List<PostModel> posts = [];
  List<String> postsids = [];
  List<int> likes = [];
  List<int> comments = [];
  String postimage = '';
  List<CreateUserModelFirestore> users = [];
  File Postimage;
  File coverimage;
  File profileImage;
  File MessageImage;
  var messageimagepicker = ImagePicker();
  var postpicker = ImagePicker();
  var profilepicker = ImagePicker();
  var coverpicker = ImagePicker();
  String profileimage = '';
  int indexo;
  List<MessageModel> Messages= [];
  CreateUserModelFirestore totymodel = CreateUserModelFirestore();
  List<String> paths = [];
  List<CreateUserModelFirestore> usersincludingme = [];
  List<CreateUserModelFirestore> listoflikesofacertainpost = [];
  List<CreateUserModelFirestore> listofcommentsofacertainpost = [];
  List<String> commentsnona = [];
  String verificationId;
  String smscode;
  bool codesent;
  TimeModel model = TimeModel();

  Future<dynamic> deleteaccount(){
    FirebaseFirestore.instance.collection('users').doc(uID).delete();
    FirebaseAuth.instance.currentUser.delete();
  }

  Future<dynamic> GetUserData(){
    emit(GetUserLoading());
    return FirebaseFirestore.instance.collection('users').doc(uID).get().then((value) {
      usermodel = CreateUserModelFirestore.fromJson(value.data());
      emit(GetUserSuccsess());
    }).catchError((dynamic error){
      print(error.toString());
      emit(GetUserError());
    });
  }

  // Future<dynamic> PhoneAuth(phonenumber) async{
  //   final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential authResult){
  //     AuthService().signin(authResult);
  //   };
  //   final PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException){
  //
  //   };
  //   final PhoneCodeSent smsSent = (String verId, [int ForceResend]){
  //     verificationId = verId;
  //     codesent = true;
  //     emit((statesaree3a()));
  //   };
  //   final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId){
  //     verificationId = verId;
  //   };
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phonenumber,
  //     timeout: Duration(seconds: 5),
  //     verificationCompleted: verificationCompleted,
  //     verificationFailed: verificationFailed,
  //     codeSent: smsSent,
  //     codeAutoRetrievalTimeout: autoTimeout,
  //   );
  // }



  Future<dynamic> getProfileImage() async {
    final pickedFile = await profilepicker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  Future<dynamic> getMessageImage() async {
    var pickedFile = await messageimagepicker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      MessageImage = File(pickedFile.path);
      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String appDocPath = appDocDir.path;
      // localimage = await MessageImage.copy(appDocPath + '/' + Uri.file(MessageImage.path).pathSegments.last);
      emit(SocialMessageImageGetImageSuccessState());
    } else {
      print('No image selected.');
      emit(SocialMessageImageGetImageErrorState());
    }
  }

  Future<dynamic> getCoverImage() async {
    final pickedFile = await coverpicker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverimage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }


  Future<void> removeprofile()async {
    profileImage = null;
  }

  Future<void> removecover()async {
    coverimage = null;
  }

  Future<dynamic> uploadprofileimage({
    @required String phone,
    @required String name,
    @required String bio,
}){
    return firebase_storage.FirebaseStorage.instance.ref().child('users/${Uri.file(profileImage.path).pathSegments.last}').putFile(profileImage).then((value) {
      value.ref.getDownloadURL().then((value) {
        profileimage = value;
        updatetoty(phone: phone, name: name, bio: bio,imageprofile: value);
        emit(SocialProfileUploadImageSuccessState());
      }).catchError((error){
        emit(SocialProfileUploadImageErrorState());
      });
    }).catchError((error){
      emit(SocialProfileUploadImageErrorState());
    });
  }

  Future<dynamic> uploadcoverimage({
    @required String phone,
    @required String name,
    @required String bio,
}){
    return firebase_storage.FirebaseStorage.instance.ref().child('users/${Uri.file(coverimage.path).pathSegments.last}').putFile(coverimage).then((value) {
      value.ref.getDownloadURL().then((value) {
        updatetoty(phone: phone, name: name, bio: bio,cover: value);
        emit(SocialCoverImagePickedSuccessState());
      }).catchError((error){
        emit(SocialCoverUploadImageErrorState());
      });
    }).catchError((error){
      emit(SocialCoverUploadImageErrorState());
    });
  }

  Future<dynamic> uploadmessageimage({
    String text,
    String recieverid,
    String datetime,
}){
    emit(SocialMessageImageUploadImageLoadingState());
    return firebase_storage.FirebaseStorage.instance.ref().child('messages/${Uri.file(MessageImage.path).pathSegments.last}').putFile(MessageImage).then((value) {
      value.ref.getDownloadURL().then((tuna) {
          GetTime(
            text: text,
            recieverid: recieverid,
            image: tuna,
          );
          emit(SocialMessageImageUploadImageSuccessState());
      }).catchError((error){
        emit(SocialMessageImageUploadImageErrorState());
      });
    }).catchError((error){
      emit(SocialMessageImageUploadImageErrorState());
    });
  }

  Future<String> GetTime({
    String text,
    String recieverid,
    String image,
  }){
    DioHelper.GetData(url: 'http://worldtimeapi.org/api/timezone/Africa/Cairo',).then((value) {
        SendMessage(
          text: text,datetime: TimeModel.fromJson(value.data).datetime.toString(),recieverid: recieverid,
        image: image == '' || image == null ? '' : image);
    });
  }


  Future<dynamic> updatetoty({
    @required String phone,
    @required String name,
    @required String bio,
    String cover,
    String imageprofile,
  }){
    CreateUserModelFirestore model = CreateUserModelFirestore(
      phone: phone,
      name : name,
      Bio: bio,
      cover: cover == null ?  usermodel.cover : cover,
      image: imageprofile == null ?  usermodel.image : imageprofile,
      uID: usermodel.uID,
      email: usermodel.email,
      Pass: usermodel.Pass,
    );
    return FirebaseFirestore.instance.collection('users').doc(uID).update(model.ToMap()).then((value) {
      GetUserData();
      posts = [];
      likes = [];
      comments = [];
      postsids = [];
      GetPosts();
    }).catchError((error){
      emit(SocialUserUpdateErrorState());
    });
  }

  Future<dynamic> updateUser({
    @required String phone,
    @required String name,
    @required String bio,
    @required BuildContext context,
  }) async {
    emit(SocialUserUpdateLoadingState());
    if(coverimage != null || profileImage != null){
      if(coverimage != null && profileImage == null){
        await uploadcoverimage(
          name: name,
          phone: phone,
          bio: bio,
        );
        await removecover();
      }else if(profileImage != null && coverimage == null){
        await uploadprofileimage(
          phone: phone,
          name: name,
          bio: bio,
        );
        await removeprofile();
        await GetUserData();
        lonaelpona(context);
      }else if(profileImage != null && coverimage != null){
        await uploadprofileimage(
          phone: phone,
          name: name,
          bio: bio,
        );
        await uploadcoverimage(phone: phone, name: name, bio: bio);
        await removecover();
        await removeprofile();
        await GetUserData();
        lonaelpona(context);
      }
      }else{
      updatetoty(
        cover: null,
        imageprofile: null,
        name: name,
        phone: phone,
        bio: bio,
      );
      lonaelpona(context);
    }
    DefaultToast(message: 'Updated!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
    }

    Future<dynamic> lonaelpona(context) async {
      await changeoldpostphoto(context: context);
    }



  Future<dynamic> getPostImage() async {
    final pickedFile = await postpicker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      Postimage = File(pickedFile.path);
      emit(SocialPostUploadImageSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostUploadImageErrorState());
    }
  }

  Future<void> uploadpostimage({
    @required String datetime,
    @required String text,
  })async {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance.ref().child('posts/${Uri.file(Postimage.path).pathSegments.last}').putFile(Postimage).then((value) {
      value.ref.getDownloadURL().then((value) {
         postimage = value;
        newpost(dateTime: datetime, text: text, postimage: value);
      }).catchError((error){
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }

  void removeimage(){
    Postimage = null;
    emit(SocialRemoverImageErrorState());
  }

  Future<void> newpost({
    @required String dateTime,
    @required String text,
    String postimage,
  })async {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: usermodel.name,
      uID: usermodel.uID,
      profileimage: usermodel.image,
      datetime: dateTime,
      postimage: postimage?? '',
      text: text,
    );
    FirebaseFirestore.instance.collection('posts').add(model.ToMap()).then((value) {
      posts = [];
      postsids = [];
      likes = [];
      comments = [];
      GetPosts();
      emit(SocialCreatePostSuccessState());
    }).catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }

  Future<void> GetAllUsers()async {
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if(element.data()['uID'] != uID)
          users.add(CreateUserModelFirestore.fromJson(element.data()));
      });
      emit(GetAllUsersSuccsess());
    }).catchError((error){
      print(error.toString());
      emit(GetAllUsersError());
    });
  }

  Future<void> GetAllUsersIncludingMe(){
    usersincludingme = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
          usersincludingme.add(CreateUserModelFirestore.fromJson(element.data()));
      });
      emit(GetAllUsersIncludingMeSuccsess());
    }).catchError((error){
      print(error.toString());
      emit(GetAllUsersIncludingMeError());
    });
  }


  Future<void> GetPosts()async {
    emit(GetPostsLoading());
    FirebaseFirestore.instance.collection('posts').orderBy('datetime').get().then((value) {
      value.docs.forEach((element) {
        element.reference
        .collection('likes')
        .get()
        .then((dody) {
          element.reference.collection('comments').get().then((kona) {
            posts.add(PostModel.fromJson(element.data()));
            likes.add(dody.docs.length);
            postsids.add(element.id);
            comments.add(kona.docs.length);
            emit(GetPostsSuccsess());
          });
        })
        .catchError((error){
          print(error.toString());
          emit(GetPostsError());
        });
      });
    }).catchError((error){
      print(error.toString());
      emit(GetPostsError());
    });
  }

  Future<void> Getindex(int index){
    indexo = index;
    emit(indexgotten());
  }

  Future<void> NewPostWithTextOnlyAfterWard({
  String text,
  String datetime,
}) async {
    posts = [];
    await newpost(text: text,dateTime: datetime,);
  }

  Future<void> NewPostWithTextAndImageOrImageOnlyAfterWard({
    String text,
    String datetime,
  }) async {
    posts = [];
    await uploadpostimage(text: text,datetime: datetime);
  }


  Future<void> changeoldpostphoto({
  context
}) async {
    emit(TriggerTheBomb());
    await GetUserData();
    posts.forEach((element) async {
         return await FirebaseFirestore.instance.collection('posts').get().then((value) async {
          value.docs.forEach((z) {
            if(uID == z.get('uID')){
              z.reference.update({
                'name' : usermodel.name,
               'profileimage' : usermodel.image,
              }).then((value) async {
              });
            }
          });
        });
    });
  }

  Future<dynamic> GetLikeStatus(String postId,context,index){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(usermodel.uID)
        .get().then((value) {
      if(value.exists){
        LayoutCubit.get(context).RemoveLike(LayoutCubit.get(context).postsids[index]);
        DefaultToast(message: 'Unliked!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
      }else{
        LayoutCubit.get(context).LikePost(LayoutCubit.get(context).postsids[index]);
        DefaultToast(message: 'Liked!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
      }
    });
  }

  Future<dynamic> DeletePost(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
    .get().then((value) {
      if(value.get('uID') == uID){
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId).delete().then((value) {
              posts = [];
              postsids = [];
              likes = [];
              comments = [];
              GetPosts();
              DefaultToast(message: 'Deleted!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
        });
      }else{
        DefaultToast(message: 'This Post Isn\'t Yours!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
      }
    });
  }
  
  Future<dynamic> LoopThroughThem(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get().then((value) {
          if(value.get('postimage') != ''){
            Clipboard.setData(ClipboardData(text: value.get('postimage'))).then((value) {
              DefaultToast(message: 'Copied!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
            });
          }else{
            DefaultToast(message: 'No Image On This Post!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
          }
    });
  }

  Future<dynamic> GetLikes(String postId,context){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get().then((value) {
          value.docs.forEach((element) {
            usersincludingme.forEach((elelele) {
              if(elelele.uID == element.id) {
                listoflikesofacertainpost.add(elelele);
              }
            });
          });
    }).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfLikes()));
    });
  }

  void LikePost(String postId) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(usermodel.uID)
          .set({
        'like': true,
      }).then((value) {
        posts = [];
        postsids = [];
        likes = [];
        comments = [];
        GetPosts();
        emit(SocialLikeImagePostSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialLikeImagePostErrorState());
      });
  }

  void RemoveLike(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(usermodel.uID)
        .delete().then((value) {
          posts = [];
          postsids = [];
          likes = [];
          comments = [];
          GetPosts();
    });
  }

  Future<void> ReloadApp(context){
  Phoenix.rebirth(context);
  emit(statesaree3a());
}

  Future<void> AddAComment({String postId, String text}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(usermodel.uID)
        .set({
      'comment' : text,
    }).then((value) {
      posts = [];
      postsids = [];
      likes = [];
      comments = [];
      GetPosts();
      DefaultToast(message: 'Commented!', fontsize: 12,Backgroundcolor: Colors.grey[500]);
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCommentPostErrorState());
    });
  }

  Future<dynamic> GetComments(String postId,context){
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get().then((value) {
        value.docs.forEach((element) {
          usersincludingme.forEach((elelele) {
            if(elelele.uID == element.id){
              listofcommentsofacertainpost.add(elelele);
              commentsnona.add(element.get('comment'));
            }
          });
        });
      }).then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfComments()));
      });
  }

  // Future<dynamic> AddIds(String postId,context){
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('comments')
  //       .get().then((value) {
  //     value.docs.forEach((element) {
  //       usersincludingme.forEach((elelele) {
  //         if(elelele.uID == element.id){
  //           commentsids.add(element.id);
  //         }
  //       });
  //     });
  //   });
  // }



  void SendMessage({
    String text,
    String recieverid,
    String datetime,
    String image,
  }){
    MessageModel messagemodel = MessageModel(
      text: text != null && text != '' ? text : '',
      datetime: datetime,
      recieverid: recieverid,
      senderid: uID,
      image: image != null && image != '' ? image : '',
    );

    //set my messages
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .collection('chats')
        .doc(recieverid)
        .collection('messages')
        .add(messagemodel.ToMap()).then((value) {
      emit(SendMessagesSuccessState());
    }).catchError((error){
      emit(SendMessagesErrorState());
    });

    //set receiver messages
    FirebaseFirestore.instance
        .collection('users')
        .doc(recieverid)
        .collection('chats')
        .doc(uID)
        .collection('messages')
        .add(messagemodel.ToMap()).then((value) {
      emit(SendMessagesSuccessState());
    }).catchError((error){
      emit(SendMessagesErrorState());
    });
}

void GetMessages({String recieverId}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('datetime')
        .snapshots()
        .listen((event) {
            Messages = [];
            event.docs.forEach((element) {
            Messages.add(MessageModel.fromJson(element.data()));
          });
          emit(GetMessagesSuccessState());
    });
}

//  Future<dynamic> DownloadImageToLocalStorage(String url) async {
//     var imageId = await ImageDownloader.downloadImage(url);
//     var path = await ImageDownloader.findPath(imageId);
//       File Image;
//     Image = File(path);
//     imageshitman = Image;
//
// }
}