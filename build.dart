library value_object.build_file;

import 'package:value_object/value_object_generator.dart';
import 'package:source_gen/source_gen.dart';

main(List<String> args) async {
  var msg = await build(args, const [const ValueObjectGenerator()], librarySearchPaths: ['example']);
  print(msg);
}
