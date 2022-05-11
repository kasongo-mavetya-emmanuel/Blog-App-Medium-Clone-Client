import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/homepage_level_provider.dart';
import '../../screens/articleScreens/edit_article_screen.dart';

class BookMarksPage extends StatefulWidget {
  const BookMarksPage({Key? key}) : super(key: key);

  @override
  _BookMarksPageState createState() => _BookMarksPageState();
}

class _BookMarksPageState extends State<BookMarksPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SAVED',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              Divider(),
            ],
          ),
        ),
        Divider(),
        Expanded(
            flex: 5,
            child: Container(
              height: double.infinity,
              child: getBookMarks(),
            )),
      ],
    );
  }

  Widget getBookMarks() {
    final bookMarks =
        Provider.of<HomePageLevelProvider>(context, listen: true)
            .bookMarks;
    return Provider.of<HomePageLevelProvider>(context).isLoadingBookMarks == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : bookMarks['status'] == 'fail'
            ? Center(
                child: Text(bookMarks['message'].toString()),
              )
            : bookMarks['data']['bookMarks'].length == 0
                ? Center(
                    child: Text('Empty'),
                  )
                : ListView.builder(
                      itemCount:bookMarks['data']['bookMarks'].length,itemBuilder: (_, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap:() {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditArticleScreen(blog:{'blog': bookMarks['data']['bookMarks'][index]} , readingOnly: true,)));

                        },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(bookMarks['data']['bookMarks'][index]['blog']['content'][0]['insert']['image'],),fit: BoxFit.cover),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  bookMarks['data']['bookMarks'][index]['blog']['content'][1]['insert'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(

                                                children: [
                                                  Text('feb-8'),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('7'),
                                                  Icon(Icons.comment_sharp)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  });
  }
}
