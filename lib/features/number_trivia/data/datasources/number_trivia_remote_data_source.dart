import 'package:clean_flutter_tdd/core/error/exceptions.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/models/number_trivia_data.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numberapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getContreteNumberTrivia(int? number);

  /// Calls the http://numberapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getContreteNumberTrivia(int? number) async {
    final url = Uri.http('numbersapi.com', '/$number');
    return _getNumberTriviaFromUrl(url);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final url = Uri.http('numbersapi.com', '/random');
    return _getNumberTriviaFromUrl(url);
  }

  Future<NumberTriviaModel> _getNumberTriviaFromUrl(Uri uriUrl) async {
    final Uri url = uriUrl;
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
