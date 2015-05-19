import "package:dslink_markov/markov.dart";
import "dart:io";

main(List<String> args) async {
  var file = new File(args[0]);
  var markov = new MarkovChain();
  var data = (await file.readAsLines()).map((it) => it.substring(it.indexOf("]") + 2)).where((it) => it.startsWith("<")).map((it) {
    var name = it.substring(1, it.indexOf(">"));

    if (name.startsWith("@") || name.startsWith("+")) {
      name = name.substring(1);
    }

    var msg = it.substring(it.indexOf(">") + 2);
    return [
      name,
      msg
    ];
  }).toList();

  markov.load();

  for (var entry in data) {
    markov.addLine(entry[1]);
  }

  markov.save();
}
