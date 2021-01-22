import 'package:flutter_test/flutter_test.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:munchkin/models/models.dart';

void main() async {
  /* TestWidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(); */
  group('Gameplay Cubit', () {
    GameCubit gameCubit;

    setUp(() {
      gameCubit = GameCubit();
    });

    tearDown(() {
      gameCubit.close();
    });

    test('The initial players are 0', () {
      expect(gameCubit.state.players.length, 0);
    });

    blocTest('add one player with the default options',
        build: () => gameCubit,
        act: (GameCubit cubit) => cubit.addPlayer('Mabe', id: 'id'),
        expect: [
          GameState(players: [
            Player(
                id: 'id', name: 'Mabe', gender: Gender.MALE, level: 1, gear: 0)
          ], hasJustStarted: false)
        ]);

    group('Level related', () {
      blocTest('level up the player',
          build: () => gameCubit,
          seed: GameState(
              players: [Player(id: 'id', name: 'Mabe', level: 4)],
              hasJustStarted: false),
          act: (GameCubit cubit) => cubit.addLevelToPlayer('id', 1),
          expect: [
            GameState(
                players: [Player(id: 'id', name: 'Mabe', level: 5)],
                hasJustStarted: false)
          ]);

      blocTest('level down the player',
          build: () => gameCubit,
          seed: GameState(
              players: [Player(id: 'id', name: 'Mabe', level: 5)],
              hasJustStarted: false),
          act: (GameCubit cubit) => cubit.addLevelToPlayer('id', -1),
          expect: [
            GameState(
                players: [Player(id: 'id', name: 'Mabe', level: 4)],
                hasJustStarted: false)
          ]);

      blocTest('Minimum level a player can have is set to default',
          build: () => gameCubit,
          seed: GameState(
              players: [Player(id: 'id', name: 'Mabe', gear: 0)],
              hasJustStarted: false),
          act: (GameCubit cubit) => cubit.addLevelToPlayer('id', -1),
          expect: []);
    });

    group('Gear related', () {
      blocTest('gear up the player',
          build: () => gameCubit,
          seed: GameState(
              players: [Player(id: 'id', name: 'Mabe', gear: 0)],
              hasJustStarted: false),
          act: (GameCubit cubit) => cubit.addGearToPlayer('id', 1),
          expect: [
            GameState(
                players: [Player(id: 'id', name: 'Mabe', gear: 1)],
                hasJustStarted: false)
          ]);

      blocTest('gear down the player',
          build: () => gameCubit,
          seed: GameState(
              players: [Player(id: 'id', name: 'Mabe', gear: 5)],
              hasJustStarted: false),
          act: (GameCubit cubit) => cubit.addGearToPlayer('id', -1),
          expect: [
            GameState(
                players: [Player(id: 'id', name: 'Mabe', gear: 4)],
                hasJustStarted: false)
          ]);

      blocTest('Minimum gear a player can have is set to default',
          build: () => gameCubit,
          seed: GameState(
              players: [Player(id: 'id', name: 'Mabe')], hasJustStarted: false),
          act: (GameCubit cubit) => cubit.addGearToPlayer('id', -1),
          expect: []);
    });

    blocTest('Change the gender of the player',
        build: () => gameCubit,
        seed: GameState(
            players: [Player(id: 'id', name: 'Mabe', gender: Gender.MALE)],
            hasJustStarted: false),
        act: (GameCubit cubit) =>
            cubit..toggleGenderOfPlayer('id')..toggleGenderOfPlayer('id'),
        expect: [
          GameState(
              players: [Player(id: 'id', name: 'Mabe', gender: Gender.FEMALE)],
              hasJustStarted: false),
          GameState(
              players: [Player(id: 'id', name: 'Mabe', gender: Gender.MALE)],
              hasJustStarted: false)
        ]);

    blocTest('Reset the stats of a player',
        build: () => gameCubit,
        seed: GameState(players: [
          Player(id: 'id', name: 'Mabe', level: 1, gear: 4),
        ], hasJustStarted: false),
        act: (GameCubit cubit) => cubit..resetPlayer('id'),
        expect: [
          GameState(players: [
            Player(id: 'id', name: 'Mabe', level: 1, gear: 0),
          ], hasJustStarted: false),
        ]);

    blocTest('Remove a player',
        build: () => gameCubit,
        seed: GameState(
            players: [Player(id: 'id', name: 'Mabe')], hasJustStarted: false),
        act: (GameCubit cubit) => cubit..removePlayer('id'),
        expect: [GameState(players: [], hasJustStarted: false)]);

    blocTest('Restart the game',
        build: () => gameCubit,
        seed: GameState(players: [
          Player(id: 'id', name: 'Mabe'),
          Player(id: 'dede', name: 'dede')
        ]),
        act: (GameCubit cubit) => cubit.restartGame(),
        expect: [
          GameState(),
        ]);

    blocTest('Kill the player',
        build: () => gameCubit,
        seed: GameState(
            players: [Player(id: 'id', name: 'Mabe', level: 5, gear: 20)],
            hasJustStarted: false),
        act: (GameCubit cubit) => cubit.killPlayer('id'),
        expect: [
          GameState(
              players: [Player(id: 'id', name: 'Mabe', level: 5, gear: 0)],
              hasJustStarted: false)
        ]);

    blocTest('Reset all the players',
        build: () => gameCubit,
        seed: GameState(players: [
          Player(id: 'id', name: 'Mabe', level: 5, gear: 20),
          Player(id: 'temp_id', name: 'Temp', level: 5, gear: 20),
        ], hasJustStarted: false),
        act: (GameCubit cubit) => cubit.resetPlayers(),
        expect: [
          GameState(players: [
            Player(id: 'id', name: 'Mabe'),
            Player(id: 'temp_id', name: 'Temp')
          ], hasJustStarted: true),
        ]);
  });
}
