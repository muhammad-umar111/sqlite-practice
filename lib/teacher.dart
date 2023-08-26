// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Teacher {
  String name;
  String sallary;
  Teacher({
    required this.name,
    required this.sallary,
  });
  

  Teacher copyWith({
    String? name,
    String? sallary,
  }) {
    return Teacher(
      name: name ?? this.name,
      sallary: sallary ?? this.sallary,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'sallary': sallary,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      name: map['name'] as String,
      sallary: map['sallary'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) => Teacher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Teacher(name: $name, sallary: $sallary)';

  @override
  bool operator ==(covariant Teacher other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.sallary == sallary;
  }

  @override
  int get hashCode => name.hashCode ^ sallary.hashCode;
}
