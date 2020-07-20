import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_models.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/video_modelds.dart';

class PeliculasProvider{

  String _apikey = '4b6a0e4d52f7b112032d135663b074a5';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamControler = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamControler.sink.add;
    
  Stream<List<Pelicula>> get popularesStream => _popularesStreamControler.stream;

  void disposeStream() => _popularesStreamControler?.close();

   

Future<List<Pelicula>>  _procesarRespuesta(Uri url) async{

  final resp = await http.get(url);
  final decodedData = json.decode(resp.body);

  final peliculas = new Peliculas.fromJsonList(decodedData['results']);

  return peliculas.items;

}

Future<List<Pelicula>>  getEnCines() async{

    final url = Uri.https(_url, '3/movie/now_playing',{'api_key' : _apikey, 'language' : _language});

    return await _procesarRespuesta(url);

  }

Future<List<Pelicula>>  getPopulares() async {

    if ( _cargando) return [];

    _cargando = true;
    _popularesPage++;

     final url = Uri.https(_url, '3/movie/popular',{
       'api_key'  : _apikey, 
       'language' : _language,
       'page'     : _popularesPage.toString()
        });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink( _populares );

    _cargando = false;
    return resp;


  }

Future<List<Actor>>     getCast(String peliId) async{
  

  final url = Uri.https(
    _url,
    '3/movie/$peliId/credits',
    {
    'api_key' : _apikey,
    'language' : _language,
    },);
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodeData['cast']);
    return cast.actores;
}

Future<List<Pelicula>>  buscarPelicula(String query) async{

    final url = Uri.https(_url, '3/search/movie',{'api_key' : _apikey, 'language' : _language, 'query' : query});

    return await _procesarRespuesta(url);

  }

Future<Video>           getTrailer(String peliId) async{
  

  final url = Uri.https(
    _url,
    '3/movie/$peliId/videos',
    {
    'api_key' : _apikey,
    'language' : _language,
    },);
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final casts = new Casts.fromJsonList(decodeData['results']);
   // print('URL---${casts.video.getKey()}');
    return casts.video;
}
}