import 'package:nugget_flutter_plugin/enums/NuggetInterfaceStyle.dart';

class NuggetThemeData {
  final String defaultLightModeAccentHexColor;
  final String defaultDarkModeAccentHexColor;
  final NuggetInterfaceStyle deviceInterfaceStyle;

  NuggetThemeData({
    required this.defaultLightModeAccentHexColor,
    required this.defaultDarkModeAccentHexColor,
    this.deviceInterfaceStyle = NuggetInterfaceStyle.system,
  });

  Map<String, dynamic> toJson() => {
        'defaultLightModeAccentHexColor': defaultLightModeAccentHexColor,
        'defaultDarkModeAccentHexColor': defaultDarkModeAccentHexColor,
        'deviceInterfaceStyle': deviceInterfaceStyle.name,
      };
}
