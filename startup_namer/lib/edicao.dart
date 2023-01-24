import 'package:startup_namer/repositorio.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  String newWord = '';

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Repository state = arguments['suggestions'];
    final int? index = arguments['index'];
    final String? type = arguments['type'];

    return Scaffold(
        appBar: AppBar(
          title: type == null
              ? Text('Edite a palavra "${state.index(index!).asPascalCase}"')
              : const Text('Adicionar palavra'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Você precisa digitar alguma palavra';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      newWord = value;
                    }),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: type == null
                            ? 'Escreva aqui para adicionar'
                            : 'Escreva aqui para trocar',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        if (type == null) {
                          state.changeWordByIndex(newWord, index!);
                        } else {
                          state.addWord(newWord);
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: type == null
                      ? Text(
                          'Edite ${state.index(index!).asPascalCase} para $newWord')
                      : Text('Adicionar $newWord'),
                )
              ],
            ),
          ),
        ));
  }
}
