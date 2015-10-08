// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-10-08T02:08:03.956Z

part of value_object.example;

// **************************************************************************
// Generator: ValueObjectGenerator
// Target: class Student
// **************************************************************************

class _$StudentValueObject {
  final List<int> marks;
  final String name;

  _$StudentValueObject({this.marks, this.name});

  Student copy({List<int> marks, String name}) {
    return new Student(marks: marks ?? this.marks, name: name ?? this.name);
  }

  bool operator ==(other) {
    return other is _$StudentValueObject &&
        marks == other.marks &&
        name == other.name;
  }

  int get hashCode => _hash([marks, name]);

  String toString() {
    return "<Student marks: '${this.marks}' name: '${this.name}'>";
  }

  int _hash(Iterable<Object> objects) {
    return objects.fold(0, (prev, curr) => (prev * 31) + curr.hashCode);
  }
}
