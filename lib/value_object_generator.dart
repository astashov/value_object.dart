library value_object.generator;

import 'dart:async';

import 'package:analyzer/src/generated/element.dart';
import 'package:source_gen/src/generator.dart';
import 'package:source_gen/src/generator_for_annotation.dart';
import 'package:value_object/value_object.dart';

class ValueObjectGenerator extends GeneratorForAnnotation<ValueObject> {
  const ValueObjectGenerator();

  @override Future<String> generateForAnnotatedElement(Element element, ValueObject annotation) {
    if (element is ClassElement) {
      var output = new StringBuffer();
      var originalClassName = element.name;
      var className = "_\$${originalClassName}ValueObject";
      output.writeln("class $className {");
      output.writeln(_finalFields(annotation));
      output.writeln("\n");
      output.writeln(_constructor(className, annotation));
      output.writeln("\n");
      output.writeln(_copyMethod(originalClassName, annotation));
      output.writeln("\n");
      output.writeln(_equalMethod(className, annotation));
      output.writeln("\n");
      output.writeln(_hashCodeMethod(className, annotation));
      output.writeln("\n");
      output.writeln(_toStringMethod(originalClassName, annotation));
      output.writeln("\n");
      output.writeln(_hashMethod());
      output.writeln("}");
      return new Future.value(output.toString());
    } else {
      var friendlyName = _friendlyNameForElement(element);
      throw new InvalidGenerationSourceError(
          'Generator cannot target `$friendlyName`.',
          todo: 'Remove the ValueObject annotation from `$friendlyName`.');
    }
  }

  String _constructor(String className, ValueObject annotation) {
    var fields = annotation.fields.keys.map((String field) => "this.$field").join(",");
    return "$className({$fields});";
  }

  String _copyMethod(String className, ValueObject annotation) {
    var inputArguments = <String>[];
    var passingArguments = <String>[];
    annotation.fields.forEach((String name, String type) {
      inputArguments.add("$type $name");
      passingArguments.add("$name: $name ?? this.$name");
    });
    return "${className} copy({${inputArguments.join(", ")}}) {"
        "return new $className(${passingArguments.join(", ")});}";
  }

  String _equalMethod(String className, ValueObject annotation) {
    var equalities = annotation.fields.keys.map((String name) {
      return "$name == other.$name";
    }).join(" && ");
    return "bool operator ==(other) { "
        "return other is $className && $equalities; }";
  }

  String _finalFields(ValueObject annotation) {
    var fields = <String>[];
    annotation.fields.forEach((String name, String type) {
      fields.add("final $type $name;");
    });
    return fields.join("");
  }

  String _friendlyNameForElement(Element element) {
    var friendlyName = element.displayName;

    if (friendlyName == null) {
      throw new ArgumentError(
          'Cannot get friendly name for $element - ${element.runtimeType}.');
    }

    var names = <String>[friendlyName];
    if (element is ClassElement) {
      names.insert(0, 'class');
      if (element.isAbstract) {
        names.insert(0, 'abstract');
      }
    }
    if (element is VariableElement) {
      names.insert(0, element.type.toString());

      if (element.isConst) {
        names.insert(0, 'const');
      }

      if (element.isFinal) {
        names.insert(0, 'final');
      }
    }
    if (element is LibraryElement) {
      names.insert(0, 'library');
    }

    return names.join(' ');
  }

  String _hashCodeMethod(String className, ValueObject annotation) {
    var hashCodes = "_hash([${annotation.fields.keys.join(", ")}])";
    return "int get hashCode => $hashCodes;";
  }

  String _hashMethod() {
    return """int _hash(Iterable<Object> objects) {
      return objects.fold(0, (prev, curr) => (prev * 31) + curr.hashCode);
    }""";
  }

  String _toStringMethod(String className, ValueObject annotation) {
    var fields = annotation.fields.keys.map((String name) {
      return "$name: '\${this.$name}'";
    });
    return "String toString() { return \"<$className ${fields.join(" ")}>\"; }";
  }
}
