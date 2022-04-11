// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert' show json;
import 'package:capstone_android/sameArea/bottomBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../googleLogin.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInDemo extends StatefulWidget {
  @override
  State createState() => _SignInDemo();
}

class _SignInDemo extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign in Failed')));
    } else {
      setState(() {
        _currentUser = user;
      });
      /*
        로그인 성공 시 작업.
       */
      print("success");
      print(user.displayName);
      print(user.email);
    }
  }

  Future logout() async {
    await GoogleSignInApi.logout();
    setState(() {
      _currentUser = null;
    });
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          ElevatedButton(
            child: Text('SIGN OUT'),
            onPressed: () async => await logout(),
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: () => GoogleSignInApi.login(),
          ),
        ],
      );
    } else {
      return Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top:100.h)),
          SizedBox(child: Text("소셜 로그인",style: TextStyle(fontSize: 40,color: Colors.lightGreen),),),
          Padding(padding: EdgeInsets.only(bottom: 100.h)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(child: SignInButton(
                  Buttons.GoogleDark, onPressed: () async => await signIn()),
                width: 200.w,
                height: 40.h,
              ),

            ],),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomBar(1),
        body: Container(
          child: _buildBody(),
        ));
  }
}

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   clientId: '101733245500-hqv2c6a4nhiiv5seffkqe2foir00r0jf.apps.googleusercontent.com',
//   // scopes: <String>[
//   //   'namhyo01@gmail.com',
//   //   'https://www.googleapis.com/auth/contacts.readonly',
//   // ],
// );
//
//
// class SignInDemo extends StatefulWidget {
//   @override
//   State createState() => SignInDemoState();
// }
//
// class SignInDemoState extends State<SignInDemo> {
//   GoogleSignInAccount? _currentUser;
//   String _contactText = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//       setState(() {
//         _currentUser = account;
//       });
//       if (_currentUser != null) {
//         _handleGetContact(_currentUser!);
//       }
//     });
//     _googleSignIn.signInSilently();
//   }
//
//   Future<void> _handleGetContact(GoogleSignInAccount user) async {
//     setState(() {
//       _contactText = 'Loading contact info...';
//     });
//     print("aaaaaaaaaaaaaaaaaaaaaaaaaaa ${user.email}");
//     final http.Response response = await http.get(
//       Uri.parse('https://people.googleapis.com/v1/people/me/connections'
//           '?requestMask.includeField=person.names'),
//       headers: await user.authHeaders,
//     );
//     if (response.statusCode != 200) {
//       setState(() {
//         _contactText = 'People API gave a ${response.statusCode} '
//             'response. Check logs for details.';
//       });
//       print('People API ${response.statusCode} response: ${response.body}');
//       return;
//     }
//     final Map<String, dynamic> data =
//     json.decode(response.body) as Map<String, dynamic>;
//     final String? namedContact = _pickFirstNamedContact(data);
//     setState(() {
//       if (namedContact != null) {
//         _contactText = 'I see you know $namedContact!';
//       } else {
//         _contactText = 'No contacts to display.';
//       }
//     });
//   }
//
//   String? _pickFirstNamedContact(Map<String, dynamic> data) {
//     final List<dynamic>? connections = data['connections'] as List<dynamic>?;
//     final Map<String, dynamic>? contact = connections?.firstWhere(
//           (dynamic contact) => contact['names'] != null,
//       orElse: () => null,
//     ) as Map<String, dynamic>?;
//     if (contact != null) {
//       final Map<String, dynamic>? name = contact['names'].firstWhere(
//             (dynamic name) => name['displayName'] != null,
//         orElse: () => null,
//       ) as Map<String, dynamic>?;
//       if (name != null) {
//         return name['displayName'] as String?;
//       }
//     }
//     return null;
//   }
//
//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print("Asddddddddddddddddddddddd");
//       print(error);
//     }
//   }
//
//   Future<void> _handleSignOut() => _googleSignIn.disconnect();
//
//   Widget _buildBody() {
//     final GoogleSignInAccount? user = _currentUser;
//     if (user != null) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: user,
//             ),
//             title: Text(user.displayName ?? ''),
//             subtitle: Text(user.email),
//           ),
//           const Text('Signed in successfully.'),
//           Text(_contactText),
//           ElevatedButton(
//             child: const Text('SIGN OUT'),
//             onPressed: _handleSignOut,
//           ),
//           ElevatedButton(
//             child: const Text('REFRESH'),
//             onPressed: () => _handleGetContact(user),
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           const Text('You are not currently signed in.'),
//           ElevatedButton(
//             child: const Text('SIGN IN'),
//             onPressed: _handleSignIn,
//           ),
//         ],
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Google Sign In'),
//         ),
//         body: ConstrainedBox(
//           constraints: const BoxConstraints.expand(),
//           child: _buildBody(),
//         ));
//   }
// }
