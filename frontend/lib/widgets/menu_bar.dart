import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/widgets/menu_dialog.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int streak;
  const CustomAppBar({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    print("W CUSTOM APP BAR ${streak}");
    return AppBar(
      backgroundColor: ColorConstants.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.menu, color: ColorConstants.whiteColor, size: 32,),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const CustomMenu(),
          );
        },
      ),
      actions: [
        Row(
          children: [
            Text(
              streak.toString(),
              style: TextStyle(
                color: ColorConstants.whiteColor,
                fontSize: FontConstants.headerFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.local_fire_department,
                color: ColorConstants.whiteColor, size: 32),
            const SizedBox(width: 15),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}