import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'profile_form.dart';
import 'package:frontend/features/authentication/data/user_model.dart';


class ProfileModifyScreen extends StatelessWidget {
  const ProfileModifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<User?>(
                  future: UserStorage().getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text(
                        "WITAJ",
                        style: TextStyle(
                          color: ColorConstants.whiteColor,
                          fontSize: FontConstants.headerFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return Text(
                      "WITAJ ${snapshot.data!.username}",
                      style: TextStyle(
                        color: ColorConstants.whiteColor,
                        fontSize: FontConstants.headerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                const ProfileForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
