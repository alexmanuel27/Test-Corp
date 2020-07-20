class Casts{

  Video video = new Video();

  Casts.fromJsonList(List<dynamic> jsonList){

    if (jsonList == null )return;

      jsonList.forEach((item){

      video = Video.fromJsonMap(item);
      });
  }
}


class Video {
  String id;
  String iso6391;
  String iso31661;
  String key;
  String name;
  String site;
  int size;
  String type;

  Video({
    this.id,
    this.iso6391,
    this.iso31661,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

   Video.fromJsonMap(Map<String, dynamic> json){

    id       = json['id'];
    iso6391  = json['iso6391'];
    iso31661 = json['iso31661'];
    key      = json['key'];
    name     = json['name'];
    site     = json['site'];
    size     = json['size'];
    type     = json['type'];

   }

 getKey(){

     if(key == null){
       return '0';
     }
     return 'https://www.youtube.com/watch?v=$key';
   }
}
