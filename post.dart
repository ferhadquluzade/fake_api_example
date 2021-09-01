
class Post {
   int userId=0000;
   int id=00000000;
  String title="::::Title";
   String body="::::Body";
  Post(
      {required this.userId,
      required this.id,
      required this.body,
      required this.title});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json['userId']??0000000,
        id: json['id']??0000000,
        title: json['title']??"::::::Title",
        body: json['body']??"::::::Body");
  }
  
}
