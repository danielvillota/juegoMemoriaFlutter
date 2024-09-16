class CardModel {
  final int id;
  final int number;
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.id,
    required this.number,
    this.isFlipped = false,
    this.isMatched = false,
  });
}