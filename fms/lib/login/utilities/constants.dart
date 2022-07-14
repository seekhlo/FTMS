import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fms/global.dart';

var kHintTextStyle = const TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

var kLabelStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

var kBoxDecorationStyle = BoxDecoration(
  color: mainColor[800],
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

class MaskTextInputFormatter extends TextInputFormatter {
  final int maskLength;
  final Map<String, List<int>> separatorBoundries;

  MaskTextInputFormatter({
    String mask = "xxxxx-xxxxxxx-x",
    List<String> separators = const ["-"],
  })  : this.separatorBoundries = {
          for (var v in separators)
            v: mask
                .split("")
                .asMap()
                .entries
                .where((entry) => entry.value == v)
                .map((e) => e.key)
                .toList()
        },
        this.maskLength = mask.length;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    final int oldTextLength = oldValue.text.length;
    // removed char
    if (newTextLength < oldTextLength) return newValue;
    // maximum amount of chars
    if (oldTextLength == maskLength) return oldValue;

    // masking
    final StringBuffer newText = StringBuffer();
    int selectionIndex = newValue.selection.end;

    // extra boundaries check
    final separatorEntry1 = separatorBoundries.entries
        .firstWhere((entry) => entry.value.contains(oldTextLength));
    if (separatorEntry1 != null) {
      newText.write(oldValue.text + separatorEntry1.key);
      selectionIndex++;
    } else {
      newText.write(oldValue.text);
    }
    // write the char
    newText.write(newValue.text[newValue.text.length - 1]);

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
