import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/models/Create_User_Model_Firestore.dart';
import 'package:socialmedia_app/modules/Register_Cubit/states.dart';
import 'package:socialmedia_app/shared/network/Endpoints.dart';
import 'package:socialmedia_app/shared/network/remote/Dio_Helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterCubit extends Cubit<RegisterStates>{

  RegisterCubit() : super(InitialRegister());

  static RegisterCubit get(context) => BlocProvider.of(context);



  Future<UserCredential> RegisterUser(
      { @required String name, @required String email, @required dynamic phone, @required String password }
      ) async {
    emit(RegisterLoading());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      UserCreate(
        email: value.user.email,
        phone: phone,
        password: password,
        name: name,
        uID: value.user.uid,
      );
      emit(RegisterSuccess());
    }).catchError((onError){
      print(onError.toString());
      emit(RegisterError(onError));
    });
  }
  Future<void> UserCreate({
    @required String name, @required String email, @required dynamic phone, @required String password,@required String uID,
  }){
    CreateUserModelFirestore model = CreateUserModelFirestore(
        phone: phone,
        name : name,
        email: email,
        Pass: password,
        cover: 'https://image.freepik.com/free-photo/traditional-turkish-cuisine_127425-87.jpg',
        Bio: 'Write Things About Yourself Here! It Will Show Up In Public To people Around The World!',
        image: 'https://img.freepik.com/free-photo/happy-bearded-young-man-looks-with-joyful-expression-has-friendly-smile-wears-yellow-sweater-red-hat_295783-1388.jpg?size=338&ext=jpg',
        uID: uID,
    );
    FirebaseFirestore.instance.collection('users').doc(uID).set(
        model.ToMap(),
    ).then((value) {
      emit(CreateUserWithDataInFireBaseSuccess());
    }).catchError((onError){
      print(onError.toString());
      emit(CreateUserWithDataInFireBaseError(onError));
    });
  }

}