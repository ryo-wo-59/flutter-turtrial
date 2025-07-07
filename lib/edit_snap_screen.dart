import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_turtrial/l10n/app_localizations.dart';
import 'package:flutter_turtrial/gen/assets.gen.dart';
import 'package:image/image.dart' as image_lib;

class ImageEditScreen extends StatefulWidget {
  const ImageEditScreen({super.key, required this.imageBitmap});

  final Uint8List imageBitmap;

  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();

}

class _ImageEditScreenState extends State<ImageEditScreen> {

  late Uint8List _imageBitmap;

  @override
  void initState() {
    super.initState();
    _imageBitmap = widget.imageBitmap;
  }

  void _rotateImage() {
    // 画像データをデコードする
    final image = image_lib.decodeImage(_imageBitmap);
    if (image == null) return;
    // 画像を90度回転させる
    final rotateImage = image_lib.copyRotate(image, angle: 90);
    // 画像をエンコードして状態を更新する
    setState(() {
      _imageBitmap = image_lib.encodeBmp(rotateImage);
    });
  }
  
  void _flipImage() {
    // 画像データをデコードする
    final image = image_lib.decodeImage(_imageBitmap);
    if (image == null) return;
    // 画像を水平方向に反転させる
    final flipImage = image_lib.copyFlip(image, direction: image_lib.FlipDirection.horizontal);

    setState(() {
      _imageBitmap = image_lib.encodeBmp(flipImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.imageEditScreenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(_imageBitmap),
            IconButton(
              onPressed: () => _rotateImage(),
              icon: Assets.rotateIcon.svg(
                width: 24,
                height: 24,
              ),
            ),
            IconButton(
              onPressed: () => _flipImage(),
              icon: Assets.flipIcon.svg(
                width: 24,
                height: 24,
              ),
            )
          ]
        )
      )
    );
  }
}