import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class CardSwiper extends StatelessWidget {
 // const CardSwiper({Key key}) : super(key: key);

    final List<Pelicula> peliculas;

    CardSwiper({@required this.peliculas });
 
  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
     padding: EdgeInsets.only(top: 13.0),
     child: new Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width *0.7,
        itemHeight: _screenSize.height *0.5,
        itemBuilder: (BuildContext context, int index) {

              peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';
              
              return Hero(
                tag: peliculas[index].id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: GestureDetector(
                    onTap: () =>Navigator.pushNamed(context, 'detalle',arguments: peliculas[index]),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      image: NetworkImage(peliculas[index].getPosterImg()),
                      fit: BoxFit.cover
                      ),
                  ),
                  ),
              );
            },
            itemCount: peliculas.length,
            //indicatorLayout: PageIndicatorLayout.5213,
           // autoplay: true,
            //pagination: new SwiperPagination(),
            //control: new SwiperControl(),
          ),
   );
  }
}