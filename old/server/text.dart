import 'dart:io';

BytesBuilder builder = new BytesBuilder();

main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 9999)
  .then((HttpServer server) {
    print('listening on localhost, port ${server.port}');

    server.listen((HttpRequest request) {
      print(request.contentLength);
      print(request.headers);
      request.listen((e){
        print(e.toString());
      });
      request.response.write('Hello, world!');
      request.response.close();
    });
  }).catchError((e) => print(e.toString()));
}