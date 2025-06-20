import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/auth.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'package:frontend/widgets/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorConstants.black.withOpacity(0.5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: ColorConstants.background,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                FutureBuilder<User?>(
                  future: UserStorage().getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text(
                        "Nieznany użytkownik",
                        style: TextStyle(
                          color: ColorConstants.white,
                          fontSize: FontConstants.largeHeaderFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return Text(
                      snapshot.data!.username,
                      style: TextStyle(
                        color: ColorConstants.white,
                        fontSize: FontConstants.largeHeaderFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "AVATAR",
                  backgroundColor: ColorConstants.light,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouteConstants.avatarRoute);
                  }
                ),
                const SizedBox(height: 20),
                CustomButton(
                    text: "KALENDARZ ZADAŃ",
                    backgroundColor: ColorConstants.light,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouteConstants.calendarRoute);
                    }
                ),
                const SizedBox(height: 20),
                CustomButton(
                    text: "ŚCIEŻKI ZADAŃ",
                    backgroundColor: ColorConstants.light,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouteConstants.taskRoute);
                    }
                ),
                const SizedBox(height: 20),
                CustomButton(
                    text: "MÓJ DZIENNIK",
                    backgroundColor: ColorConstants.light,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouteConstants.homeRoute);
                    }
                ),
                const SizedBox(height: 20),
                CustomButton(
                    text: "STUDNIA WIEDZY",
                    backgroundColor: ColorConstants.light,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouteConstants.homeRoute);
                    }
                ),
                const SizedBox(height: 20),
                CustomButton(
                    text: "SEKCJA SOS",
                    backgroundColor: ColorConstants.light,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouteConstants.homeRoute);
                    }
                ),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    CustomButton(
                        text: "KONTO",
                        backgroundColor: ColorConstants.semiLight,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouteConstants.homeRoute);
                        }
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        text: "WYLOGUJ SIĘ",
                        backgroundColor: ColorConstants.dark,
                        onPressed: () {
                          BlocProvider.of<AuthenticationCubit>(context).logout();
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRouteConstants.loginRoute,
                              (route) => false
                          );
                        }
                    ),
                  ]
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}
