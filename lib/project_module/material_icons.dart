import 'dart:core';

import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

abstract class MaterialIcons {
  static final int _start = 57344;
  static final int _end = 63743;

  static final _groups = [57399, 57443, 57458, 57505, 57524];

  static navigate(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (c) => MaterialIconsListPage()));
  }

  static List<List<int>> get groups {
    List<List<int>> groupEnd = [];
    for (var i = 0; i < _groups.length; ++i) {
      var o = _groups[i];
      int startIndex;
      if (i == 0) {
        startIndex = _start;
      } else {
        startIndex = _groups[i - 1];
      }
      groupEnd.add(List.generate(o - startIndex, (i) => i + startIndex));
    }
    groupEnd.add(List.generate(_end - _groups.last, (i) => i + _groups.last));
    return groupEnd;
  }

  static Widget fromInt(int id, {Color? color, double? size}) {
    return Icon(
      IconData((id), fontFamily: 'MaterialIcons'),
      color: color ?? getColorScheme().primary,
      size: size,
    );
  }

  static Widget draw() {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          ...MaterialIcons.groups.map(
            (i) => Wrap(
              children: i
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        ['code', e].print();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          IconData((e), fontFamily: 'MaterialIcons'),
                          color: getColorScheme().primary.withAlpha(125),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // ...List.generate(
          //   63743 - 57344,
          //   (i) => GestureDetector(
          //     onTap: () {
          //       ['code', i + 57344].print();
          //     },
          //     child: Container(
          //       width: 30,
          //       height: 30,
          //       child: Icon(
          //         IconData((i + 57344), fontFamily: 'MaterialIcons'),
          //         color: getColorScheme().primary.withAlpha(125),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class MaterialIconsListPage extends StatelessWidget {
  const MaterialIconsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialIcons.draw();
  }
}
