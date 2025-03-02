import 'package:flutter/material.dart';
import 'package:frontend/widgets/menu_dialog.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.teal,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 32,),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CustomMenu(),
          );
          // Obsługa menu
        },
      ),
      actions: [
        Row(
          children: [
            const Text(
              '17', // Przykładowa liczba streak'u
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.local_fire_department, color: Colors.white, size: 32),
            const SizedBox(width: 15),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}