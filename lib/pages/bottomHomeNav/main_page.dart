import 'package:blog_app/screens/articleScreens/edit_article_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../provider/homepage_level_provider.dart';
import '../../widgets/article_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      body: Column(
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
                  'ARTICLES',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                Icon(Icons.notifications),
              ],
            ),
          ),
          Divider(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            child: TabBar(
              controller: _tabController,
              labelPadding: EdgeInsets.only(left: 20, right: 20),
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'Recently',
                ),
                Tab(
                  text: 'Recommend',
                ),
              ],
            ),
          ),

          //TabBarView
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              child: TabBarView(
                controller: _tabController,
                children: [
                  recently(),
                  recommend(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget recently() {
    var otherblogs =
        Provider.of<HomePageLevelProvider>(context, listen: true).otherblogs;
    return Provider.of<HomePageLevelProvider>(context).isLoadingOtherBlog ==
            true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : otherblogs['status'] == 'fail'
            ? Center(
                child: Text(otherblogs['message'].toString()),
              )
            : otherblogs['data']['blogs'].length == 0
                ? Center(
                    child: Text('Empty'),
                  )
                : ListView.builder(
                    itemCount: otherblogs['data']['blogs'].length,
                    itemBuilder: (_, index) {
                      return ArticleCard(
                        onBookMark: ()async{
                          var res= await Provider.of<HomePageLevelProvider>(context, listen: false).createBookMark(otherblogs['data']['blogs'][index]['_id'].toString());
                          print('cccccccccccccccccccccccccccccccc${res}');
                          if(res['status']=='success'){
                            Fluttertoast.showToast(
                                msg: res['message'],
                                toastLength: Toast.LENGTH_LONG ,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 16,
                                timeInSecForIosWeb: 1);

                          }
                          else{
                            Fluttertoast.showToast(
                                msg: res['message'],
                                toastLength: Toast.LENGTH_LONG ,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 16,
                                timeInSecForIosWeb: 1);
                          }
                        },
                        onOpenArticle: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditArticleScreen(blog:{'blog': otherblogs['data']['blogs'][index]} , readingOnly: true,)));
                        },
                        coverImage: otherblogs['data']['blogs'][index]['content'][0]
                            ['insert']['image'],
                        title: otherblogs['data']['blogs'][index]['content'][1]
                            ['insert'],
                        isFavorite: false,
                        isMyArticle: false,
                      );
                    });
  }

  Widget recommend() {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (_, index) {
          return ArticleCard(
            coverImage: '',
            title: '',
            isFavorite: false,
            isMyArticle: false,
          );
        });
  }
}
