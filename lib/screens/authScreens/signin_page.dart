
import 'package:blog_app/pages/home_page.dart';
import 'package:blog_app/screens/authScreens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isvisible= true;
  final _globalkey= GlobalKey<FormState>();


  TextEditingController _emailController= TextEditingController();
  TextEditingController _passwordController= TextEditingController();
  TextEditingController _passwordonfirmController= TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
          // height: MediaQuery
          //     .of(context)
          //     .size
          //     .height,
          // width: MediaQuery
          //     .of(context)
          //     .size
          //     .width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.green
              ],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated,
            ),
          ),
          child: Form(
            key: _globalkey ,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign In', style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),),
                  SizedBox(height: 20.0,),
                  emailTextField(),
                  SizedBox(height: 15,),
                  passwordTextField(),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Forgot Password", style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUpPage()));
                        },
                        child: Text('New User?',style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        )),
                      ),
                    ],),
                  SizedBox(height: 20.0,),
                  Provider.of<LoginRegisterProvider>(context,listen: true).isloading==true?Center(child: CircularProgressIndicator(),):
                  InkWell(
                    onTap: () async {
                      if(_globalkey.currentState!.validate()){
                        //send the rest server
                        Map<String, String> data={
                          "email":_emailController.text,
                          "password":_passwordController.text,
                        };

                        var res= await Provider.of<LoginRegisterProvider>(context,listen: false).loginOrRegister('/users/login', data);
                        print('dslsllllllllllllllll$res');
                        if(Provider.of<LoginRegisterProvider>(context,listen:false).token!=null){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>HomePage()), (route) => false);
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: res['message'],
                              toastLength: Toast.LENGTH_LONG ,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16,
                              timeInSecForIosWeb: 1);

                        }


                      }
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xff00A86B),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),)),
                    ),
                  ),



                ],
              ),
            ),
          ),
        )
    );
  }


  Widget emailTextField(){
    return Column(
      children: [
        Text('Email'),
        TextFormField(
          controller: _emailController,
          validator: (value){
            if(value!.isEmpty){
              return "email Can't be empty";
            }
            if(!value.contains('@')){
              return "Email is invalid";
            }
            return null;
          },
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 2
                  )
              )
          ),
        )
      ],
    );
  }

  Widget passwordTextField(){
    return Column(
      children: [
        Text('Password'),
        TextFormField(
          controller: _passwordController,
          validator: (value){
            if(value!.isEmpty){
              return "Password Can't be empty";
            }
            if(value.length<8){
              return "Password length must be greater >= 8";
            }
            return null;
          },
          obscureText: isvisible,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    isvisible=!isvisible;
                  });
                },
                icon: Icon(isvisible==true?Icons.visibility_off: Icons.visibility),),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 2
                  )
              )
          ),
        )
      ],
    );
  }
}
