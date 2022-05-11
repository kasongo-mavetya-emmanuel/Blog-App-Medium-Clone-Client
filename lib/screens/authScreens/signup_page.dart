import 'package:blog_app/provider/auth_provider.dart';
import 'package:blog_app/services/newtworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../provider/homepage_level_provider.dart';
import '../../pages/home_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isvisible= true;
  final _globalkey= GlobalKey<FormState>();
  NetworkHandler networkHandler= NetworkHandler();
  TextEditingController _usernameController= TextEditingController();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign Up with email', style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),),
                SizedBox(height: 20.0,),
                usernameTextField(),
                emailTextField(),
                passwordTextField(),
                SizedBox(height: 20,),
              Provider.of<LoginRegisterProvider>(context,listen: true).isloading==true?Center(child: CircularProgressIndicator(),):
              InkWell(
                  onTap: ()async{
                    if(_globalkey.currentState!.validate()){
                      //send the rest server
                      Map<String, String> data={
                        "name": _usernameController.text,
                        "email":_emailController.text,
                        "password":_passwordController.text,
                        "passwordConfirm":_passwordController.text,
                      };

                      var res= await Provider.of<LoginRegisterProvider>(context).loginOrRegister('/users/register', data);
                      if(Provider.of<LoginRegisterProvider>(context, listen: false).token!=null){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>HomePage()), (route) => false);
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: res['data'],
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
                    child: Center(child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),)),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  Widget usernameTextField(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10.0),
      child: Column(
        children: [
          Text('Username'),
          TextFormField(
            controller: _usernameController,
            validator: (value){
              if(value!.isEmpty){
                 return "Username Can't be empty";
              }
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
      ),
    );
  }

  Widget emailTextField(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10.0),
      child: Column(
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
      ),
    );
  }

  Widget passwordTextField(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10.0),
      child: Column(
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
              helperText: "password should be >=8",
                helperStyle: TextStyle(
                  fontSize: 16
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                    )
                )
            ),
          )
        ],
      ),
    );
  }

  Widget passwordCofirmTextField(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10.0),
      child: Column(
        children: [
          Text('PasswordConfirm'),
          TextFormField(
            controller: _passwordonfirmController,
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
                helperText: "password should be >=8",
                helperStyle: TextStyle(
                    fontSize: 16
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                    )
                )
            ),
          )
        ],
      ),
    );
  }
  }
