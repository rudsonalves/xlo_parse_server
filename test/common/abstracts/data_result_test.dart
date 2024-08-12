import 'package:flutter_test/flutter_test.dart';
import 'package:bgbazzar/common/abstracts/data_result.dart';

void main() {
  group('DataResult', () {
    test('gets the data when it is Success result', () {
      const data = 'hello';
      final dataResult = DataResult.success(data);
      expect(dataResult.data, data);
    });

    test('data returns null when it is Failure result', () {
      final dataResult = DataResult.failure(GenericFailure());
      expect(dataResult.data, null);
    });

    test('`isSuccess` returns true for Success result', () {
      const data = 'hello';
      final dataResult = DataResult.success(data);
      expect(dataResult.isSuccess, true);
    });

    test('`isSuccess` returns false for Failure result', () {
      final dataResult = DataResult.failure(GenericFailure());
      expect(dataResult.isSuccess, false);
    });

    test('dataOrElse returns `data` for Success result', () {
      const data = 'foo';
      final dataResult = DataResult.success(data);
      expect(dataResult.dataOrElse('bar'), 'foo');
    });

    test('dataOrElse returns else data for Failure result', () {
      final dataResult = DataResult.failure(GenericFailure());
      expect(dataResult.dataOrElse('bar'), 'bar');
    });

    test('isFailure returns true for Failure result', () {
      final dataResult = DataResult.failure(APIFailure());
      expect(dataResult.isFailure, true);
    });

    test('isFailure returns false for Success result', () {
      final dataResult = DataResult.success('something');
      expect(dataResult.isFailure, false);
    });

    test('gets error when it is Failure result', () {
      final dataResult = DataResult.failure(APIFailure());
      expect(dataResult.error, APIFailure());
    });

    test('failure returns null when it is Success result', () {
      final dataResult = DataResult.success('something');
      expect(dataResult.error, null);
    });
  });

  group('DataResult | operator', () {
    test("returns existing value if it's Success result", () {
      const data = 'foo';
      final dataResult = DataResult.success(data);
      expect(dataResult | 'bar', 'foo');
    });

    test("returns other value if it's Failure result", () {
      final dataResult = DataResult.failure(GenericFailure());
      expect(dataResult | 'bar', 'bar');
    });
  });

  group('DataResult', () {
    test('should be equal when two success objects have equal data', () {
      const data = 'hello';
      final dataResult = DataResult.success(data);
      const data2 = 'hello';
      final dataResult2 = DataResult.success(data2);
      expect(dataResult == dataResult2, true);
    });

    test('should not be equal when two success objects have different data',
        () {
      const data = 'hello';
      final dataResult = DataResult.success(data);
      const data2 = 'hello2';
      final dataResult2 = DataResult.success(data2);
      expect(dataResult == dataResult2, false);
    });

    test('should be equal when two failure objects have equal error', () {
      final dataResult = DataResult.failure(APIFailure());
      final dataResult2 = DataResult.failure(APIFailure());
      expect(dataResult == dataResult2, true);
    });

    test('should not be equal when two failure objects have different error',
        () {
      final dataResult = DataResult.failure(GenericFailure());
      final dataResult2 = DataResult.failure(APIFailure());
      expect(dataResult == dataResult2, false);
    });
  });

  group('DataResult fold', () {
    test('transforms failure into a false bool', () {
      final result = DataResult.failure<String>(GenericFailure())
          .fold<bool>((failure) => false, (data) => true);

      expect(result, false);
    });

    test('transforms data into a true bool', () {
      final result = DataResult.success('yo')
          .fold<bool>((failure) => false, (data) => true);

      expect(result, true);
    });
  });

  group('DataResult then', () {
    test('bubbles up failure instead of transforming the success value', () {
      final result = DataResult.failure<String>(GenericFailure())
          .then((data) => DataResult.success(1.34));

      expect(result.isFailure, true);
      expect(result.error, GenericFailure());
    });

    test('transforms data into a double value', () {
      final result =
          DataResult.success('yo').then((data) => DataResult.success(1.34));

      expect(result.isSuccess, true);
      expect(result.data, 1.34);
    });

    test('transforms data into a failure', () {
      final result = DataResult.success<String>('yo')
          .then((data) => DataResult.failure(APIFailure()));

      expect(result.isSuccess, false);
      expect(result.error, APIFailure());
    });
  });

  group('DataResult map', () {
    test('bubbles up failure instead of transforming the success value', () {
      final result =
          DataResult.failure<String>(GenericFailure()).map((data) => 1.34);

      expect(result.isFailure, true);
      expect(result.error, GenericFailure());
    });

    test('transforms data into a double value', () {
      final result = DataResult.success('yo').map((data) => 1.34);

      expect(result.isSuccess, true);
      expect(result.data, 1.34);
    });

    test('can only transform data into a failure if it is the new data type',
        () {
      final result = DataResult.success('yo').map((data) => APIFailure());

      expect(result.isSuccess, true);
      expect(result.data, APIFailure());
    });
  });

  group('DataResult either', () {
    test('only executes error changing the error type for Failure result', () {
      final result = DataResult.failure<String>(GenericFailure()).either(
        (error) => APIFailure(),
        (data) => throw Exception('This will never happen for failure'),
      );

      expect(result.isFailure, true);
      expect(result.error, APIFailure());
    });

    test('only executes data for Success result', () {
      final result = DataResult.success('yo').either(
        (error) => throw Exception('This will never happen for success'),
        (data) => 'new value here',
      );

      expect(result.isSuccess, true);
      expect(result.data, 'new value here');
    });
  });
}
