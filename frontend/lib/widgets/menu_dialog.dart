import 'package:flutter/material.dart';
import 'package:frontend/widgets/button.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Przezroczyste tło
      child: Align(
        alignment: Alignment.centerLeft, // Przesunięcie do lewej
        child: Container(
          width: 250, // Ustaw szerokość menu
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "USERNAME", //TO DO zmienić na nazwę aktualnego użytkownika
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "AVATAR",
                backgroundColor: Colors.orange,
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                }
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "KALENDARZ ZADAŃ",
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  }
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "ŚCIEŻKI ZADAŃ",
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  }
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "MÓJ DZIENNIK",
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  }
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "STUDNIA WIEDZY",
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  }
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "SEKCJA SOS",
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  }
              ),
              const SizedBox(height: 100),
              CustomButton(
                  text: "KONTO",
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  }
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "WYLOGUJ SIĘ",
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
