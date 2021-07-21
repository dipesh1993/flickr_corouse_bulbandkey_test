
class ReviewModel {
  final int id;
  final String title;
  final String ratingBy;
  final String reasonOfRating;
  final String rating;

  static const String TABLENAME = "reviewModel";

  ReviewModel({this.id,this.title,this.ratingBy,this.reasonOfRating,this.rating});

  Map<String, dynamic> toMap() {
    return {'id': id,'title':title,'ratingBy':ratingBy,'reasonOfRating':reasonOfRating,'rating':rating};
  }
}
