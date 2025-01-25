import 'package:flutter/material.dart';
import '../constant.dart';

class AsyncDone extends StatelessWidget {
  const AsyncDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            children: [
              Icon(
                Icons.circle,
                color: themeColor,
                size: 100,
              ),
              Icon(
                Icons.done,
                color: Colors.white,
                size: 100,
              ),
            ],
          ),
          Text(
            "Success!",
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
        ],
      ),
    );
  }
}

class AsyncFailed extends StatelessWidget {
  const AsyncFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 100,
              ),
            ],
          ),
          Text(
            "Failed!",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
        ],
      ),
    );
  }
}

class AsyncWaiting extends StatelessWidget {
  const AsyncWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Icon(
                Icons.access_time,
                color: themeColor,
                size: 100,
              ),
            ],
          ),
          Text(
            "Processing...",
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
        ],
      ),
    );
  }
}

