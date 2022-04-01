import 'package:flutter/material.dart';
import 'package:search_app/screens/search/tile.dart';
import 'package:search_app/style.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String>? _results;
  String _input = '';

  _onSearchFieldChanged(String value) async {
    //invoked everytime change in input form
    //double set state because await take time
    setState(() {
      _input = value;
      if (value.isEmpty) {
        _results = null;
      }
    });

    final results = await _searchUsers(value);
    setState(() {
      _results = results;
    });
  }

  // this function return something and it is asynchronously? Future
  // if this function not return something just use void and no Future
  Future<List<String>> _searchUsers(String name) async {
    // get data through an API -> await (not instantly)
    final result = await Supabase.instance.client
        .from('names')
        .select('fname, lname')
        .textSearch('fts', "$name:*")
        .limit(100)
        .execute();

    if (result.error != null) {
      log('error: ${result.error.toString()}');
      return [];
    }

    final List<String> names = [];
    for (var v in ((result.data ?? []) as List<dynamic>)) {
      names.add("${v['fname']} ${v['lname']}");
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Users'),
        ),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  onChanged: _onSearchFieldChanged,
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: placeholderTextFieldStyle,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  )) // we'll add our form field here later!
              ),
          Expanded(
              child: (_results ?? []).isNotEmpty
                  ? GridView.count(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(2.0),
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      children: _results!.map((r) => Tile(r)).toList())
                  : Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: _results == null
                          ? Container()
                          : Text("No results for '$_input'",
                              style: Theme.of(context).textTheme.caption))),
        ]));
  }
}
