import 'package:flutter/material.dart';
import 'package:store_front/pages/pages_structure/page_structure.dart';
import 'commands_page.dart';

abstract class GridButton extends StatelessWidget {
  final String desc;
  final IconData iconData;
  final Widget nextPage;

  const GridButton(
      {super.key,
      required this.desc,
      required this.iconData,
      required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
            },
            child: Icon(
              iconData,
              color: Colors.lightBlue,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: 20,
            ),
            child: FittedBox(
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SampleButton extends GridButton {
  const SampleButton({super.key})
      : super(
            desc: "Sample",
            iconData: Icons.abc,
            nextPage: const SampleBasicPage());
}
