
import 'package:json_annotation/json_annotation.dart';

part 'scorer.g.dart';

@JsonSerializable()
class Scorer {

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? birthday;
  final String? total;
  final String? goal;
  final String? firstAssist;
  final String? secondAssist;
  final String? penalities;
  final String? team;
  final String? image;
  final String? color;

  Scorer({required this.id, required this.firstName, required this.lastName, required this.birthday, required this.total, required this.goal, required this.firstAssist, required this.secondAssist, required this.penalities,
    required this.team, required this.image, required this.color, });

  factory Scorer.fromJson(Map<String, dynamic> json) => _$ScorerFromJson(json);

  Map<String, dynamic> toJson() => _$ScorerToJson(this);
}