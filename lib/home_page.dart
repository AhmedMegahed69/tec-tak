import 'package:flutter/material.dart';
import 'package:tec_tak/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = ' ';
  Game game = Game();
  bool isSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  children: [
                    ...firstblok(),
                    expandedGrid(context),
                    ...lastblock()
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...firstblok(),
                        ...lastblock(),
                      ],
                    )),
                    expandedGrid(context),
                  ],
                )),
    );
  }

  List<Widget> firstblok() {
    return [
      SwitchListTile.adaptive(
          tileColor: const Color.fromARGB(255, 46, 21, 138),
          title: const Text('Turn on/off Two Player'),
          activeColor: const Color.fromARGB(255, 58, 55, 44),
          value: isSwitch,
          onChanged: (newval) {
            setState(() {
              isSwitch = newval;
            });
          }),
      Text(
        "It's $activePlayer turn".toUpperCase(),
        style: const TextStyle(
          fontSize: 52,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> lastblock() {
    return [
      Text(
        result,
        style: const TextStyle(
          fontSize: 42,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            result = '';
            turn = 0;
            activePlayer = 'X';
            gameOver = false;
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text('repeat the game'),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      )
    ];
  }

  Expanded expandedGrid(BuildContext context) {
    return Expanded(
        child: GridView.count(
            padding: const EdgeInsets.all(8),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 1.0,
            crossAxisCount: 3,
            children: List.generate(
                9,
                (index) => InkWell(
                      onTap: gameOver ? null : () => ontap(index),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            Player.playerX.contains(index)
                                ? 'X'
                                : Player.playerO.contains(index)
                                    ? 'O'
                                    : ' ',
                            style: TextStyle(
                                color: Player.playerX.contains(index)
                                    ? Colors.blue
                                    : Colors.red,
                                fontSize: 52),
                          ),
                        ),
                      ),
                    ))));
  }

  ontap(int index) async {
    if (Player.playerX.isEmpty ||
        !Player.playerX.contains(index) && Player.playerO.isEmpty ||
        !Player.playerO.contains(index)) game.playGame(index, activePlayer);
    updatestate();
    if (isSwitch == false && gameOver == false && turn != 9) {
      await game.autoplay(activePlayer);
      updatestate();
    }
  }

  void updatestate() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;
      String winnerplayer = game.checkwinner();
      if (winnerplayer != '') {
        gameOver = true;
        result = '$winnerplayer is The Winner';
      } else if (!gameOver && turn == 9) {
        result = 'It\'s Draw!';
      }
    });
  }
}
