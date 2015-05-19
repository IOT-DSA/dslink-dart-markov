import "package:dslink_markov/markov.dart";

main(List<String> args) {
  if (args.length != 1) {
    args = ["1"];
  }

  var times = int.parse(args[0]);

  var markov = new MarkovChain();
  markov.load();

  for (var i = 1; i <= times; i++) {
    print("${markov.randomSentence()}");
  }
}
