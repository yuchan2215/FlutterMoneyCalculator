import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../mainPage.dart';

var moneyInputTextController = List.generate(moneyTypes.length,
    (index) => TextEditingController(text: "0")); //入力値をまとめておくコントローラー

class InputItem extends StatelessWidget {
  const InputItem({Key? key, required this.index, required this.state})
      : super(key: key);
  final int index;
  final MainPageState state;

  //プラスまたはマイナスボタンが押された時
  void onButtonPressed(int index, int value) {
    int addValue = getSelectMoneyType() * value;
    String nowValue = moneyInputTextController[index].value.text;
    int nowIntValue = int.tryParse(nowValue) ?? 0;
    int newValue = nowIntValue + addValue;
    if (newValue < 0) newValue = 0;
    moneyInputTextController[index].text = newValue.toString();
    state.calcSumMoney();
  }

  //選択されている
  int getSelectMoneyType() {
    for (int i = 0; i < addMoneyTypes.length; i++) {
      if (state.selectedAddMoneyType[i]) return addMoneyTypes[i];
    }
    return 0;
  }

  //入力部から送られてくるメッセージをハンドルする。
  void handleText(String e, int index) {
    //intにパースできなければ0を入れる
    int value = int.tryParse(moneyInputTextController[index].value.text) ?? 0;
    int length = value.toString().length;
    //もし不正な入力値(空または文字列の長さが1ではないが、数字上は0)ならリセットする
    if (e.isEmpty || (value == 0 && e.length != 1)) {
      moneyInputTextController[index].text = "0";
      moneyInputTextController[index].selection =
          TextSelection.fromPosition(const TextPosition(offset: 1));
      //0xxxxの形式になったとき、0を消してカーソルを戻す。
    } else if (length != e.length) {
      int newOffset =
          moneyInputTextController[index].selection.extent.offset - 1;
      moneyInputTextController[index].text = value.toString();
      moneyInputTextController[index].selection =
          TextSelection.fromPosition(TextPosition(offset: newOffset));
    }
    state.calcSumMoney();
  }

  @override
  Widget build(BuildContext context) {
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
              onButtonPressed(index, -1);
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
              controller: moneyInputTextController[index],
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
              onButtonPressed(index, 1);
            },
            child: const Text("+", textAlign: TextAlign.center),
          ))
    ]);
  }
}
