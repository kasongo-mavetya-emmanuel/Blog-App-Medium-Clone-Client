import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {

  ArticleCard({Key? key,this.onEditArticle, this.isDraft=false,this.onBookMark, this.onOpenArticle, required this.coverImage, required this.title, required this.isMyArticle, required this.isFavorite }) : super(key: key);
  String coverImage='';
  String title='';
  VoidCallback? onOpenArticle;
  VoidCallback? onBookMark;
  VoidCallback? onEditArticle;

  final bool isMyArticle;
  final bool? isDraft;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: onOpenArticle,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: coverImage!=null? NetworkImage(coverImage) :AssetImage('assets/email.png') as ImageProvider,
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(7),
                height: 100,
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                             title!= ''? title : 'Happy Reading',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            children: [
                              Text('7 Feb'),
                              SizedBox(width: 5,),
                              Icon(Icons.favorite_sharp),
                              Text('5'),
                            ],
                          ),
                        ],

                      ),
                    ),

               isFavorite==true? Expanded(
                 flex: 2,
                   child: Icon(Icons.favorite_sharp, color: Colors.red, size: 40,)):
               Expanded(
                 flex: 1,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isDraft==false? Text('7'): Container(),
                      isDraft==false?Icon(Icons.comment):Icon(Icons.delete),
                     SizedBox(width: 2,),

                     isMyArticle==false?Row(
                       children: [
                         SizedBox(width: 20,),
                         InkWell(
                           onTap: onBookMark,
                             child: Icon(Icons.bookmark_border)),
                         SizedBox(width: 20,),
                       ],
                     ):
                     OutlinedButton(
                        style: OutlinedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(20)),
                          onPressed: onEditArticle, child: Icon(Icons.edit, color: Colors.blue,)),
                    ],
                  ),
               ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );;
  }
}
