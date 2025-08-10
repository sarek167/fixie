import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'package:frontend/features/authentication/presentation/user_form.dart';
import 'package:frontend/widgets/menu_bar.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: UserStorage().getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: const CustomAppBar(streak: 0),
                body: Center(
                    child: Text(
                        "Error while loading streak: ${snapshot.error}"))
            );
          } else {
            return Scaffold(
              backgroundColor: ColorConstants.background,
              appBar: CustomAppBar(streak: snapshot.data!.streak),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const UserForm(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }
    );
  }
}
