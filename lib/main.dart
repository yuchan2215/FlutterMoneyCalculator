import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sumMoney = 0;
  var isSelected = <bool>[true, false, false, false];
  final List<int> moneyTypes = [1, 5, 10, 50, 100, 1000, 2000, 5000, 10000];
  var moneys = <int>[0, 0, 0, 0, 0, 0, 0, 0, 0];
  var textController = List.generate(9, (index) => TextEditingController(text: "0"));

  //合計金額を計算して更新通知をする。
  void calcSumMoney() {
    setState(() {
      int tempSum = 0;
      for (int i = 0; i < moneyTypes.length; i++) {
        tempSum += moneyTypes[i] * moneys[i];
      }
      sumMoney = tempSum;
    });
  }

  //入力部から送られてくるメッセージをハンドルする。
  void handleText(String e, int index) {
    //intにパースできなければ0を入れる
    int value = int.tryParse(textController[index].value.text) ?? 0;
    //もし不正な入力値(空または文字列の長さが1ではないが、数字上は0)ならリセットする
    if(e.isEmpty || (value == 0 && e.length != 1)){
      textController[index].text = "0";
      textController[index].selection = TextSelection.fromPosition(const TextPosition(offset: 1));
    }
    moneys[index] = value;
    calcSumMoney();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Expanded(
                child: ListView.builder(
                    itemCount: moneyTypes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: SizedBox(
                        height: 50.0,
                        child: inputItems(index),
                      ));
                    })),
            const SizedBox(height: 10.0),
            toggleMoneyTypes(),
            moneyDisplay(),
          ]),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ///入力するためのアイテムを取得する
  Row inputItems(int index) {
    return Row(children: [
      SizedBox(
          width: 90.0,
          child: Text("${moneyTypes[index]}円",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20.0,
              ))),
      const SizedBox(width: 10.0),
      SizedBox(
          width: 40.0,
          height: 40.0,
          child: ElevatedButton(
            onPressed: () {
              //TODO 引くボタンが押された時のイベント
            },
            child: const Text("-", textAlign: TextAlign.center),
          )),
      const SizedBox(width: 10.0),
      //入力
      Expanded(
        child: Center(
          child: SizedBox(
            height: 40.0,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              enabled: true,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              maxLength: 10,
              maxLines: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: textController[index],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(
                    left: 10,
                    bottom: 20,
                  )),
              onChanged: (e) {
                handleText(e, index);
              },
            ),
          ),
        ),
      ),
      const SizedBox(width: 10.0),
      SizedBox(
          width: 40.0,
          height: 40.0,
          child: ElevatedButton(
            onPressed: () {
              //TODO 足すボタンが押された時のイベント
            },
            child: const Text("+", textAlign: TextAlign.center),
          ))
    ]);
  }

  //金種切り替えのトグルボタン
  ToggleButtons toggleMoneyTypes() {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < isSelected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = true;
            } else {
              isSelected[buttonIndex] = false;
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
