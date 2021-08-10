import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialmedia_app/layout/Home_Layout.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/modules/Login_Cubit/states.dart';
import 'package:socialmedia_app/modules/Login_Screen.dart';
import 'package:socialmedia_app/modules/Register_Cubit/states.dart';
import 'package:socialmedia_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'Register_Cubit/cubit.dart';

class Register_Screen extends StatefulWidget {
  @override
  _Register_ScreenState createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  var FormKey = GlobalKey<FormState>();

  var NameController = TextEditingController();

  var EmailController = TextEditingController();

  var PhoneController = TextEditingController();

  var PasswordController = TextEditingController();

  bool istapped = true;

  IconData icon = Icons.visibility_outlined;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return  BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (BuildContext context, state) {
          if (state is RegisterSuccess) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login_Screen()), (route) => false);
              DefaultToast(message: 'Signed Up Succsessfully!', fontsize: 14,Backgroundcolor: Colors.orangeAccent);
          }else if(state is RegisterError){
            DefaultToast(message: state.error.toString(), fontsize: 14,Backgroundcolor: Colors.grey[500]);
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: FormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SIGN UP',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 30),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Register Now To Communicate With Your Friends!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        DefaultTextFormField(
                          color: Colors.orangeAccent,
                          controller: NameController,
                          prefixicon: Icons.person,
                          type: TextInputType.text,
                          LabelText: 'Name',
                          validate: (dynamic value) {
                            if (value.isEmpty) {
                              return ('Name Must Not Be Empty');
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        DefaultTextFormField(
                          color: Colors.orangeAccent,
                          controller: EmailController,
                          prefixicon: Icons.email,
                          type: TextInputType.emailAddress,
                          LabelText: 'E-Mail',
                          validate: (dynamic value) {
                            if (value.isEmpty) {
                              return ('Please Enter a valid Email!');
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        DefaultTextFormField(
                          color: Colors.orangeAccent,
                          controller: PhoneController,
                          prefixicon: Icons.phone,
                          type: TextInputType.phone,
                          LabelText: 'Phone',
                          hinttext: 'Please Enter Your Phone Number With International code Of Your Country!',
                          validate: (dynamic value) {
                            if (value.isEmpty) {
                              return ('Phone Number Must Not Be Empty');
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        DefaultTextFormField(
                          color: Colors.orangeAccent,
                          controller: PasswordController,
                          prefixicon: Icons.lock_outline,
                          type: TextInputType.visiblePassword,
                          SubmitFunction: (value) {
                            if (FormKey.currentState.validate()) {
                              RegisterCubit.get(context).RegisterUser(
                                name: NameController.text,
                                email: EmailController.text,
                                password: PasswordController.text,
                                phone: PhoneController.text,
                              );
                            }
                          },
                          LabelText: 'Password',
                          isObscure: istapped,
                          SufixIcon: icon,
                          isSuffixpressed: () {
                            setState(() {
                              istapped = !istapped;
                              istapped == false
                                  ? icon = Icons.visibility_off_outlined
                                  : icon = Icons.visibility_outlined;
                            });
                          },
                          validate: (dynamic value) {
                            if (value.isEmpty) {
                              return ('Password Must Be 6 characters long!');
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        if (state is RegisterLoading)
                          Center(child: CircularProgressIndicator())
                        else
                          DefaultButton(
                            function: () {
                              if (FormKey.currentState.validate()) {
                                RegisterCubit.get(context).RegisterUser(
                                  name: NameController.text,
                                  email: EmailController.text,
                                  password: PasswordController.text,
                                  phone: PhoneController.text,
                                );
                              }
                            },
                            elevation: 50,
                            text: 'SIGN UP',
                            color: Colors.orangeAccent,
                            radius: 20,
                          ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

  }
}
