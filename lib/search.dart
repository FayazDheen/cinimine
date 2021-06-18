import 'package:cinemine/movieDeatails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'model/movie-model.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

var debouncer;

class _SearchState extends State<Search> {
  TextEditingController texter = TextEditingController();

  var movies = [];
  bool loading = false;
  String centerText = "Click Search";

  void getResults(q) async {
    movies = [];
    setState(() {
      loading = true;
    });
    var url =
        "https://api.themoviedb.org/3/search/company?api_key=3a3dff724644354ed47fde58d07a55d7&query=${q.toString()}";
    var response = await http.get(Uri.parse(url));
    var res = convert.jsonDecode(response.body);
    print(res);

    setState(() {
      movies = res["results"] == null ? [] : res["results"];
      if (movies.length < 1) {
        centerText = "No results found !";
      }
      loading = false;
    });
  }

  List<Widget> generateList() {
    List<Widget> tiles = [];

    movies.forEach((e) {
      if (e["logo_path"] != null) {
        tiles.add(GestureDetector(
          onTap: () async {
            var url = Uri.parse(
                'https://api.themoviedb.org/3/movie/${e["id"]}?api_key=3a3dff724644354ed47fde58d07a55d7');
            var response = await http.get(url);
            var res = convert.jsonDecode(response.body);
            print("\n");
            print(res);
            var heroTaggy =
                res["success"] == false ? "No Data Found" : e["name"];
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieDetails(
                          heroTag: heroTaggy,
                          movieDetails: MovieModel.createMovie(res),
                          noData: res["success"] == false,
                        )));
          },
          child: ListTile(
            title: Text(e["name"].toString()),
            leading: e["logo_path"] == null
                ? Icon(Icons.image)
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.themoviedb.org/t/p/w220_and_h330_face${e["logo_path"]}"),
                  ),
          ),
        ));
      }
    });
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: TextField(
          autofocus: true,
          cursorHeight: 20,
          decoration: InputDecoration(
              hintText: "Enter movie name to search",
              focusedBorder: InputBorder.none),
          controller: texter,
          onChanged: (val) {
            // debouncer = debounce();
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.blue,
              ),
              onPressed: () {
                print(texter.text);
                if (texter.text.isEmpty) {
                  setState(() {
                    centerText = "Seach query cannot be empty";
                    loading = false;
                    movies = [];
                  });
                } else {
                  getResults(texter.text);
                }
              })
        ],
      ),
      body: movies.length < 1
          ? loading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  child: Center(
                    child: Text(centerText.toString()),
                  ),
                )
          : ListView(
              children: generateList(),
            ),
    );
  }
}
