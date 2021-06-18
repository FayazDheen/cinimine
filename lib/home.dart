import 'package:cinemine/model/movie-model.dart';
import 'package:cinemine/search.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'movieDeatails.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  int pageNumber = 1;
  var totalPages = 0;
  var movielist = [];
  ScrollController scroller = ScrollController();

  getTotalPages() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=3a3dff724644354ed47fde58d07a55d7');
    var response = await http.get(url);
    var res = convert.jsonDecode(response.body);
    totalPages = res["total_pages"];
    print(totalPages);
    getMovies();
  }

  getMovies() async {
    setState(() {
      loading = true;
    });
    var movies = [];

    while (movies.length < 20 && pageNumber <= totalPages) {
      print("- - - - - - page $pageNumber");
      var url = Uri.parse(
          'https://api.themoviedb.org/3/movie/upcoming?api_key=3a3dff724644354ed47fde58d07a55d7&page=$pageNumber');
      var response = await http.get(url);
      var res = convert.jsonDecode(response.body);
      var moviemap = res["results"];
      for (var item in moviemap) {
        if (DateTime.parse(item["release_date"]).isAfter(DateTime.now())) {
          movies.add(MovieModel.createMovie(item));
        }
      }
      pageNumber++;
    }

    setState(() {
      movielist.addAll(movies);
      loading = false;
    });
    print(movielist);
  }

  String dateAsReadable(DateTime d, String f) {
    DateFormat formatter = new DateFormat(f);
    return formatter.format(d);
  }

  @override
  void initState() {
    getTotalPages();
    scroller.addListener(() {
      if (scroller.position.pixels == scroller.position.maxScrollExtent) {
        getMovies();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff3b3b3b),
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Search()));
                })
          ],
          backgroundColor: Color(0xff2a2a2a),
          title: Text(
            "Upcoming movies",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          // centerTitle: true,
        ),
        body: movielist.length == 0
            ? Container(
                child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ))
            : Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // childAspectRatio: 1.5,
                        mainAxisSpacing: 30,
                      ),
                      controller: scroller,
                      itemCount: movielist.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MovieDetails(
                                        movieDetails: movielist[index],
                                        heroTag: movielist[index]
                                            .title
                                            .toString())));
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              // CircleAvatar(
                              //   minRadius: MediaQuery.of(context).size.width / 3,
                              //   backgroundImage: NetworkImage(
                              //     "https://www.themoviedb.org/t/p/w220_and_h330_face${movielist[index].posterPath}",
                              //     scale: 10,
                              //   ),
                              // ),
                              Container(
                                  height: 300,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(50),
                                      ),
                                  child: Hero(
                                    tag: movielist[index].title.toString(),
                                    child: Image(
                                      // fit: BoxFit.,
                                      image: NetworkImage(
                                        "https://www.themoviedb.org/t/p/w220_and_h330_face${movielist[index].posterPath}",

                                        //   // scale: 10,
                                      ),
                                      errorBuilder:
                                          (context, exception, stackTrack) =>
                                              Icon(
                                        Icons.error,
                                      ),
                                    ),
                                  )),
                              Container(
                                height: 300,
                                width: 140,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(50),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.45, 1],
                                    colors: [
                                      Color(0xff000000).withOpacity(.1),
                                      Color(0xff000000).withOpacity(.9)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 4,
                                child: Text(
                                  movielist[index].title,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),

                              Positioned(
                                top: 5,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    movielist[index]
                                        .releaseDate
                                        .toString()
                                        .split(" ")[0],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  loading
                      ? Container(
                          height: 50,
                          width: 30,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          color: Colors.transparent,
                          child: Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          )),
                        )
                      : SizedBox(
                          height: 20,
                        )
                ],
              ),
      ),
    );
  }
}
