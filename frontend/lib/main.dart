import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/core/services/auth_service.dart';
import 'package:frontend/features/authentication/logic/auth.dart';
import 'package:frontend/features/authentication/presentation/login_screen.dart';
import 'package:frontend/features/authentication/presentation/register_screen.dart';
import 'package:frontend/features/avatar/data/avatar_cubit.dart';
import 'package:frontend/features/avatar/presentation/avatar_screen.dart';
import 'package:frontend/features/home/presentation/home_screen.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/features/tasks/presentation/calendar_screen.dart';
import 'package:frontend/features/tasks/presentation/path_screen.dart';
import 'package:frontend/features/tasks/presentation/task_screen.dart';
import 'package:frontend/features/tasks/presentation/single_task_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationCubit(authService: AuthService())),
        BlocProvider(create: (_) => AvatarCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          locale: const Locale('pl', 'PL'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pl', 'PL'),
          ],
        navigatorKey: navigatorKey,
        title: 'Fixie',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: {
          AppRouteConstants.loginRoute: (context) => LoginScreen(),
          AppRouteConstants.registerRoute: (context) => RegisterScreen(),
          AppRouteConstants.homeRoute: (context) => HomeScreen(),
          AppRouteConstants.taskRoute: (context) => TaskScreen(),
          AppRouteConstants.pathRoute: (context) => PathScreen(),
          AppRouteConstants.calendarRoute: (context) => CalendarScreen(),
          AppRouteConstants.avatarRoute: (context) => AvatarScreen()
        },
        home: LoginScreen()
      ),
    );
  }
}