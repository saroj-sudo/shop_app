import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './login_page.dart';

final currentUserId = currentUser.uid;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void getCartItems() async {
    final currentUserId = currentUser.uid;

    await for (var snapshot
        in cartsRef.doc(currentUserId).collection('userCarts').snapshots()) {
      for (var item in snapshot.docs) {
        item.data();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream:
              cartsRef.doc(currentUserId).collection('userCarts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData) {
              return Center(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                ),
              );
            } else {
              List<Widget> cartItems = [];

              final items = snapshot.data.docs;
              for (var item in items) {
                final productname = item.data()['productname'];
                final price = item.data()['price'];
                final photoUrl = item.data()['photoUrl'];
                final newItem = ListTile(
                  leading: CircleAvatar(
                    radius: 26.0,
                    backgroundImage: NetworkImage(photoUrl),
                  ),
                  title: Text(productname),
                  trailing: Text(
                    price.toString(),
                  ),
                );
                cartItems.add(newItem);
              }
              return SafeArea(
                child: Column(
                  children: cartItems,
                ),
              );
            }
          }),
    );
  }
}
