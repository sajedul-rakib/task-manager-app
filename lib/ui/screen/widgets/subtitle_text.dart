import 'package:flutter/material.dart';

import '../utils/text_style.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({
    super.key,
    required this.subtitleTextTitle,
  });

  final String subtitleTextTitle;

  @override
  Widget build(BuildContext context) {
    return Text(subtitleTextTitle, style: subtitleTextStyle);
  }
}
