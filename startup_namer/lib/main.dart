import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/edicao.dart';
import 'package:startup_namer/repositorio.dart';
import 'package:startup_namer/palavras.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RandomWords(),
        '/edit': (context) => const EditPage(),
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final Repository _suggestions = Repository();
  final _saved = <Word>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  bool cardMode = false;

  @override
  void initState() {
    super.initState();
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _saved.map((pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
          : <Widget>[];

      return Scaffold(
        appBar: AppBar(
          title: const Text("Sugestões salvas"),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sugestões de nome"),
          actions: [
            IconButton(
              icon: const Icon(Icons.grid_view),
              onPressed: (() {
                setState(() {
                  if (cardMode == false) {
                    cardMode = true;
                  } else if (cardMode == true) {
                    cardMode = false;
                  }
                });
              }),
              tooltip:
                  cardMode ? 'List Vizualization' : 'Card Mode Vizualization',
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: _pushSaved,
              tooltip: "Saved Suggestions",
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit', arguments: {
                        'type': 'add',
                        'suggestions': _suggestions
                      }).then((_) => setState((() {})));
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 34,
                    ))
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: cardMode
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _suggestions.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 80,
                              mainAxisSpacing: 40),
                      itemBuilder: (context, i) {
                        if (i >= _suggestions.length) return const Text('');

                        final alreadySaved =
                            _saved.contains(_suggestions.index(i));

                        return InkResponse(
                          onTap: () {
                            Navigator.pushNamed(context, '/edit', arguments: {
                              'index': i,
                              'suggestions': _suggestions
                            }).then((_) => setState((() {})));
                          },
                          child: GridTile(
                            footer: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      alreadySaved
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: alreadySaved ? Colors.red : null,
                                      semanticLabel: alreadySaved
                                          ? "Removed from saved"
                                          : "Save",
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (alreadySaved) {
                                          _saved.remove(_suggestions.index(i));
                                        } else {
                                          _saved.add(_suggestions.index(i));
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        if (alreadySaved) {
                                          _saved.remove(_suggestions.index(i));
                                        }
                                        _suggestions.remove(i);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            child: Text(
                              _suggestions.index(i).asPascalCase,
                              style: _biggerFont,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _suggestions.length * 2,
                      itemBuilder: (context, i) {
                        if (i.isOdd) return const Divider();

                        final index = i ~/ 2;

                        if (index >= _suggestions.length) return const Text('');

                        final alreadySaved =
                            _saved.contains(_suggestions.index(index));

                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/edit', arguments: {
                              'index': index,
                              'suggestions': _suggestions
                            }).then((_) => setState((() {})));
                          },
                          title: Text(
                            _suggestions.index(index).asPascalCase,
                            style: _biggerFont,
                          ),
                          trailing: Wrap(
                            spacing: 20,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  alreadySaved
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: alreadySaved ? Colors.red : null,
                                  semanticLabel: alreadySaved
                                      ? "Removed from saved"
                                      : "Save",
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (alreadySaved) {
                                      _saved.remove(_suggestions.index(index));
                                    } else {
                                      _saved.add(_suggestions.index(index));
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    if (alreadySaved) {
                                      _saved.remove(_suggestions.index(index));
                                    }
                                    _suggestions.remove(index);
                                  });
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ));
  }
}
