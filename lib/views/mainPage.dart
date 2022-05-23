import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_calc/views/widgets/mainPage/inputItem.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

///使用する硬貨の種類
final List<int> moneyTypes = [1, 5, 10, 50, 100, 500, 1000, 2000, 5000, 10000];
final List<int> addMoneyTypes = [1, 10, 20, 50];

class MainPageState extends State<MainPage> {
  int sumMoney = 0; //合計金額

  var selectedAddMoneyType = List.generate(
      addMoneyTypes.length, (index) => index == 0); //選択されている追加するお金の種類

  Future<PackageInfo> info = PackageInfo.fromPlatform();

  //合計金額を計算して更新通知をする。
  void calcSumMoney() {
    setState(() {
      int tempSum = 0;
      for (int i = 0; i < moneyTypes.length; i++) {
        int inputMoney = getInputMoney(i);
        tempSum += moneyTypes[i] * inputMoney;
      }
      sumMoney = tempSum;
    });
  }

  //コントローラーから、入力された数値を取得する。
  int getInputMoney(int index) {
    TextEditingController controller = moneyInputTextController[index];
    String inputText = controller.value.text;
    int inputInt = int.tryParse(inputText) ?? 0;
    return inputInt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 3.0),
          child: Column(children: [
            Expanded(
                child: ListView.builder(
                    itemCount: moneyTypes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: SizedBox(
                              height: 50.0,
                              child: InputItem(
                                index: index,
                                state: this,
                              )));
                    })),
            const SizedBox(height: 10.0),
            toggleMoneyTypes(),
            moneyDisplay(),
          ]),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

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

  ///Drawer
  Drawer buildDrawer(BuildContext context) {
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
                applicationIcon: myAppIcon(),
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

  ///About用アイコン
  Center myAppIcon() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Image(
            image: AssetImage('assets/icon/icon.png'),
          ),
        ),
      ),
    );
  }

  //金種切り替えのトグルボタン
  ToggleButtons toggleMoneyTypes() {
    return ToggleButtons(
      isSelected: selectedAddMoneyType,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < selectedAddMoneyType.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              selectedAddMoneyType[buttonIndex] = true;
            } else {
              selectedAddMoneyType[buttonIndex] = false;
            }
          }
        });
      },
      children: const [Text("1"), Text("10"), Text("20"), Text("50")],
    );
  }

  /// 金額を表示する
  Row moneyDisplay() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("合計金額:"),
          Text(
            "$sumMoney",
            style: const TextStyle(
              fontSize: 40.0,
            ),
          ),
          const Text("円"),
        ]);
  }
}
