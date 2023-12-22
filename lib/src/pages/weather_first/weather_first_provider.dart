import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_asyncvalue_details/src/models/cities.dart';

part 'weather_first_provider.g.dart';

@riverpod
class WeatherFirstAsyncNoti extends _$WeatherFirstAsyncNoti {
  @override
  FutureOr<String> build() {
    return _getTemp(Cities.seoul);
  }

  Future<String> _getTemp(Cities city) async {
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

  Future<void> getTemperature(Cities city) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _getTemp(city));
  }
}
