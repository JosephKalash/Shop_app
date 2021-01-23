
class HttpException implements Exception{
  final message;

  HttpException(this.message);

  @override
  String toString() {
    print(message);
    return message;
  }
}