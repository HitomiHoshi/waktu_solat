class Zon{
  final String zon;
  final String code;

  Zon({this.zon, this.code});

  factory Zon.fromJson(Map<String, dynamic> json) {
    return Zon(
      zon: json['zon'],
      code: json['code'],
    );
  }
}