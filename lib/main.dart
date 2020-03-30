// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // titulo da aplicação
      title: 'Startup Name Generator',
      // thema da aplicação
      theme: ThemeData(primaryColor: Colors.black),
      // Render da tela
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  // lista de de palavras chave
  final _suggestions = <WordPair>[];
// salva lista de itens favoritados
  final Set<WordPair> _saved = Set<WordPair>();
  //define style for use in future
  final _biggerFont =
      const TextStyle(fontSize: 18.0, backgroundColor: Colors.black54);

  void _pushSaved() {
    // Navegação para outra pagina
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // mapeia os favoritados
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          // render da navegação
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  final wordPair = WordPair.random();
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

// gerador de itens para a lista
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          // Adiciona o divisor de cada item
          if (i.isOdd)
            return Divider(
              color: Colors.grey[300],
              thickness: 0.3,
            ); /*2*/

          int index = i ~/ 2; /*3*/
          // adiciona mais 10 itens quando a indice for igual a quantidade atual de intens
          if (index >= _suggestions.length)
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/

          return _buildRow(_suggestions[index]);
        });
  }

  // componente de renderização da lista
  Widget _buildRow(WordPair pair) {
    //  print(pair);
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
        //subtitle: Text('test'),
        onTap: () {
          // Add 9 lines from here...
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          // icone que aparecerá do lado direito de acordo com a variavel alredsaved
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : Colors.grey,
        ));
  }
}
