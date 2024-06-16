import 'package:flutter/material.dart';
import 'dart:math';
import '../models/action_button.dart';
import '../models/expandable_fab.dart';

class SortHomePage extends StatefulWidget {
  const SortHomePage({super.key});

  @override
  State<SortHomePage> createState() => _SortHomePageState();
}

class _SortHomePageState extends State<SortHomePage> {
  bool manipular = false;
  int numMax = 80;
  toggleButton() {
    manipular = !manipular;
  }

  var numberList = [1];
  Random random = Random();
  int num = Random().nextInt(80);

  void _showAddNumberDialog() {
    TextEditingController numberController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Número'),
          content: TextField(
            controller: numberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Digite um número"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Adicionar'),
              onPressed: () {
                String inputString = numberController.text;
                int? number = int.tryParse(inputString);
                if (number != null) {
                  setState(() {
                    numberList.add(number);
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('O número $number foi adicionado a lista.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Mostra um erro se o input não for um número
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, insira um número válido.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddNumMaxDialog() {
    TextEditingController numberController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Digite o maior número a poder ser sorteado'),
          content: TextField(
            controller: numberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Digite o número max"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Adicionar'),
              onPressed: () {
                String inputString = numberController.text;
                int? number = int.tryParse(inputString);
                if (number != null) {
                  setState(() {
                    numMax = number;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'O número máximo a ser sorteado agora é $numMax.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Mostra um erro se o input não for um número
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, insira um número válido.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: const Text("Sorteador"),
      centerTitle: true,
      elevation: 5,
    );
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final availableWidth = mediaQuery.size.width -
        mediaQuery.padding.right -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => {_showAddNumMaxDialog()},
            icon: const Icon(Icons.miscellaneous_services),
          ),
          ActionButton(
            onPressed: () {
              _showAddNumberDialog();
            },
            icon: const Icon(Icons.add),
          ),
          ActionButton(
            onPressed: () {
              setState(() {
                toggleButton();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: manipular
                      ? const Text('Ativado')
                      : const Text("Desativado"),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 15,
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SizedBox(
                  width: availableWidth * 0.7,
                  height: availableHeight * 0.35,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$num',
                          style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w700,
                            fontSize: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    manipular
                        ? setState(
                            () {
                              int randomIndex =
                                  random.nextInt(numberList.length);
                              num = numberList[randomIndex];
                            },
                          )
                        : setState(
                            () {
                              num = Random().nextInt(numMax);
                            },
                          );
                  },
                  child: const Icon(
                    Icons.play_arrow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
