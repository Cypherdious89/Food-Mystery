import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './RecipeTag.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard(
      {@required this.recipe,
      @required this.cookName,
      @required this.dishImage,
      @required this.openFunc,
      @required this.rating,
      @required this.cuisineTag,
      @required this.likes});
  final Function openFunc;
  final String recipe;
  final String cookName;
  final String dishImage;
  final double rating;
  final String cuisineTag;
  final int likes;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openFunc,
      child: Stack(
        children: <Widget>[
          Container(
            width: 353.5,
            height: 265.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: const Color(0xffffffff),
              border: Border.all(width: 0.5, color: const Color(0xffab47bc)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x85bb6bc9),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(15.0, 11.5),
            child: SizedBox(
              width: 146.0,
              height: 160,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        recipe,
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Dish by',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 17.5,
                          color: const Color(0xff000000),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        cookName,
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 18.6,
                          color: const Color(0xffab47bc),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ]),
            ),
          ),
          Transform.translate(
            offset: Offset(2, 174.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 12.5),
                RecipeTag(tagName: cuisineTag),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(177.5, 12.0),
            child:
                // Adobe XD layer: 'kadai-paneer-gravy-…' (shape)
                Container(
              width: 147.5,
              height: 141.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21.0),
                image: DecorationImage(
                  image: NetworkImage(dishImage),
                  fit: BoxFit.fill,
                ),
                border: Border.all(width: 1.5, color: const Color(0xffab47bc)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(17.0, 214.0),
            child: SizedBox(
                width: 284,
                height: 44,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Rating:  ",
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      "${rating.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffab47bc),
                      ),
                    ),
                    Icon(Icons.star_half, size: 27.5, color: Color(0xffab47bc)),
                    SizedBox(width: 15),
                    Text(
                      "Likes:  ",
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      "$likes",
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffFFBF00),
                      ),
                    ),
                    Icon(Icons.favorite, size: 27.5, color: Color(0xffFFBF00)),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
