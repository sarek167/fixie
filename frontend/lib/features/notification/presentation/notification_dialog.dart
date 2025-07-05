import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/constants/avatar_storage.dart';
import 'package:frontend/widgets/button.dart';

class CustomAlert extends StatelessWidget {
  final Map<String, dynamic> data;

  const CustomAlert({
    required this.data,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        data['title'] ?? "Powiadomienie",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: FontConstants.largeHeaderFontSize
        )
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (data['container_name'] != null && data['blob_name'] != null)
            SizedBox(
              width: 100,
              height: 100,
              child: Transform.scale(
                scale: 4,
                child: Image.network(
                  'https://${AvatarStorage.storageName}.blob.core.windows.net/${data["container_name"]}/${data["blob_name"]}.png',
                  filterQuality: FilterQuality.none,
                ),
              ),
            ),

          SizedBox(height: 10),
          Text(
            data['message'] ?? 'Otrzymałeś powiadomienie!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontConstants.standardFontSize,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          text: "OK",
          width: 100,
          backgroundColor: ColorConstants.semiLight,
          onPressed: () => Navigator.of(context).pop()
        )
      ],
    );
  }
}
