import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/video_modelds.dart';
import 'package:peliculas/src/preoviders/peliculas_providers.dart';
import 'package:video_player/video_player.dart';



class TrailerPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final Pelicula peli = ModalRoute.of(context).settings.arguments;

    return Scaffold(
     // backgroundColor: Colors.black26 ,
      appBar: AppBar(
        title: Text('Trailer: ${peli.originalTitle}'),
      ),
       body:
       Center(

         child: trailer(peli)
                  
        // ChewieListItem(
       //    videoPlayerController: VideoPlayerController.network('${trailer(peli)}.mp4'),
           //videoPlayerController: VideoPlayerController.asset('video/Microprocesador.mp4'),
         //)
        //)      
    
    ));
  }
   trailer(Pelicula pelicula){
       final peliculasProvider = new PeliculasProvider();
     return FutureBuilder(
      future: peliculasProvider.getTrailer(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final a = _crearTrailer(snapshot.data).toString();
        print(a);
        return ChewieListItem(
          videoPlayerController: VideoPlayerController.network(a),
        );
      }
      );
            }

  _crearTrailer(Video data) => data.getKey();
}
class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieListItem({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    // Wrapper on top of the videoPlayerController
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      looping: widget.looping,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }


      }