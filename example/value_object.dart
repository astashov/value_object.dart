// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library value_object.example;

import 'package:value_object/value_object.dart';
part 'value_object.g.dart';

@ValueObject(const {"name": "String", "marks": "List<int>"})
class Student extends _$StudentValueObject {
  Student({String name, List<int> marks}) : super(name: name, marks: marks);
}

main() {
  var student = new Student(name: "Peter", marks: [1,2,3]);
  print(student);
}
