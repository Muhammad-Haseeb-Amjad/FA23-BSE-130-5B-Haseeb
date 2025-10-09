import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const LudoApp());
}

class LudoApp extends StatelessWidget {
  const LudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Fun!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const LudoHomePage(),
    );
  }
}

class LudoHomePage extends StatefulWidget {
  const LudoHomePage({super.key});

  @override
  State<LudoHomePage> createState() => _LudoHomePageState();
}

class _LudoHomePageState extends State<LudoHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> players = [];
  final List<int> scores = [];
  final List<int> roundsPlayed = [];

  int currentPlayerIndex = 0;
  bool gameOver = false;
  int diceNumber = 1;

  void addPlayer() {
    if (_controller.text
        .trim()
        .isNotEmpty && players.length < 4) {
      setState(() {
        players.add(_controller.text.trim());
        scores.add(0);
        roundsPlayed.add(0);
        _controller.clear();
      });
    }
  }

  void rollDice() {
    if (players.isEmpty || gameOver) return;

    int roll = Random().nextInt(6) + 1;
    setState(() {
      diceNumber = roll;
      scores[currentPlayerIndex] += roll;

      if (roll != 6) {
        roundsPlayed[currentPlayerIndex]++;
      }

      // Check if all players completed 5 rounds
      if (roundsPlayed.every((r) => r >= 5)) {
        gameOver = true;
        showWinnerDialog();
        return;
      }

      // Change turn if roll is not 6
      if (roll != 6) {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      }
    });
  }

  void showWinnerDialog() {
    int maxScore = scores.reduce(max);
    List<String> winners = [];
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] == maxScore) {
        winners.add(players[i]);
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text("🏆 Game Over!"),
            content: Text(
              winners.length > 1
                  ? "It's a tie between ${winners.join(
                  ", ")}!\nScore: $maxScore"
                  : "${winners.first} wins with $maxScore points!",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    scores.fillRange(0, scores.length, 0);
                    roundsPlayed.fillRange(0, roundsPlayed.length, 0);
                    currentPlayerIndex = 0;
                    gameOver = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text("🔁 Try Again"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    players.clear();
                    scores.clear();
                    roundsPlayed.clear();
                    currentPlayerIndex = 0;
                    gameOver = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text("✅ OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFFFD6E6A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.casino, color: Colors.white, size: 28),
                    SizedBox(width: 8),
                    Text(
                      "Ludo Fun!",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Add Player Box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                    TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Enter player name",
                      labelStyle:
                      const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.white54),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: addPlayer,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Add Player",
                      style: TextStyle(color: Colors.white),
                    ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                if (players.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        "It's ${players[currentPlayerIndex]}'s Turn!",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        "Image/Dice$diceNumber.png",
                        height: 150,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: rollDice,
                        icon: const Icon(Icons.casino_outlined),
                        label: const Text("Roll Dice"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepOrangeAccent,
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 25),

                // Scoreboard
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Scoreboard",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (players.isEmpty)
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            "No players added yet.",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        )
                      else
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                          List.generate(players.length, (index) {
                            return Card(
                              color: Colors
                                  .primaries[index %
                                  Colors.primaries.length]
                                  .shade400,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              child: ListTile(
                                title: Text(
                                  players[index],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing: Text(
                                  "Score:${scores[index]}  (${roundsPlayed[index]}/5)",
                                  style:
                                  const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
