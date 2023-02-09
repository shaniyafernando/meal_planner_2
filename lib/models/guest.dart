class Guest{
  String? referenceId;
  String? name;
  List<dynamic> healthLabels = [];

  Guest({this.referenceId,required this.name, required this.healthLabels});

  factory Guest.fromJson(Map<String, dynamic> json) =>
      _guestFromJson(json);

  Map<String, dynamic> toJson() => _guestToJson(this);

  @override
  String toString() {
    return 'Guest{referenceId: $referenceId, name: $name, healthLabels: $healthLabels}';
  }
}

Guest _guestFromJson(Map<String, dynamic> json) {
  return Guest(
      name: json['name'] as String,
      healthLabels: json['healthLabels'] as List<dynamic>);
}

Map<String, dynamic> _guestToJson(Guest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'healthLabels': instance.healthLabels
    };