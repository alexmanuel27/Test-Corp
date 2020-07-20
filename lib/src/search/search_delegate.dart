

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/preoviders/peliculas_providers.dart';


class DataSearch extends SearchDelegate{



  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  final peliculas = [ 'Spiderman', 'aquaman','batman','shazam','ironman','capitan america'];
  final peliculasRecientes = [ 'Spiderman' , 'capitan america' ];

//////////////////////////////


  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones de nuestro Appbar
    return [
      IconButton(icon: Icon(Icons.clear),
      onPressed: (){
        query = '';})
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del Appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,), 
        onPressed: (){
          close(context, null);
          });
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen cuando la persona escribe
    



if(query.isEmpty){return Container();}

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
     // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {


        if(snapshot.hasData) {
        
        final peliculas = snapshot.data;


        return ListView(
          children: peliculas.map((pelicula){
           return ListTile(
            // contentPadding: ,
             leading: FadeInImage(
               placeholder: AssetImage('assets/img/no-image.jpg'),
               image: NetworkImage(pelicula.getPosterImg()),
               width: 50.0,
               fit: BoxFit.contain,
               ),
               title: Text(pelicula.title),
               subtitle: Text(pelicula.originalTitle),
               onTap: (){
                close(context, null);
                Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                 pelicula.uniqueId = '';
              },
               ); 
          }).toList()
        );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );


  ;

  }



   
  
}