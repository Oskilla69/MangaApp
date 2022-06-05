class Manga {
  num? id;
  String title;
  String author;
  String synopsis;
  String imageUrl;
  String status;
  List<String> genres;
  num viewCount;
  double rating;
  DateTime? lastUpdate;

  Manga(this.title, this.author, this.synopsis, this.imageUrl, this.status,
      this.genres, this.viewCount, this.rating);
}
