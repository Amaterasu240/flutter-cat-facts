import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ИМПОРТ RIVERPOD
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ui/view/auth_wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Cats facts',
          theme: FlexThemeData.light(
            scheme: FlexScheme.deepPurple, 
            useMaterial3: true, 
            subThemesData: const FlexSubThemesData(defaultRadius: 12.0,),
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.deepPurple,
            useMaterial3: true,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 15,
            subThemesData: const FlexSubThemesData(
              defaultRadius: 12.0, 
              cardElevation: 4,
            ),
          ),
          themeMode: ThemeMode.system,
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          home: const AuthWrapper(),
        );
      },
    );
  }
}