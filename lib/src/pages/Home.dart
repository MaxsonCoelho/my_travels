import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Mapa.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void _openMap() {
    Navigator.push(context, 
    MaterialPageRoute(builder: (_) => Mapa()));
  }

  void _removeTravel( String idTravel ) {
    _db.collection('viagens').doc( idTravel ).delete();
  }

  void _addLocal(String idTravel) {
    Navigator.push(context, 
    MaterialPageRoute(builder: (_) => Mapa( idTravel: idTravel )));
  }

  Future<void> _addListenerTravels() async {
    final stream = _db.collection('viagens')
      .snapshots();

    stream.listen((data) {
      _controller.add( data );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addListenerTravels();
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
          _openMap();
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.done:

            QuerySnapshot<Object?>? querySnapshot = snapshot.data;
            List<DocumentSnapshot> viagens = querySnapshot!.docs.toList();

            return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: viagens.length,
                          itemBuilder:  (context, index) {
                            
                            DocumentSnapshot item = viagens[index];
                            String titulo = item['titulo'];
                            String idTravel = item.id;

                            return GestureDetector(
                              onTap: () {
                                _addLocal( idTravel );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(titulo),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _removeTravel( idTravel );
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
                  );
            break;
          }
        },
      )
    );

  }
}



