import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/brew.dart';
import 'package:flutter_firebase/widgets/spinkit.dart';
import 'package:provider/provider.dart';

import 'brewtile.dart';

class BrewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<Brew>>(context);

    return brews != null
        ? ListView.builder(
            itemCount: brews.length,
            itemBuilder: (buildContext, index) => BrewTile(brew: brews[index]),
          )
        : Spinkit();
  }
}
