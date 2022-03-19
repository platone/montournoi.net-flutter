import 'package:json_annotation/json_annotation.dart';

part 'phase.g.dart';

@JsonSerializable()
class Phase {

  final int? id;

  Phase({required this.id});

  factory Phase.fromJson(Map<String, dynamic> json) => _$PhaseFromJson(json);

  Map<String, dynamic> toJson() => _$PhaseToJson(this);
}