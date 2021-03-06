import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/bottom_sheets/players_game_heroes_bottom.dart';
import 'package:munchkin/ui/components/bottom_sheets/players_settings_bottom.dart';
import 'package:munchkin/ui/components/new_player.dart';
import 'package:munchkin/ui/components/player_tile.dart';
import 'package:munchkin/ui/keys/widget_keys.dart';

class PlayersPage extends StatelessWidget {
  final Function(Player) onBattle;
  PlayersPage({@required this.onBattle});
  @override
  Widget build(BuildContext context) {
    final players =
        context.select<GameCubit, List<Player>>((cubit) => cubit.state.players);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            'Players',
            key: Key(PlayersPageTitle),
            style: context.theme().textTheme.headline3,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.bar_chart_rounded),
              key: Key(PlayersPageGameHeroesButton),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => PlayersGameHeroesBottom(),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.tune_rounded),
              key: Key(PlayersPageMoreOptionsButton),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => PlayersSettingsBottomSheet(),
                );
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: NewPlayerInput(),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(players
              .map((player) => PlayerTile(player: player, onBattle: onBattle))
              .toList()),
        ),
      ],
    );
  }
}
