import '../serializer/serializer.dart';
import '../serializer/field_processor.dart';

/// Annotation used to request generation of serializer
class GenSerializer {
  /// Should all fields be included by default?
  ///
  /// Default to [true]
  final bool includeByDefault;

  /// Specify whether a property could be encoded, only, decoded only or both
  final Map<String, Field> fields;

  /// List of properties that shall be ignored
  final List<String> ignore;

  /// Supplies [Serializer]s to use when unknown PODO type is encountered
  final List<Type> serializers;

  /// Enable null check on fields if false
  ///
  /// Default to [true]
  final bool nullableFields;

  /// Determine the format for a field, [none] by default
  ///
  /// Example:
  ///
  /// ```dart
  /// class Model {
  ///   String myField;
  /// }
  ///
  /// @GenSerializer(fieldFormat: FieldFormat.snakeCase)
  /// class ModelSerializer extends Serializer ... {}
  ///
  /// final map = { 'my_field': 'foo' };
  /// final model = serializer.fromMap(map);
  /// print(model.myField); // print 'foo'
  /// ```
  final String fieldFormat;

  const GenSerializer(
      {this.fields: const <String, Field>{},
      this.ignore: const <String>[],
      this.serializers: const <Type>[],
      this.includeByDefault: true,
      this.nullableFields: true,
      this.fieldFormat});
}

class Field<T> {
  /// Alias used while encoding
  final String encodeTo;

  /// Alias used while decoding
  final String decodeFrom;

  /// Is it allowed to set the field to null value?
  final bool isNullable;

  /// The field processor used to encode/decode this field
  final FieldProcessor<T, dynamic> processor;

  /// The value used when the field has null value
  final T defaultsTo;
  final bool valueFromConstructor;

  /// Should the field be included during encoding?
  final bool dontEncode;

  /// Should the field be included during decoding?
  final bool dontDecode;

  const Field(
      {this.encodeTo,
      this.decodeFrom,
      this.isNullable,
      this.defaultsTo,
      this.processor,
      this.valueFromConstructor: false,
      this.dontDecode: false,
      this.dontEncode: false});

  const Field.encode(
      {String alias,
      this.isNullable,
      this.defaultsTo,
      this.processor,
      this.valueFromConstructor: false})
      : encodeTo = alias,
        dontEncode = false,
        decodeFrom = null,
        dontDecode = true;

  const Field.decode(
      {String alias,
      this.isNullable,
      this.defaultsTo,
      this.processor,
      this.valueFromConstructor: false})
      : decodeFrom = alias,
        dontEncode = true,
        encodeTo = null,
        dontDecode = false;

  const Field.ignore()
      : encodeTo = null,
        decodeFrom = null,
        isNullable = null,
        processor = null,
        defaultsTo = null,
        valueFromConstructor = false,
        dontEncode = true,
        dontDecode = true;
}

/// Annotation used to request encoding and decoding of a field in model
class EnDecode<T> implements Field<T> {
  /// Alias used while encoding
  final String encodeTo;

  /// Alias used while decoding
  final String decodeFrom;

  /// Is it allowed to set the field to null value?
  final bool isNullable;

  /// The field processor used to encode/decode this field
  final FieldProcessor<T, dynamic> processor;

  /// The value used when the field has null value
  final T defaultsTo;
  final bool valueFromConstructor;

  /// Should the field be included during encoding?
  final bool dontEncode;

  /// Should the field be included during decoding?
  final bool dontDecode;

  const EnDecode(
      {String alias,
      this.isNullable,
      this.processor,
      this.defaultsTo,
      this.valueFromConstructor: false})
      : encodeTo = alias,
        decodeFrom = alias,
        dontDecode = false,
        dontEncode = false;
}

/// Annotation to ignore a field while encoding or decoding
class Ignore implements Field<dynamic> {
  /// Alias used while encoding
  final String encodeTo;

  /// Alias used while decoding
  final String decodeFrom;

  /// Is it allowed to set the field to null value?
  final bool isNullable;

  /// The field processor used to encode/decode this field
  final FieldProcessor<dynamic, dynamic> processor;

  /// The value used when the field has null value
  final dynamic defaultsTo;
  final bool valueFromConstructor;

  /// Should the field be included during encoding?
  final bool dontEncode;

  /// Should the field be included during decoding?
  final bool dontDecode;

  const Ignore()
      : encodeTo = null,
        decodeFrom = null,
        isNullable = null,
        processor = null,
        defaultsTo = null,
        valueFromConstructor = false,
        dontEncode = true,
        dontDecode = true;
}

/// Annotation used to request encoding and decoding of a field in model
/// shortcup for `const EnDecode(alias: "key")`
/// become `const Alias("key")`
class Alias<T> implements Field<T> {
  /// Alias used while encoding
  final String encodeTo;

  /// Alias used while decoding
  final String decodeFrom;

  /// Is it allowed to set the field to null value?
  final bool isNullable;

  /// The field processor used to encode/decode this field
  final FieldProcessor<T, dynamic> processor;

  /// The value used when the field has null value
  final T defaultsTo;
  final bool valueFromConstructor;

  /// Should the field be included during encoding?
  final bool dontEncode;

  /// Should the field be included during decoding?
  final bool dontDecode;

  const Alias(
    String alias, {
    this.isNullable,
    this.processor,
    this.defaultsTo,
    this.valueFromConstructor: false,
  })  : encodeTo = alias,
        decodeFrom = alias,
        dontDecode = false,
        dontEncode = false;
}

const ignore = const Ignore();
const Field nullable = const Field<dynamic>(isNullable: true);
const Field nonNullable = const Field<dynamic>(isNullable: false);
const Field useConstructorForDefaultsValue =
    const Field<dynamic>(valueFromConstructor: true, isNullable: false);

/// Determine the output format for a field
/// Example:
///     class Foo {
///         String camelCase = "bar";
///     }
///
///     @GenSerializer(fieldFormat: FieldFormat.snakeCase)
///     class FooSerializer ...
///
/// will produce
///    {
///       "camel_case": "bar"
///    }
class FieldFormat {
  static const camelCase = 'camelCase';
  static const snakeCase = 'snakeCase';
  static const kebabCase = 'kebabCase';
}
