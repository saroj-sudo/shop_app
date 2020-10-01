import 'package:flutter_icons/flutter_icons.dart';
import 'package:superMarket/widgets/drawer.dart';

import './login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superMarket/pages/product.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future getProducts() async {
    QuerySnapshot qn = await productsRef.get();
    return qn.docs;
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Entypo.menu,
            color: Colors.black,
            size: 26.0,
          ),
          onPressed: () {
            _drawerKey.currentState.openDrawer();
          },
        ),
        title: Text(
          "e-Commerci",
          style: TextStyle(
            backgroundColor: Theme.of(context).primaryColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: BuildDrawer(),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error has occured !!");
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data[index];
                  return Product(
                    productId: data.id,
                    productname: data.data()['productname'],
                    price: data.data()['price'],
                    photoUrl: data.data()['photoUrl'],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
