import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:awesome_bookmark_icon_button/awesome_bookmark_icon_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? myUrl = "https://www.google.co.in/";
  double myProgress = 0;
  InAppWebViewController? webViewController;
  String? currentUrl;
  bool canForWord = false;
  bool canBack = false;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () {
        webViewController!.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await webViewController!.goBack();
        return (currentUrl == myUrl) ? true : false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Web View",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
          actions: [
            BookMarkIconButton(
              padding: EdgeInsets.all(10),
              isSaved: true,
              onPressed: () {},
            ),
            (canBack)
                ? IconButton(
                    onPressed: () async {
                      if (webViewController != null) {
                        await webViewController!.goBack();
                      }
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  )
                : Container(),
            IconButton(
              onPressed: () async {
                if (webViewController != null) {
                  await webViewController!.reload();
                }
                setState(() {});
              },
              icon: const Icon(
                CupertinoIcons.refresh,
              ),
            ),
            (canForWord)
                ? IconButton(
                    onPressed: () async {
                      if (webViewController != null) {
                        await webViewController!.goForward();
                      }
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.white,
                    ),
                  )
                : Container(),
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: myProgress,
              backgroundColor: Colors.blue,
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(myUrl!),
                ),
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  setState(() {
                    webViewController = controller;
                  });
                },
                onLoadStart: (controller, url) async {
                  setState(() {
                    currentUrl = url.toString();
                  });
                  canForWord = await webViewController!.canGoForward();
                  canBack = await webViewController!.canGoBack();
                  setState(() {});
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    currentUrl = url.toString();
                  });
                  canForWord = await webViewController!.canGoForward();
                  canBack = await webViewController!.canGoBack();
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
