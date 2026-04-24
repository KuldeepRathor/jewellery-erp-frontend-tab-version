import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalImageView extends StatelessWidget {
  final String imagePath;
  const GlobalImageView({super.key, required this.imagePath});
  ImageProvider get _imageProvider {
    // ✅ auto detect network vs file
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Container(
              width: Get.width * 0.6,
              height: Get.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width * 0.4,
                    height: Get.height * 0.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
              top: 10,
              right: 20,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  )))
        ],
      ),
    );
  }
}
