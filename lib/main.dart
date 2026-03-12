import 'package:e_commerce_app/providers/user_provider.dart';
import 'package:e_commerce_app/screens/auth/login_screen.dart';
import 'package:e_commerce_app/screens/auth/register_screen.dart';
import 'package:e_commerce_app/screens/main/my_bids.dart';
import 'package:e_commerce_app/screens/main/my_listings.dart';
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
        ChangeNotifierProvider(create: (_) => UserProvider(initialLoginState: sessionExists))
      ],
      child: MarketplaceApp(),
    )
  );
}

class MarketplaceApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final userProvider = context.watch<UserProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: userProvider.username == "Guest"
      ? const LoginScreen() 
      : const MainNavigationHub(),
      routes: {
        '/register' : (context) => const RegisterScreen(),
        '/login' : (context) => const LoginScreen(),
        '/home' : (context) => const MainNavigationHub(),
        '/my_bids' : (context) => const MyBids(),
        '/my_listings' : (context) => const MyListings()
      },
    );
  }
}