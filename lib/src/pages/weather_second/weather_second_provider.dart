import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/cities.dart';
import '../../utils/ansi_color_debug.dart';

part 'weather_second_provider.g.dart';

@riverpod
class CityNoti extends _$CityNoti {
  @override
  Cities build() {
    debugPrint(info('### CityNoti initialized'));

    ref.onDispose(() {
      debugPrint(info('### CityNoti disposed'));
    });

    return Cities.seoul;
  }

  void changeCity(Cities city) {
    state = city;
  }
}

/// 하나의 provider 가 다른 provider 를 참조하고 있을 때
/// 타 provider 의 변화에 따라 자신의 provider 도 rebuild 됨.
@riverpod
FutureOr<String> weatherAsyncSecond(WeatherAsyncSecondRef ref) async {
  debugPrint(info('### weatherAsyncSecondProvider Initialized'));

  ref.onDispose(() {
    debugPrint(info('### weatherAsyncSecondProvider ref.onDispose()'));
  });

  final city = ref.watch(cityNotiProvider); // 타 provider 참조
  await Future.delayed(const Duration(seconds: 1));

  switch (city) {
    case Cities.seoul:
      return '${city.name} - 23';
    case Cities.london:
      throw 'Fail to fetch the temperature of ${city.name}';
    case Cities.bangkok:
      throw 'Fail to fetch the temperature of ${city.name}';
    case Cities.tokyo:
      return '${city.name} - 28';
  }
}
