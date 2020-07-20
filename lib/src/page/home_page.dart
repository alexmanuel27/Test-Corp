import 'package:flutter/material.dart';
import 'package:peliculas/src/Widget/card_Swiper_widget.dart';
import 'package:peliculas/src/Widget/movie_horizontal.dart';
import 'package:peliculas/src/preoviders/peliculas_providers.dart';
import 'package:peliculas/src/search/search_delegate.dart';

class HomePage extends StatelessWidget { 
  
  final peliculasProvider = new PeliculasProvider();
  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();


    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
           IconButton(
            icon: Icon(Icons.announcement), onPressed: (){}),
             SizedBox(width: 35.0),
            Center(
              child:
           Text('películas en cines',
              style: TextStyle(fontSize: 28.0,fontStyle: FontStyle.italic))),
           SizedBox(width: 35.0),
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(
              context: context, 
              delegate: DataSearch(),
              //query: 'hola'
              );
          }),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        ),
      )
      
      
      );
      }

 Widget _swiperTarjetas() {


   return FutureBuilder(
     future: peliculasProvider.getEnCines(),
     builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
       
       if( snapshot.hasData){
          return CardSwiper( peliculas: snapshot.data);
        } else{
            return Container(
              height: 400.0,
              child: Center(
                child: CircularProgressIndicator()));
          }
      // return CardSwiper(peliculas: snapshot.data);
       }
   );
 }

  Widget _footer(BuildContext context){

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
               SizedBox(width: 10.0),
              Icon(Icons.star),
              Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text('Películas Populares', style: Theme.of(context).textTheme.subhead),
               ),
                ],
          ),
          
          SizedBox(height: 20.0),

          StreamBuilder(
            stream: peliculasProvider.popularesStream, 
            //initialData: [],          
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              
              if(snapshot.hasData){

                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                  );
              } else{

                return Center(child: CircularProgressIndicator());

              }
            },
          ),
        ],
      ),
    );


  }




      }