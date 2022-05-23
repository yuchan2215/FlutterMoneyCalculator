import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerItem extends StatelessWidget {
  final Future<PackageInfo> info = PackageInfo.fromPlatform();
  final Center appIcon = const Center(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Image(
              image: AssetImage('assets/icon/icon.png'),
            ),
          )));

  DrawerItem({Key? key}) : super(key: key);

  ///ライセンス用説明文
  List<Widget> aboutBox(BuildContext context) {
    return <Widget>[
      RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: const <TextSpan>[
              TextSpan(text: "各硬貨の枚数から合計を求める。"),
            ],
          ))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text("財布の中身計算機")),
        FutureBuilder<PackageInfo>(
          future: info,
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            if (snapshot.hasData) {
              String version = snapshot.data?.version ?? "";
              String title = snapshot.data?.appName ?? "";
              return AboutListTile(
                icon: const Icon(Icons.info),
                applicationIcon: appIcon,
                applicationVersion: version,
                applicationName: title,
                applicationLegalese: '\u{a9} 2022 Miyayu',
                aboutBoxChildren: aboutBox(context),
                child: const Text("このアプリについて"),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ]),
    );
  }
}
