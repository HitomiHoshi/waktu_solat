class Negeri{
  final String negeri;
  final String file;

  Negeri({this.negeri, this.file});

  factory Negeri.fromJson(Map<String, dynamic> json) {
    return Negeri(
      negeri: json['negeri'],
      file: json['file'],
    );
  }
}