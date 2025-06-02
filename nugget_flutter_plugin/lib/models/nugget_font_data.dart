import 'dart:typed_data';

import 'package:nugget_flutter_plugin/enums/NuggetFontSize.dart';
import 'package:nugget_flutter_plugin/enums/NuggetFontWeight.dart';

class NuggetFontData {
  final String? fontName;
  final String? fontFamily;
  final Map<NuggetFontWeight, String> fontWeightMapping;
  final Map<NuggetFontSize, int>? fontSizeMapping;
  final List<Uint8List> fontsData;

  NuggetFontData({
    this.fontName,
    this.fontFamily,
    required this.fontWeightMapping,
    this.fontSizeMapping,
    required this.fontsData,
  });

  Map<String, dynamic> toJson() => {
    'fontName': fontName,
    'fontFamily': fontFamily,
    'fontWeightMapping':
    fontWeightMapping.map((key, value) => MapEntry(key.name, value)),
    'fontSizeMapping': fontSizeMapping?.map((key, value) => MapEntry(key.name, value)),
    'fontsData': fontsData
  };
}
