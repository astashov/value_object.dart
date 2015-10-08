# ValueObject

A source_gen generator, which allows you to generate ValueObject classes.

## Preface

The Dart language currently misses [value objects](https://en.wikipedia.org/wiki/Value_object), but I find them
extremely useful. Probably about 90% of my classes I write produce immutable objects, with all the fields are final.
They all look like this:

```dart
class FooBar {
  final String foo;
  final String bar;

  FooBar({this.foo, this.bar});

  FooBar copy({String foo, String bar}) {
    return new FooBar(foo: foo ?? this.foo, bar: bar ?? this.bar);
  }

  bool operator ==(other) => other is FooBar && foo == other.foo && bar == other.bar;
  int get hashCode => hash([foo, bar]);

  String toString() => "<FooBar foo: $foo, bar: $bar>";
}
```

Adding or removing a field is pretty painful, you have to add it to the property list, to the constructor,
all the copy and equality methods, to the toString() method. It's easy to make a mistake here, and it's just boring.

I really wish there is a way to support these things natively (like Scala's case classes, for example). But it's
not there yet. But for now, we can use [source_gen](https://pub.dartlang.org/packages/source_gen) to code generate them.

## Usage

You have to follow some conventions to properly use generated classes. First, annotate your class with `@ValueObject`,
and add `part 'my_lib.g.dart` to your lib.

```dart
// File my_lib.dart
library my_lib;

import 'package:value_object/value_object.dart';

part 'my_lib.g.dart';

@ValueObject(const {"foo": "String", "bar": "String"})
class FooBar extends _$FooBarValueObject {
  FooBar({String foo, String bar}) : super(foo: foo, bar: bar);
}
```

Please note some things here:

* Add `import 'package:value_object/value_object.dart';`, it specifies the `@ValueObject` annotation.
* Add `part 'my_lib.g.dart';`, this will be the file source_gen generates.
* Add `@ValueObject` annotation, which accepts a const map, which looks like `"fieldName": "fieldType"`
* You have to extend your class from the superclass, called `_$YourClassNameValueObject`,
  in this case - `_$FooBarValueObject`
* Unfortunately, you also have to specify the constructor, which will just pass all the arguments to the superclass.
  It should use named arguments with exactly the same names as you specified in `@ValueObject`

Next, you have to create `build.dart`, which will run the generators. In case you have one already, just add
`ValueObjectGenerator` to it. So, it should look something like this:

```dart
// File build.dart
library my_lib.build_file;

import 'package:value_object/value_object_generator.dart';
import 'package:source_gen/source_gen.dart';

main(List<String> args) async {
  var msg = await build(args, const [const ValueObjectGenerator()], librarySearchPaths: ['lib']);
  print(msg);
}
```

You have to specify the list of generators here (in our case - just one - `ValueObjectGenerator` and the paths
where source_gen will look for the sources to generate (most likely it will be `lib`).

You have to run `dart build.dart` every time you change `FooBar`. For this, if you use Intellij WebStorm or IDEA,
you can use the "File Watchers" plugin, and specify it runs `dart build.dart` every time you change any Dart file in the project.

Now, you can finally use it:

```dart
// File main.dart
import 'my_lib.dart';

void main() {
  var fooBar = new FooBar(foo: "wow foo", bar: "much bar");
  var sameFooBar = new FooBar(foo: "wow foo", bar: "much bar");
  print(fooBar == sameFooBar); // => true
  print(fooBar.copy(foo: "doge")); // => <FooBar foo: doge, bar: much bar>
  print(fooBar); // => it wasn't changed, still <FooBar foo: wow foo, bar: much bar>
}
```

## Summary

It still pretty awkward and cumbersome compared to native implementations like e.g. Scala's case classes.
Also `dart build.dart` takes several seconds to run (probably due to `analyzer`), so not instant experience either.
But I still find this useful, hopefully you will find it useful too :)