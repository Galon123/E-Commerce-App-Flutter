import 'package:e_commerce_app/providers/user_provider.dart';
import 'package:e_commerce_app/screens/auth/login_screen.dart';
import 'package:e_commerce_app/screens/auth/register_screen.dart';
import 'package:e_commerce_app/screens/extras/item_detail.dart';
import 'package:e_commerce_app/screens/main_hub.dart';
import 'package:e_commerce_app/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.setup();

  bool sessionExists = await ApiClient.hasValidSession();

  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MarketplaceApp(isLoggedIn: sessionExists),
    )
  );
}

class MarketplaceApp extends StatelessWidget {

  final bool isLoggedIn;
  const MarketplaceApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn? '/home' :'/login',
      routes: {
        '/register' : (context) => const RegisterScreen(),
        '/login' : (context) => const LoginScreen(),
        '/home' : (context) => const MainNavigationHub(),
      },
    );
  }
}