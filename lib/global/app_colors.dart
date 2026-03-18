import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class AppColours {
  static const dark_blue = Color.fromRGBO(0, 99, 159, 10);
  static const light_blue = Color.fromRGBO(30, 144, 181, 10);
  static const purple_gradient_color1 = Color(0xff18b9b6);
  static const purple_gradient_color2 = Color(0xff18b9b6);
  static const blue_gredient_1 = Color(0xff0A71FE);
  static const blue_gredient_2 = Color(0xff0AEFFE);

  static const primarycolor = Color.fromRGBO(
    24,
    184,
    181,
    1,
  );
  static const listtilecolor = Color.fromRGBO(243, 216, 182, 1);
  static const purple_gradient_shadow = Color(0xff18b9b6);

  static const progress_background_color = Color.fromRGBO(255, 204, 0, 1);
  static const light_yellow_gredient1 = Color(0xffF9CF45);
  static const light_yellow_gredient2 = Color(0xffEE9B1D);
  static const light_red_gredient1 = Color(0xffFF5757);
  static const light_red_gredient2 = Color(0xffFF3E3F);
  static const light_red_stop_gredient1 = Color(0xffF15432);
  static const light_red_stop_gredient2 = Color(0xffE73F34);
  static const light_green_play_gredient1 = Color(0xff7BE445);
  static const light_green_play_gredient2 = Color(0xff22BE11);
  static const green_For_NotReally = Color(0xff28853a);
  static const ligh_green_For_NotReally = Color(0xff1ED247);
  static const purple_Lock_screen = Color(0xff18b9b6);

  static const water_level_wave1 = Color(0xff42B2FF);
  static const water_level_wave2 = Color(0xff00AEFF);

  static const green_gradient_color1 = Color(0xff21BE10);
  static const green_gradient_color2 = Color(0xff7BDE56);

  static const green_gradient_shadow = Color(0x902fc31c);
  static const red_gradient_shadow = Color(0x90ff4343);

  static const txt_grey = Color.fromRGBO(207, 212, 214, 1);
  static const txt_white = Color(0xffFFFFFF);
  static const txt_black = Color(0xff000000);
  static const txt_purple = Color(0xff18b9b6);
  static const txt_green = Color(0xff24BF12);
  static const white = Color(0xffFFFFFF);
  static const common_bg_dark = Color(0xff070E3D);
  static const rounded_rectangle_color = Color(0xff1B2153);

  static const unselected_star = Color(0x909195B6);
  static const selected_star = Color(0xffFFC804);

  static const gray_border = Color(0xff9195B6);
  static const graph_water = Color(0xff00A3FF);
  static const graph_health = Color(0xff8C3CFF);

  static const red_turn_off = Color(0xffEB5757);


  static var orange =
  (FlavorConfig.instance.name == "B2BMobile" ||
      FlavorConfig.instance.name == "B2BMobileBeta")
      ? const Color.fromRGBO(236, 106, 56, 1) // existing
      : FlavorConfig.instance.name == "B2BLondon"
      ? const Color(0xff039195) // existing
      : FlavorConfig.instance.name == "B2BLifenity"
      ? const Color(0xff1A7198)
      : const Color(0xff099609); // default


  static var blue =
  (FlavorConfig.instance.name == "B2BMobile" ||
      FlavorConfig.instance.name == "B2BMobileBeta")
      ? const Color.fromRGBO(21, 115, 175, 1) // existing
      : FlavorConfig.instance.name == "B2BLondon"
      ? const Color(0xff039195) // existing
      : FlavorConfig.instance.name == "B2BLifenity"
      ? const Color(0xff23A1DA)
      : const Color(0xff008ED6); // default


// static var orange = (FlavorConfig.instance.name == "B2BMobile" ||
  //     FlavorConfig.instance.name == "B2BMobileBeta")
  //     ? const Color.fromRGBO(236, 106, 56, 1)
  //     : FlavorConfig.instance.name == "B2BLondon"
  //     ? const Color(0xff039195)
  //     : const Color(0xff099609);
  //
  // static var blue = (FlavorConfig.instance.name == "B2BMobile" ||
  //     FlavorConfig.instance.name == "B2BMobileBeta")
  //     ? const Color.fromRGBO(21, 115, 175, 1)
  //     : FlavorConfig.instance.name == "B2BLondon"
  //     ? const Color(0xff039195)
  //     : const Color(0xff008ED6);


}
