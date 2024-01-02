class PostModel{
  String? title;
  String? description;
  String? image;
  int? time;
  PostModel(this.title,this.description,this.image,this.time);

  factory PostModel.formMap(Map map){
    return PostModel(map['title'], map['description'], map['image'], map['time']);
  }

  Map<String,dynamic> toMap() => {
    'title' : title,
    'description' : description,
    'image' : image,
    'time' : time
  };
}