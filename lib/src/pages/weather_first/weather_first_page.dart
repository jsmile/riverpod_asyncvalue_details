import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_asyncvalue_details/src/extensions/async_value_xx.dart';
import 'package:riverpod_asyncvalue_details/src/pages/weather_first/weather_first_provider.dart';

import '../../models/cities.dart';
import '../../utils/ansi_color_debug.dart';

// 현재 파일에서 공유할 선택된 도시
int _selectedIndex = 1;

class WeatherFirstPage extends ConsumerWidget {
  const WeatherFirstPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Error 시 Dialog 띄우기
    ref.listen<AsyncValue<String>>(
      weatherFirstAsyncNotiProvider,
      (prev, next) {
        if (next.hasError && !next.isLoading) {
          // if (next is AsyncError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(next.error.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
    );

    final weather =
        ref.watch(weatherFirstAsyncNotiProvider); // AsyncValue<String>
    debugPrint(info('### weather : ${weather.toString()}'));
    debugPrint(info('### prop : ${weather.props}'));

    debugPrint(info('### weather.value : ${weather.value}'));

    try {
      debugPrint(info('### requireValue : ${weather.requireValue}'));
    } on StateError {
      debugPrint(error('### requireValue : StateError'));
    } catch (e) {
      debugPrint(error('### requireValue error: ${e.toString()}'));
    }

    debugPrint(info('### =================================='));

    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncValue Details - First'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _selectedIndex = 1;
              ref.invalidate(weatherFirstAsyncNotiProvider);
            },
          ),
        ],
      ),
      body: Center(
        child: weather.when(
          skipError: true, // error 시 error 대신 이전 값 사용
          skipLoadingOnRefresh: false, // refresh 시 loading 허용.
          data: (temperature) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  temperature,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 20.0),
                const GetWeatherButton(),
              ],
            );
          },
          error: (e, st) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const GetWeatherButton(),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class GetWeatherButton extends ConsumerWidget {
  const GetWeatherButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      child: const Text('Get Weather'),
      onPressed: () {
        final cityIndex = _selectedIndex % 4;
        final city = Cities.values[cityIndex];

        _selectedIndex++;
        ref.read(weatherFirstAsyncNotiProvider.notifier).getTemperature(city);
      },
    );
  }
}
