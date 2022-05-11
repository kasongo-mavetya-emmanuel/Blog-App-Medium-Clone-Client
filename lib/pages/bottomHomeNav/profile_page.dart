import 'package:blog_app/main.dart';
import 'package:blog_app/provider/homepage_level_provider.dart';
import 'package:blog_app/screens/articleScreens/edit_article_screen.dart';
import 'package:blog_app/screens/profileScreens/editpassword_screen.dart';
import 'package:blog_app/screens/profileScreens/editprofile_screen.dart';
import 'package:blog_app/services/newtworkHandler.dart';
import 'package:blog_app/widgets/article_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
               OutlinedButton(
                   style: OutlinedButton.styleFrom(
                       shape: StadiumBorder()),
                   onPressed: ()async {
                     await FlutterSecureStorage().delete(key: 'token');

                     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                         builder: (_) => MyApp()),(route) => false);
                   },
                   child: Text('LogOut')),
               Container(
                 child: Icon(Icons.settings),
               ),
             ]),
           ),
            SizedBox(
              height: 10,
            ),
            profileWidget(),
            Divider(),
            //TabBar
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
                    text: 'published',
                  ),
                  Tab(
                    text: 'favorite',
                  ),
                  Tab(
                    text: 'drafts',
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
                    myMpublishedArticles(),
                    favorites(),
                    createArticle(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget profileWidget() {
    Map profileDetails =
        Provider.of<HomePageLevelProvider>(context, listen: true)
            .profileDetails;
    return profileDetails.length == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : profileDetails['status'] == 'fail'
            ? Center(
                child: Text(profileDetails['message'].toString()),
              )
            : Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profileDetails['data']['user']
                                  ['photo'] !=
                              null
                          ? NetworkImage(
                              NetworkHandler().getImagePath(
                                  '/users/${profileDetails['data']['user']['photo']}'),
                            )
                          : AssetImage("assets/google.png") as ImageProvider,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          profileDetails['data']['user']['name'] ?? 'Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(profileDetails['data']['user']['profession'] ??
                            'profession'),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder()),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => EditProfileScreen(
                                          details: profileDetails['data'])));
                                },
                                child: Text('Edit Profile')),
                            SizedBox(
                              width: 5,
                            ),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: StadiumBorder()),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => EditPassWordScreen(
                                          userId: profileDetails['data']['user']
                                              ['_id'])));
                                },
                                child: Text('Edit Password')),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
  }

  Widget myMpublishedArticles() {
    final myPublishedBlogs =
        Provider.of<HomePageLevelProvider>(context, listen: true)
            .myPublishedBlogs;
    return Provider.of<HomePageLevelProvider>(context).isLoadingMyBlogs == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : myPublishedBlogs['status'] == 'fail'
            ? Center(
                child: Text(myPublishedBlogs['message'].toString()),
              )
            : myPublishedBlogs['content'].length == 0
                ? Center(
                    child: Text('Empty'),
                  )
                : ListView.builder(
                    itemCount: myPublishedBlogs['content'].length,
                    itemBuilder: (_, index) {
                      return ArticleCard(
                        isFavorite: false,
                        isMyArticle: true,
                        onOpenArticle: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditArticleScreen(blog:{'blog': myPublishedBlogs['content'][index]} , readingOnly: true,)));
                        },
                        onEditArticle: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditArticleScreen(blog:{'blog': myPublishedBlogs['content'][index]},readingOnly: false,)));

                        },
                        coverImage: myPublishedBlogs['content'][index]
                            ['content'][0]['insert']['image'],
                        title: myPublishedBlogs['content'][index]['content'][1]
                            ['insert'],
                      );
                    });
  }

  Widget favorites() {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (_, index) {
          return ArticleCard(
            coverImage: '',
            title: '',
            isFavorite: true,
            isMyArticle: false,
          );
        });
  }

  Widget createArticle() {
    final myDraftedBlogs =
        Provider.of<HomePageLevelProvider>(context, listen: true)
            .myDraftedBlogs;
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Provider.of<HomePageLevelProvider>(context).isLoadingMyBlogs ==
                  true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : myDraftedBlogs['status'] == 'fail'
                  ? Center(
                      child: Text(myDraftedBlogs['message'].toString()),
                    )
                  : myDraftedBlogs['content'].length == 0
                      ? Center(
                          child: Text('Empty'),
                        )
                      : ListView.builder(
                          itemCount: myDraftedBlogs['content'].length,
                          itemBuilder: (_, index) {
                            return ArticleCard(
                              onEditArticle: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditArticleScreen(blog:{'blog': myDraftedBlogs['content'][index]} )));

                              },
                              coverImage: myDraftedBlogs['content'][index]
                                  ['content'][0]['insert']['image'],
                              title: myDraftedBlogs['content'][index]['content']
                                  [1]['insert'],
                              isFavorite: false,
                              isDraft: true,
                              isMyArticle: true,
                            );
                          }),
        ),
        Positioned(
            bottom: 30,
            right: 10,
            child:
                Provider.of<HomePageLevelProvider>(this.context, listen: true)
                            .isCreating ==
                        true
                    ? Container(
                        width: 30,
                        height: 30,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          var blog = await Provider.of<HomePageLevelProvider>(
                                  context,
                                  listen: false)
                              .createArticle();
                          //await context.read<DataProvider>().createArticle();
                          if (blog['status'] == 'success') {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => EditArticleScreen(
                                          blog: blog['data'],
                                        )))
                                .then((value) async {
                              await Provider.of<HomePageLevelProvider>(context,
                                      listen: false)
                                  .fetchProfileData();
                            });
                          } else if (blog['status'] == 'fail') {
                            Fluttertoast.showToast(
                                msg: blog['message'],
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 16,
                                timeInSecForIosWeb: 1);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), padding: EdgeInsets.all(20)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      )),
      ],
    );
  }
}
