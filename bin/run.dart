import "dart:async";

import "package:dslink/client.dart";
import "package:dslink/responder.dart";

import "package:dslink_markov/markov.dart";

MarkovChain markov;
LinkProvider link;

main(List<String> args) async {
  markov = new MarkovChain();
  markov.load();

  link = new LinkProvider(
    args,
    "MarkovChain-",
    defaultNodes: {
      "Add": {
        r"$is": "add",
        r"$invokable": "write",
        r"$params": [
          {
            "name": "line",
            "type": "string"
          }
        ]
      },
      "Respond": {
        r"$is": "respond",
        r"$invokable": "read",
        r"$params": [
          {
            "name": "input",
            "type": "string"
          }
        ],
        r"$result": "values",
        r"$columns": [
          {
            "name": "response",
            "type": "string"
          }
        ]
      }
    },
    profiles: {
      "add": (String path) => new AddNode(path),
      "respond": (String path) => new RespondNode(path)
    }
  );

  link.connect();

  new Timer.periodic(new Duration(seconds: 90), (_) {
    if (changed) {
      markov.save();
      changed = false;
    }
  });
}

bool changed = false;

class AddNode extends SimpleNode {
  AddNode(String path) : super(path);

  @override
  onInvoke(Map<String, dynamic> params) {
    markov.addLine(params["line"]);
    changed = true;

    return {};
  }
}

class RespondNode extends SimpleNode {
  RespondNode(String path) : super(path);

  @override
  onInvoke(Map<String, dynamic> params) {
    return {
      "response": markov.reply(params["input"], "DSA", "MarkovLink")
    };
  }
}
