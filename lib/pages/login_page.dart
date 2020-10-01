import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:superMarket/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String name, email, photoUrl, date;

final GoogleSignIn googleSignIn = GoogleSignIn();
final firebaseAuth = FirebaseAuth.instance;

final usersRef = FirebaseFirestore.instance.collection('users');
final productsRef = FirebaseFirestore.instance.collection("products");
final cartsRef = FirebaseFirestore.instance.collection('carts');
final favouritesRef = FirebaseFirestore.instance.collection("favourites");
final currentUser = firebaseAuth.currentUser;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();

    //detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    //Reauthenticate user when app is opend
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print(account.email);
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  Future<String> signInWithGoogl() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authcredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authcredential);
    final User user = userCredential.user;

    assert(user.displayName != null);
    assert(user.email != null);
    assert(user.photoURL != null);

    // assert(await user.getIdToken() != null);
    setState(() {
      name = user.displayName;
      email = user.email;
      photoUrl = user.photoURL;
    });

    final User currentUser = firebaseAuth.currentUser;
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle Succeded: $user';
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Theme.of(context).primaryColor,
      onPressed: () => signInWithGoogl().whenComplete(
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget unAuthPage() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 150),
            SizedBox(height: 50),
            _signInButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isAuth ? HomePage() : unAuthPage(),
    );
  }
}
