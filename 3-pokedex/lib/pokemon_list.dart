import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/model/pokedex.dart';
import 'package:pokedex/pokemon_detail.dart';
import 'package:pokedex/pokemon_list.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  String url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  Pokedex pokedex;
  Future<Pokedex> veri;

  Future<Pokedex> pokemonlariGetir() async {
    var response = await http.get(url);
    var decodedJson = json.decode(response.body);
    pokedex = Pokedex.fromJson(decodedJson);
    return pokedex;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    veri = pokemonlariGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokedex"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return FutureBuilder(
                future: veri,
                builder: (context, AsyncSnapshot<Pokedex> gelenPokedex) {
                  if (gelenPokedex.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (gelenPokedex.connectionState ==
                      ConnectionState.done) {
                    return GridView.builder(
                        itemCount: pokedex.pokemon.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PokemonDetail(
                                      pokemon: pokedex.pokemon[index])));
                            },
                            child: Hero(
                              tag: pokedex.pokemon[index].img,
                              child: Card(
                                elevation: 6,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 200,
                                      height: 150,
                                      child: FadeInImage.assetNetwork(
                                        placeholder: "assets/loading.gif",
                                        image: pokedex.pokemon[index].img,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(
                                      pokedex.pokemon[index].name,
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                });
          } else {
            return GridView.extent(
              maxCrossAxisExtent: 300,
              children: pokedex.pokemon.map((poke) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PokemonDetail(pokemon: poke)));
                  },
                  child: Hero(
                    tag: poke.img,
                    child: Card(
                      elevation: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: 200,
                              height: 150,
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/loading.gif",
                                image: poke.img,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            poke.name,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
