import 'package:blog_app/pages/LoadingPage.dart';
import 'package:blog_app/pages/home_page.dart';
import 'package:blog_app/pages/welcome_page.dart';
import 'package:blog_app/provider/auth_provider.dart';
import 'package:blog_app/provider/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readlocalData();
  }

  Widget _page = LoadingPage();

  void readlocalData() async {
    String? token = await FlutterSecureStorage().read(key: 'token');
    if (token != null) {
      setState(() {
        _page = HomePage();
      });
    } else {
      setState(() {
        _page = WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginRegisterProvider>(
            create: (_) => LoginRegisterProvider(),),
          ChangeNotifierProvider<GlobalProvider>(
            create: (_) => GlobalProvider(),),
        ],
        child: MaterialApp(
          theme: ThemeData(
              textTheme: GoogleFonts.openSansTextTheme(
                Theme
                    .of(context)
                    .textTheme,
              )
          ),
          home: _page,
        ),

    );
  }
}


