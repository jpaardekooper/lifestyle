import 'package:flutter/material.dart';

import 'card_details.dart';

class CardStyle extends StatelessWidget {
  CardStyle({this.name, this.id});
  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text(name),
            subtitle: Text('een receipt..'),
            trailing: Material(
              child: InkWell(
                onTap: () => {},
                splashColor: Colors.grey,
                highlightColor: Colors.grey,
                child: Icon(
                  Icons.favorite,
                  size: 24,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Meer info'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CardDetails(name: name, id: id)),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
