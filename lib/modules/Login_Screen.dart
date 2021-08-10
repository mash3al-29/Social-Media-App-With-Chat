import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialmedia_app/layout/Home_Layout.dart';
import 'package:socialmedia_app/layout/Layout_Cubit/cubit.dart';
import 'package:socialmedia_app/modules/Login_Cubit/states.dart';
import 'package:socialmedia_app/modules/Register_Cubit/cubit.dart';
import 'package:socialmedia_app/modules/Register_Cubit/states.dart';
import 'package:socialmedia_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia_app/shared/components/constants.dart';
import 'package:socialmedia_app/shared/network/local/Cache_Helper.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'Login_Cubit/cubit.dart';
import 'Register_Screen.dart';
class Login_Screen extends StatefulWidget {
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passcontroller = TextEditingController();

  var formkey = GlobalKey<FormState>();

  bool istapped = true;
  var uIDmymiaw;
  IconData icon = Icons.visibility_outlined;

  bool comingfromanotheraccount = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<LoginCubit,LoginStates>(
            listener: (context,state) async{
              if(state is LoginSuccess) {
                uIDmymiaw = uIDmy;
                CacheHelper.PutData(key: 'uID', value: uID).then((value) async{
                  DefaultToast(message: 'Signed In Succsessfully!', fontsize: 14,Backgroundcolor: Colors.orangeAccent);
                  await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home_Layout()), (route) => false).then((value) {
                    Future.delayed(Duration(seconds: 3)).then((value) =>{
                    Phoenix.rebirth(context)
                    });
                    Phoenix.rebirth(context);
                  });
                  Phoenix.rebirth(context);
                });
                if(uIDmy != null){
                  Phoenix.rebirth(context);
                }else{
                  return null;
                }
              }
              else if(state is LoginError){
                DefaultToast(message: state.error.toString(), fontsize: 14,Backgroundcolor: Colors.grey[500]);
              }
              },
            builder: (context,state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                      key: formkey,
                      child : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 120,),
                          Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w800,
                              fontSize: 35,
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text(
                            'Login Now To Communicate With Your Friends!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 40,),
                          DefaultTextFormField(
                            LabelText: 'E-Mail',
                            controller: emailcontroller,
                            type: TextInputType.emailAddress,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Email Must Not Be Empty!';
                              }
                            },
                            prefixicon: Icons.email,
                            color : Colors.orangeAccent,
                          ),
                          SizedBox(height: 50,),
                          DefaultTextFormField(
                            LabelText: 'Password',
                            controller: passcontroller,
                            type: TextInputType.visiblePassword,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Password Must Not Be Empty!';
                              }
                            },
                            prefixicon: Icons.email,
                            SufixIcon: icon,
                            isObscure: istapped,
                            SubmitFunction: (value){
                              LoginCubit.get(context).UserLogin(emailcontroller.text, passcontroller.text);
                            },
                            isSuffixpressed: (){
                              setState(() {
                                istapped = !istapped;
                                istapped == false ? icon = Icons.visibility_off_outlined : icon = Icons.visibility_outlined;
                              });
                            },
                            color : Colors.orangeAccent,
                          ),
                          SizedBox(height: 50,),
                          if (state is LoginLoading)
                            Center(child: CircularProgressIndicator())
                          else
                            DefaultButton(
                              function: () {
                                if (formkey.currentState.validate()) {
                                 LoginCubit.get(context).UserLogin(emailcontroller.text, passcontroller.text);
                                }
                              },
                              elevation: 50,
                              text: 'LOGIN',
                              color: Colors.orangeAccent,
                              radius: 20,
                            ),
                          SizedBox(height: 40,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't Have An Account?",style: TextStyle(fontSize: 15,color: Colors.grey[600]),),
                              TextButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Register_Screen()));
                                  },
                                  child: Text('Sign Up Now!',style: TextStyle(fontWeight: FontWeight.bold),)
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                ),
              );
            },
          ),


    );
  }
}
