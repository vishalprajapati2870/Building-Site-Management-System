import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:provider/provider.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:building_site_build_by_vishal/globals/auth_provider.dart';
import 'package:building_site_build_by_vishal/globals/app_state.dart';
import 'package:building_site_build_by_vishal/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

@NowaGenerated({'visibleInNowa': false})
class MyApp extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DataProvider>(
      create: (context) => DataProvider(),
      child: ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(),
        child: ChangeNotifierProvider<AppState>(
          create: (context) => AppState(),
          builder: (context, child) => MaterialApp(
            theme: AppState.of(context).theme,
            initialRoute: 'HomePage',
            routes: {'HomePage': (context) => const HomePage()},
          ),
        ),
      ),
    );
  }
}

@NowaGenerated()
late final SharedPreferences sharedPrefs;

@NowaGenerated()
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}
