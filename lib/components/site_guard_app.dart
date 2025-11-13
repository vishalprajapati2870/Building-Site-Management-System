import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:provider/provider.dart';
import 'package:building_site_build_by_vishal/globals/app_state.dart';
import 'package:building_site_build_by_vishal/globals/auth_provider.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:building_site_build_by_vishal/pages/login_page.dart';

@NowaGenerated()
class SiteGuardApp extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const SiteGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, child) => MaterialApp(
          title: 'SiteGuard',
          debugShowCheckedModeBanner: false,
          theme: appState.theme,
          home: const LoginPage(),
        ),
      ),
    );
  }
}
