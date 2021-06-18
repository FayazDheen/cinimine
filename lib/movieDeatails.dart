import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemine/model/movie-model.dart';
import 'package:flutter/material.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails(
      {Key? key,
      required this.movieDetails,
      required this.heroTag,
      this.noData = false})
      : super(key: key);
  final MovieModel movieDetails;
  final heroTag;
  final bool noData;

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late MovieModel movieDetail;
  @override
  void initState() {
    movieDetail = widget.movieDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff2a2a2a),
          body: widget.noData
              ? Container(
                  child: Center(
                    child: Text(
                      "Data not available yet !",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: Hero(
                            tag: widget.heroTag,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://www.themoviedb.org/t/p/w220_and_h330_face${movieDetail.posterPath}",
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Container(
                                  height: 500,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) => Container(
                                  height: 500,
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 50,
                                  )),
                            ),
                          ),

                          // height: ,
                          width: MediaQuery.of(context).size.width,

                          // color: Colors.red,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            child: Text(
                              "\t" + movieDetail.overview,
                              textAlign: TextAlign.justify,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
