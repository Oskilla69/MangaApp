import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangaapp/pages/home_page.dart';
import 'package:mangaapp/widgets/login/flutter_login.dart';

// stateful for setting email variable
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    String email = '';
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        FlutterLogin(
          logo: const AssetImage('assets/images/logo.jpeg'),
          title: 'MangaApp',
          navigateBackAfterRecovery: true,
          onLogin: ((loginData) async {
            try {
              final user = await _auth.signInWithEmailAndPassword(
                  email: loginData.name, password: loginData.password);
              print(user);
            } catch (error) {
              print(error);
              return Future<String>.value('Not a valid username/password');
            }
          }),
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushNamed(HomePage.routeName);
          },
          onSignup: ((signupData) async {
            email = signupData.name!;
            _firestore.collection('profile').doc(email).set({
              'bookmarks': [""],
              'email': email,
              'profile_image': null,
              "username": email
            });
            var currError = null;

            try {
              await _auth.createUserWithEmailAndPassword(
                  email: signupData.name!, password: signupData.password!);
            } catch (error) {
              print(error);
              return Future<String>.value(error.toString().split('] ').last);
            }
          }),
          onRecoverPassword: (recoverPassword) {
            print('on recover password');
          },
          termsOfService: [
            TermOfService(
                id: 'general-term',
                mandatory: true,
                text: 'Term of services',
                linkUrl: 'https://github.com/NearHuscarl/flutter_login'),
          ],
          userValidator: (value) {
            RegExp emailRegex = RegExp(
              r"(?=.{1,254}$)(?=.{1,64}@)[-!#$%&'*+/0-9=?A-Z^_`a-z{|}~]+(\.[-!#$%&'*+/0-9=?A-Z^_`a-z{|}~]+)*@[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?(\.[A-Za-z0-9-]{2,63})+$",
            );
            if (!emailRegex.hasMatch(value!)) {
              return 'Not a valid email';
            }
            return null;
          },
          passwordValidator: (value) {
            if (value!.isEmpty) {
              return 'Password is empty';
            } else if (value.length < 6) {
              return 'Password is too short';
            }
            return null;
          },
          loginProviders: [
            LoginProvider(
                icon: FontAwesomeIcons.google,
                label: 'Google',
                callback: () async {
                  return null;
                },
                providerNeedsSignUpCallback: () => Future.value(true)),
            LoginProvider(
                callback: () async {
                  return null;
                },
                icon: FontAwesomeIcons.facebook,
                label: 'Facebook',
                providerNeedsSignUpCallback: () => Future.value(true)),
          ],
          // additionalSignupFields: [
          //   UserFormField(
          //       keyName: 'Username',
          //       icon: const Icon(FontAwesomeIcons.userLarge),
          //       fieldValidator: (value) {
          //         print('lalala' + email);
          //         if (value!.isEmpty) {
          //           return 'Username is empty';
          //         }
          //         _firestore.collection('profile').doc(email).set({
          //           'email': email,
          //           'username': value,
          //           'profile_image':
          //               'https://animecorner.me/wp-content/uploads/2022/01/roronoza-zoro-statue-in-japan.jpg'
          //         });
          //         return null;
          //       })
          // ],
          scrollable: true,
        )
      ],
    );
  }
}
