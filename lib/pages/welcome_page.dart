import 'package:blog_app/screens/authScreens/signin_page.dart';
import 'package:blog_app/screens/authScreens/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:http/http.dart'as http;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin{

  AnimationController? _controller1;
  Animation<Offset>? animation1;

  AnimationController? _controller2;
  Animation<Offset>? animation2;
  bool isLogged= false;
  Map data={};
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //animation1
    _controller1=AnimationController(duration: Duration(milliseconds: 1000),vsync: this);
    animation1= Tween<Offset>(
      begin:Offset(0.0, 8.0),
      end: Offset(0.0,0.0)
    ).animate(CurvedAnimation(parent: _controller1!, curve: Curves.easeIn));

    //animation2
    _controller2=AnimationController(duration: Duration(milliseconds: 2000),vsync: this);
    animation2= Tween<Offset>(
        begin:Offset(0.0, 8.0),
        end: Offset(0.0,0.0)
    ).animate(CurvedAnimation(parent: _controller2!, curve: Curves.elasticIn));


    _controller1!.forward();
    _controller2!.forward();
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller1!.dispose();
    _controller2!.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.green
            ],
            begin: FractionalOffset(0.0, 1.0),
            end:FractionalOffset(0.0, 1.0),
            stops: [0.0,1.0],
            tileMode: TileMode.repeated,
          )
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
          child: Column(
            children: [
              SizedBox(height: 30,),
              SlideTransition(
                position: animation1!,
                child: Text("iBrid", style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),),
              ),

              SizedBox(height: MediaQuery.of(context).size.height/6 ,),
              SlideTransition(
                position: animation1!,
                child: Text("Great stories for Great Peraon",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  letterSpacing: 2,
                ),),
              ),
              SizedBox(height: 20,),
              boxContainer("assets/google.png", "SignUp with Google",null),


              SizedBox(height: 20,),
              boxContainer("assets/facebook.png", "SignUp with FaceBook", onFBLogin),

              SizedBox(height: 20,),
              boxContainer("assets/email.png", "SignUp with Email",onEmailClick),

              SizedBox(height: 20,),

              SlideTransition(
                position: animation2!,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account",
                      style: TextStyle(color: Colors.grey, fontSize: 17) ,),
                    SizedBox(width: 20,),
                    InkWell
                      (onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInPage()));

                    },
                      child: Text("SignIn",
                        style: TextStyle(color: Colors.greenAccent,
                            fontSize: 17,
                          fontWeight: FontWeight.bold
                        ) ,),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  onFBLogin()async{
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
     // var response= await http.get("https://graph.facebook.com")
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");

      setState(() {
        isLogged=true;
        data=userData;
      });
    } else {
      print(result.status);
      print(result.message);
    }

  }
  onEmailClick(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpPage()));
  }

  Widget boxContainer(String path, String text, onClick){
  return SlideTransition(
    position: animation2!,
    child: InkWell(
      onTap: onClick,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width-100,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              children: [
                Image.asset(path,
                height: 20, width: 25,),
                SizedBox(width: 10,),
                Text(text, style: TextStyle
                  (fontSize: 16, color: Colors.black87)
                  ,)
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

}
