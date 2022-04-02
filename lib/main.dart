import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const uri = 'https://jsonplaceholder.typicode.com/albums/2';

Future<Album> fetchAlbum() async {
  //MAKING API CALL
  final response = await http.get(Uri.parse(uri));

  //CHECK RESPONSE
  if (response.statusCode == 200) {
    //Kalo oke, langsung convert body responsenya dari json ke dalem model.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Fail to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], userId: json['userId'], title: json['title']);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String txt = "placeholder";
  late Future<Album> album;

  @override
  void initState() {
    super.initState();
    album = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API CALL'),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('DATA INI DIDAPAT DARI INTERNET'),
        FutureBuilder<Album>(
            future: album,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            })
      ])),
    );
  }
}
