// import 'dart:convert';

// import 'package:auth/src/domain/credential.dart';
// import 'package:auth/src/infra/api/auth_api.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:mockito/mockito.dart';
// import 'package:async/async.dart';

// class MockClient extends Mock implements http.Client {}

// void main() {
//   MockClient client;
//   // here mockclient is given by mockito package, it gives the dummy data of the client, here it http.client.
//   AuthApi sut;
//   // sut => system under test.
//   // we trigger the signin and signup functions in authapi from here.
//   // here late means it asking for intialise the var, by typing late iam assuring it that iam intialising or
//   // assigning the values lately , that i have done in setup() function.
//   setUp(() {
//     client = MockClient();
//     sut = AuthApi('http:baseUrl', client);
//   });
//   group('signin', () {
//     var credential = Credential(
//       type: AuthType.email,
//       email: 'email@gmail.com',
//       password: 'password',
//     );
//     test('should return token string when successful', () async {
//       //arrange
//       var tokenString = 'lskjflskd...';
//       when(
//         client.post(
//           any,
//           body: anyNamed('body'),
//         ),
//       ).thenAnswer(
//         (_) async =>
//             http.Response(jsonEncode({'auth_token': tokenString}), 200),
//       );
//       //act
//       var result = await sut.signIn(credential);
//       //assert
//       expect(result, isA<ErrorResult>());
//       // here errorResult is from async package
//       // expect(result.asValue.value, tokenString);
//     });
//   });
// }

// // i was getting an error when using any in post because of null safety so i removed null safety for now to learn,
// // i will change it to sound null safety after course is completed.

// // test is like let me explain
// // here testing is done by using httpclient 
// // in sut.signin method it posting client.post(url,body: credential) and expecting the Result<Stirng>
// // here in test stage we are giving the mockclient and dummy url, and the responce is given in the .thenAnswer line
// // from here we first setup the test platform by sending the mockclient and url to the authApi,
// // and we give the response for the post in authapi.signIn(), from the .thenAnswet 
// // the the test will be true and prints the value only if the value we get from signIn() here its result
// // and an expected value,

// // to understand well see the draw.io/authmoduleflowchart/test working 