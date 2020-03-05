import 'package:flutter/material.dart';
import 'package:nextbussg/components/core/buttons/back_button.dart';
import 'package:nextbussg/services/theme.dart';
import 'package:nextbussg/styles/values.dart';
import 'package:photo_view/photo_view.dart';

class MRTMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = ThemeService.getTheme();

    return Stack(
      children: <Widget>[
        Container(
          child: PhotoView(
            minScale: PhotoViewComputedScale.contained * 3.5,
            // maxScale: PhotoViewComputedScale.covered * 1.8,
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            imageProvider: theme == 'dark'
                ? AssetImage("assets/mrt/mrt-dark.png")
                : AssetImage("assets/mrt/mrt-light.png"),
          ),
        ),
        Positioned(
          // adding safeArea padding
          top: MediaQuery.of(context).padding.top + Values.pageHorizontalPadding,
          left: Values.pageHorizontalPadding,
          child: AppBackButton(),
        ),
      ],
    );
  }
}