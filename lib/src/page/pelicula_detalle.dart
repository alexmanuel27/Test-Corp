import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_models.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/preoviders/peliculas_providers.dart';



class PeliculaDetalle extends StatelessWidget {
 


  //const PeliculaDetalle ({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula=ModalRoute.of(context).settings.arguments; 
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0),
                _posterTitulo(context,pelicula),
                _descripcion(pelicula),
                //_descripcion(pelicula),
                //_descripcion(pelicula),
                //_descripcion(pelicula),
                _crearCastig(pelicula),                
              ]
            )
          )               
        ],
      )
    );
   }
                
 Widget _crearAppbar(Pelicula pelicula) {
                
                    return SliverAppBar(
                      elevation: 2.0,
                      backgroundColor: Colors.indigoAccent,
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        //title: Text(pelicula.title,
                       // style: TextStyle(color: Colors.white, fontSize: 16.0, 
                       // ),
                        //),
                        background: FadeInImage(
                          image: NetworkImage(pelicula.getBackgroundImg()),
                          placeholder: AssetImage('assets/img/loading.gif'),         
                          fadeInDuration: Duration(milliseconds: 50),
                          fit: BoxFit.cover,
                          ),
                      ),
                
                    );
                  }
                
 Widget _posterTitulo(BuildContext context, Pelicula pelicula) {

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Hero(
                            tag: pelicula.uniqueId,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                              image:NetworkImage( pelicula.getPosterImg() ),
                              height: 150.0,
                              ),                           
                            ),
                          ),
                          SizedBox(width: 20.0,),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(pelicula.title,style: Theme.of(context).textTheme.title,overflow: TextOverflow.ellipsis,),
                                Text(pelicula.originalTitle,style: Theme.of(context).textTheme.subhead,overflow: TextOverflow.ellipsis,),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.star_border),
                                    Text(pelicula.voteAverage.toString(),style: Theme.of(context).textTheme.subhead)
                                  ],
                                ),
                                Text('${pelicula.releaseDate[0]}${pelicula.releaseDate[1]}${pelicula.releaseDate[2]}${pelicula.releaseDate[3]}'),
                                
                              ],
                            ),
                            ),
                            SizedBox(width: 20,),
                        _trailer(pelicula, context),
                        ],
                      )
                    );

                 }

Widget  _descripcion(Pelicula pelicula) {

  var pTmep =  pelicula.overview;
  if(pTmep.length < 5){

    pTmep = 'Lo sentimos, no hay información disponible para esta película en estos momentos...';
  }
  
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
    child: Text(
      pTmep,
      textAlign: TextAlign.justify,
    ),
  );

}

 Widget _crearCastig(Pelicula pelicula) {

   final peliProvider = new PeliculasProvider();

   return FutureBuilder(
     future: peliProvider.getCast(pelicula.id.toString()),
     //initialData: InitialData,
     builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      
      if(snapshot.hasData){

        return _crearActoresPageView(snapshot.data);
      }else{
        return Center(
          child: CircularProgressIndicator()
        );
      }
     },
   );
 }

  Widget _crearActoresPageView(List<Actor> actores) {

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i])      
      ),
    );
  }

  Widget _actorTarjeta(Actor actor){

    return Container(
      
      child: Column(
        children: <Widget>[
          ClipRRect(
            
            borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'), 
              fit: BoxFit.cover,
              height: 150.0,
              image: NetworkImage(
                actor.getFotoImg(),
                )
                ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,)
        ],
      ),
    );

  }

 Widget _trailer(Pelicula pelicula, BuildContext context) {

     return RaisedButton(
            autofocus: true,  
            child:  Container(
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Mostrar Trailer'),
                  SizedBox(width: 8.0,),
                  Icon(Icons.video_label),
                ],
              ),
              
            ),
            color: Colors.blue,
            textColor: Colors.white,
            shape: StadiumBorder(),
            onPressed: () => _mostrarAlert(pelicula,context), 
        );


 }

 
  void _mostrarAlert(Pelicula pelicula, BuildContext context){

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text('Alerta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('La siguiente acción hará uso de contenido de YouTube.'),
              Text(' '),
              Text('¿Está de acuerdo con eso?'),
              //FlutterLogo(size: 100.0)
            ],
          ),
          actions: <Widget>[
            FlatButton(
            onPressed:() => Navigator.of(context).pop(),
            child: Text('Cancelar'),
            ),
            FlatButton(
            onPressed:() {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, 'trailer', arguments: pelicula); },
            child: Text('ok'),
            )
          ],
        );

      }
      );

  }
}