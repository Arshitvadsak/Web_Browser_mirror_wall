import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController pullToRefreshController;
  late List allList = [];

  @override
  void initState(){
    super.initState();
     pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.black),
      onRefresh: () async {
        await inAppWebViewController?.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.only(top: 37),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InAppWebView(
                    onWebViewCreated: (controller) {
                      setState(() {
                        inAppWebViewController = controller;
                      });
                    },
                    pullToRefreshController: pullToRefreshController,
                    onLoadStop: ((controller, url) async {
                      await pullToRefreshController.endRefreshing();
                    }),
                    initialUrlRequest:
                        URLRequest(url: Uri.parse("https://www.google.co.in/")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FloatingActionButton(
                      onPressed: () async {
                        Uri? uri = await inAppWebViewController?.getUrl();
                        String Url = uri.toString();

                        allList.add(Url);
                      },
                      child:
                          Icon(Icons.bookmarks_outlined, color: Colors.black),
                      backgroundColor: Colors.white,
                      mini: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      await inAppWebViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: Uri.parse("https://www.google.co.in/"),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await inAppWebViewController?.goBack();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await inAppWebViewController?.goForward();
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await inAppWebViewController?.reload();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return SingleChildScrollView(
                            child: AlertDialog(
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              title: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Center(
                                    child: Text(
                                  "List of Url",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                )),
                              ),
                              content: Column(
                                children: allList
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                          await inAppWebViewController?.loadUrl(
                                            urlRequest: URLRequest(
                                              url: Uri.parse(e),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                height: 200,
                                                width: 200,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  color: Colors.grey,
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Google.webp"),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Text(
                                                    e,
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                    ),
                                    child: Text("Back"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
