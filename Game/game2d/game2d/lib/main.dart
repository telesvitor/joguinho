import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game2d/overlays/boinfire_menu.dart';
import 'package:game2d/overlays/death_screen.dart';
import 'package:game2d/overlays/hud_overlay';
import 'package:game2d/overlays/pause_menu.dart';
import 'package:game2d/overlays/upgrade_menu.dart';
import 'package:game2d/overlays/victory.dart';
import 'package:game2d/screens/intro_screen.dart';
import 'package:game2d/screens/main_menu.dart';
import 'nine_souls_game.dart';

void main() {
  runApp(const NineSoulsApp());
}

class NineSoulsApp extends StatelessWidget {
  const NineSoulsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nine Souls',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GameEntryPoint(),
    );
  }
}

class GameEntryPoint extends StatefulWidget {
  const GameEntryPoint({super.key});
  @override
  State<GameEntryPoint> createState() => _GameEntryPointState();
}

class _GameEntryPointState extends State<GameEntryPoint> {
  late NineSoulsGame _game;
  bool _showMenu = true;
  bool _showIntro = false;

  @override
  void initState() {
    super.initState();
    _game = NineSoulsGame(onReturnToMenu: _goToMenu);
  }

  void _goToMenu() {
    setState(() {
      _showMenu = true;
      _showIntro = false;
      _game = NineSoulsGame(onReturnToMenu: _goToMenu);
    });
  }

  void _startIntro() {
    setState(() => _showIntro = true);
  }

  void _startGame() {
    setState(() {
      _showMenu = false;
      _showIntro = false;
    });
    _game.startNewGame();
  }

  @override
  Widget build(BuildContext context) {
    if (_showMenu) {
      return MainMenuScreen(onPlay: _startIntro, onCredits: () {});
    }
    if (_showIntro) {
      return IntroScreen(onContinue: _startGame);
    }

    return GameWidget<NineSoulsGame>(
      game: _game,
      overlayBuilderMap: {
        'HUD':         (ctx, game) => HudOverlay(game: game),
        'Death':       (ctx, game) => DeathScreen(game: game, onMenu: _goToMenu),
        'Victory':     (ctx, game) => VictoryScreen(game: game, onMenu: _goToMenu),
        'Bonfire':     (ctx, game) => BonfireMenu(game: game),
        'Upgrade':     (ctx, game) => UpgradeMenu(game: game),
        'Pause':       (ctx, game) => PauseMenu(game: game, onMenu: _goToMenu),
      },
      initialActiveOverlays: const ['HUD'],
    );
  }
}
