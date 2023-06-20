import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quotes/model/quotesData.dart';
import 'package:quotes/service/appService.dart';
import 'package:quotes/utils/checkConnectivity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color scaffoldColor = Colors.blue.withOpacity(0.5);
  final FetchApi _fetchApi = FetchApi();
  Quote? quote;

  @override
  void initState() {
    fetchQuoteAndAuthor();
    super.initState();
  }

  void fetchQuoteAndAuthor() {
    _fetchApi.fetchQuote().then((fetchedQuote) {
      setState(() {
        quote = fetchedQuote;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: scaffoldColor,
        actions: [
          IconButton(
              onPressed: () {
                CheckInternetConnectivity()
                    .checkInternetConnection()
                    .then((hasInternet) {
                  if (hasInternet) {
                    fetchQuoteAndAuthor();
                    Future.delayed(const Duration(milliseconds: 900), () {
                      setState(() {
                        scaffoldColor = Color(Random().nextInt(0xff000000))
                            .withOpacity(0.5);
                      });
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("No Internet"),
                        behavior: SnackBarBehavior.floating));
                  }
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      backgroundColor: scaffoldColor,
      body: Center(
        child: quote != null
            ? Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quote!.content!,
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "~ ${quote!.author!}",
                      style: textTheme.displaySmall!.copyWith(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 68, 66, 66),
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
