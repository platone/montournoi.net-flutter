import 'package:json_annotation/json_annotation.dart';
import 'package:montournoi_net_flutter/models/player.dart';
import 'package:montournoi_net_flutter/models/team.dart';

part 'teamlight.g.dart';

@JsonSerializable()
class TeamLight extends Team {

  final int? id;
  final String? name;
  final String? backgroundColor;
  final String? textColor;
  final String? image;
  final String? country;

  TeamLight({required this.id,required this.name,required this.backgroundColor,required this.textColor,required this.image,required this.country,}) :
        super(id: 0, name: '', backgroundColor: '', textColor: '', image: '', country: '', players: []);

  factory TeamLight.fromJson(Map<String, dynamic> json) => _$TeamLightFromJson(json);

  Map<String, dynamic> toJson() => _$TeamLightToJson(this);
}