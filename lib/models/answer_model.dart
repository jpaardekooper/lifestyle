import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  AnswerModel(
      {this.id,
      this.next,
      this.option,
      this.optionTypeIsNumber,
      this.order,
      this.points,
      this.pointsCalculator,
      this.type,
      this.lastAnswer})
      : reference = null;
  final String? id;
  final int? next;
  final String? option;
  final bool? optionTypeIsNumber;
  final int? order;
  final int? points;
  final int? pointsCalculator;
  final String? type;
  final String? lastAnswer;

  final DocumentReference? reference;

  AnswerModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        next = snapshot.data()!['next'],
        option = snapshot.data()!['option'],
        optionTypeIsNumber = snapshot.data()!['option_type_is_number'],
        order = snapshot.data()!['order'],
        points = snapshot.data()!['points'],
        pointsCalculator = snapshot.data()!['pointsCalculator'],
        type = snapshot.data()!['type'],
        lastAnswer = snapshot.data()!['lastAnswer'] ?? "",
        reference = snapshot.reference;
}
