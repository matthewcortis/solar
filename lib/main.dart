import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import './routes.dart';
import 'package:solarmaxapp/package/controllers/login/login_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginController>(
          create: (_) => LoginController(),
        ),
      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) => const SolarMaxApp(),
      ),
    ),
  );
}

class SolarMaxApp extends StatelessWidget {
  const SolarMaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Solar Max',
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          builder: DevicePreview.appBuilder,
          locale: DevicePreview.locale(context),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          routes: AppRoutes.getRoutes(),
          initialRoute: AppRoutes.splashScreen,
        );
      },
    );
  }
}
