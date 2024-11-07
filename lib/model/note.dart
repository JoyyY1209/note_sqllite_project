class Note{
  int? id;
  String? title;
  String? description;
  Note({
    this.id,
    this.title,
    this.description,
});

  //store db elment from note
  Map<String,dynamic> toMap(){
      return {
        'title' : title,
        'description' : description,
      };
  }

  //db element to note
  static Note fromMap(Map<String,dynamic> map){
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],

    );
  }
}