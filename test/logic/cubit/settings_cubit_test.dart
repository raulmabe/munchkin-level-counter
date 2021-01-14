import 'package:flutter_test/flutter_test.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:munchkin/logic/cubit/settings_cubit.dart';
import 'package:munchkin/models/munchkin.dart';

void main() {
  group('Settings Cubit', () {
    SettingsCubit settingsCubit;

    setUp(() {
      settingsCubit = SettingsCubit();
    });

    tearDown(() {
      settingsCubit.close();
    });

    test('The initial settings are screen wake locked false', () {
      expect(settingsCubit.state.screenWakeLocked, false);
    });

    blocTest('Togggle screen wake locked',
        build: () => settingsCubit,
        act: (SettingsCubit cubit) =>
            cubit..toggleScreenWake()..toggleScreenWake(),
        expect: [
          SettingsState(screenWakeLocked: true),
          SettingsState(screenWakeLocked: false)
        ]);
  });
}
