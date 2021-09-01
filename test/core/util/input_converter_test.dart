import 'package:clean_flutter_tdd/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter = InputConverter();
  group('string to unsigned int', () {
    const int tNumber = 15;
    test('should parse a string to unsigned int', () async {
      //arrange
      const String str = '15';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert

      expect(result, equals(const Right(tNumber)));
    });
    test('should return a failure when the string is not a integer', () async {
      // arrange
      const String str = 'abc';

      //act
      final result = inputConverter.stringToUnsignedInteger(str);

      //assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return a failure when the string is a negative integer',
        () async {
      // arrange
      const String str = '-15';

      //act
      final result = inputConverter.stringToUnsignedInteger(str);

      //assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
