import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Auth/sign_up_screen.dart';
import './Auth/sign_in_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 02',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.blue,
        // ),
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
        );
      } else {
        print('User is signed in!');
        print("User ${user.toString()}");
      }
    });
  }

  final CollectionReference _product =
      FirebaseFirestore.instance.collection('recipe');

  final TextEditingController _DescriptionController = TextEditingController();
  final TextEditingController _IngredientsController = TextEditingController();
  final TextEditingController _TitleController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _DescriptionController.text = documentSnapshot['Discription'];
      _IngredientsController.text = documentSnapshot['Ingredients'];
      _TitleController.text = documentSnapshot['Tital'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _DescriptionController,
                    decoration: const InputDecoration(labelText: 'Discription'),
                  ),
                  TextField(
                    controller: _IngredientsController,
                    decoration: const InputDecoration(labelText: 'Ingredients'),
                  ),
                  TextField(
                    controller: _TitleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final String Discription = _DescriptionController.text;
                      final String Ingredients = _IngredientsController.text;
                      final String Title = _TitleController.text;
                      if (Title != null) {
                        await _product.doc(documentSnapshot!.id).update({
                          "Discription": Discription,
                          "Ingredients": Ingredients,
                          "Title": Title
                        });
                        _DescriptionController.text = '';
                        _IngredientsController.text = '';
                        _TitleController.text = '';
                      }
                    },
                  ),
                ]),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _DescriptionController.text = documentSnapshot['Discription'];
      _IngredientsController.text = documentSnapshot['Ingredients'];
      _TitleController.text = documentSnapshot['Tital'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _DescriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: _IngredientsController,
                    decoration: const InputDecoration(labelText: 'Ingredients'),
                  ),
                  TextField(
                    controller: _TitleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () async {
                      final String Discription = _DescriptionController.text;
                      final String Ingredients = _IngredientsController.text;
                      final String Tital = _TitleController.text;
                      if (Tital != null) {
                        await _product.add({
                          'Discription': Discription,
                          'Ingredients': Ingredients,
                          'Tital': Tital
                        });
                        _DescriptionController.text = '';
                        _IngredientsController.text = '';
                        _TitleController.text = '';
                      }
                    },
                  ),
                ]),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _product.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully deleted a product'),
      ),
    );
  }

  Future<String?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: "Sign Out Successfull");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        ),
      );
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signOut();
              },
              tooltip: 'Sign Out',
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
          stream: _product.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Tital:  ' + documentSnapshot['Tital']),
                      subtitle: Text('Ingredients:  \n' +
                          documentSnapshot['Ingredients'] +
                          '\n' +
                          'Discription:  \n' +
                          documentSnapshot['Discription']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => _update(documentSnapshot),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () => _delete(documentSnapshot.id),
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
