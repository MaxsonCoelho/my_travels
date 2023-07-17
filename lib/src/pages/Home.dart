import 'package:flutter/material.dart';

import 'Mapa.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List _listTravels = [
    'Cristo Redentor',
    'Grande Muralha da China',
    "Taj Mahal",
    "Machu Picchu",
    "Coliseu"
  ];

  void _openMap() {
    
  }

  void _removeTravel() {
    
  }

  void _addLocal() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Mapa()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Viagens'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0066cc),
        onPressed: () {
          _addLocal();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listTravels.length,
              itemBuilder:  (context, index) {
                
                String titulo = _listTravels[index];

                return GestureDetector(
                  onTap: () {
                    _openMap();
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(titulo),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _removeTravel();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          )
        ],
      )
    );

  }
}

