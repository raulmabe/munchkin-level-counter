import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:munchkin/models/models.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;
import 'dart:convert';

part 'game_state.dart';

class GameCubit extends HydratedCubit<GameState> with ReplayCubitMixin {
  GameCubit() : super(GameState());

  void addPlayer(String name, {String id}) => emit(this.state.copyWith(
      players: List.unmodifiable([]
        ..addAll(this.state.players)
        ..add(Player(id: id ?? Uuid().v1(), name: name)))));

  void removePlayer(String id) {
    if (this.state.players.length > 1) {
      emit(this.state.copyWith(
          players: List.unmodifiable([]
            ..addAll(this.state.players.where((player) => player.id != id)))));
    } else {
      emit(GameState());
    }
  }

  void addLevelToPlayer(String id, int count) {
    int newLevel = 0;

    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        newLevel = math.max(player.level + count, 1);
        return player.copyWith(level: newLevel);
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));

    if (newLevel >= this.state.maxLevelTrigger)
      emit(this.state.copyWith(gameFinished: true));
  }

  void addGearToPlayer(String id, int count) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(gear: math.max(player.gear + count, 0));
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void toggleGenderOfPlayer(String id) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(
            gender: player.gender == Gender.MALE ? Gender.FEMALE : Gender.MALE);
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void killPlayer(String id) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(gear: 0);
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void resetPlayer(String id) {
    List<Player> list = this.state.players.map((player) {
      if (player.id == id) {
        return player.copyWith(gear: 0, level: 1);
      }
      return player;
    }).toList();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void shufflePlayers() {
    List<Player> list = List.from(this.state.players);
    list.shuffle();

    emit(this.state.copyWith(players: List.unmodifiable(list)));
  }

  void resetPlayers() {
    List<Player> list = this.state.players.map((player) {
      return player.copyWith(gear: 0, level: 1);
    }).toList();

    emit(GameState(
      players: List.unmodifiable(list),
    ));
  }

  void restartGame() => emit(GameState());

  void changeMaxLevel(int maxLevel) {
    if (maxLevel > 1) {
      emit(this.state.copyWith(maxLevelTrigger: maxLevel));
    }
  }

  @override
  GameState fromJson(Map<String, dynamic> json) => GameState.fromMap(json);

  @override
  Map<String, dynamic> toJson(GameState state) => state.toMap();
}
