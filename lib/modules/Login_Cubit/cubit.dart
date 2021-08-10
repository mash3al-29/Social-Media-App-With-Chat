import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmedia_app/modules/Login_Cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/shared/components/constants.dart';

class LoginCubit extends Cubit<LoginStates>{

  LoginCubit() : super(InitialLogin());

  static LoginCubit get(context) => BlocProvider.of(context);

  Future<UserCredential> UserLogin(
      String email,
      String password,
      ) async {
    emit(LoginLoading());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      uID = value.user.uid;
      emit(LoginSuccess());
    }).catchError((onError){
      emit(LoginError(onError));
    });
  }

}