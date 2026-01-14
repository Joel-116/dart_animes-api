import 'dart:async';
import 'package:dart_animes/api_key.dart';
import 'package:http/http.dart';
import 'dart:convert';

const String gistRawUrl =
    "https://gist.githubusercontent.com/Joel-116/98da7e34252e27f87f1e875080e62365/raw/93f79b6599568c076e113e5e9ad91f4768fb7460/animes.json";
const String gistId =
    "https://api.github.com/gists/98da7e34252e27f87f1e875080e62365";

StreamController<dynamic> streamController = StreamController<dynamic>();

void main() async {
  streamController.stream.listen((dynamic date) {
    print(date);
  });
  await requestAnime('Dragon Ball');
  await requestEnergy('Ki');
  await requestAge(42);
}

Future<List<dynamic>> fetchLiveList() async {
  try {
    Response response = await get(
      Uri.parse(gistId),
      headers: {"Authorization": "Bearer $githubApiKey"},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode.toString()[0] == "2") {
      Map<String, dynamic> gistData = json.decode(response.body);
      String content = gistData['files']['animes.json']['content'];
      return json.decode(content);
    } else {
      streamController.add(
        "${DateTime.now()} | Erro no servidor: ${response.statusCode}",
      );
    }
  } catch (e) {
    streamController.add(
      "${DateTime.now()} | Erro de conexão: Verifique sua conexão com a internet.",
    );
  }
  return [];
}

Future<void> requestEnergy(String energy) async {
  List<dynamic> characters = await fetchLiveList();

  var matches = characters.where(
    (c) => c["energy"].toString().toLowerCase() == energy.toLowerCase(),
  );

  if (matches.isEmpty) {
    streamController.add(
      "${DateTime.now()} | Não foi encontrado um personagem que usa a energia $energy.",
    );
  } else {
    for (var c in matches) {
      streamController.add(
        "${DateTime.now()} | O personagem ${c["name"]} usa a energia $energy",
      );
    }
  }
}

Future<void> requestAge(int age) async {
  List<dynamic> characters = await fetchLiveList();

  for (var character in characters) {
    if (character["age"] > age) {
      streamController.add(
        "${DateTime.now()} | O personagem ${character["name"]} tem mais de $age de idade, tendo ${character["age"]} anos!",
      );
    } else if (character["age"] == age) {
      streamController.add(
        "${DateTime.now()} | O personagem ${character["name"]} tem $age anos!",
      );
    }
  }
}

Future<void> requestAnime(String anime) async {
  List<dynamic> characters = await fetchLiveList();

  var matches = characters.where(
    (c) => c["anime"].toString().toLowerCase() == anime.toLowerCase(),
  );

  if (matches.isEmpty) {
    streamController.add(
      "${DateTime.now()} | O anime $anime não foi encontrado.",
    );
  } else {
    for (var c in matches) {
      streamController.add(
        "${DateTime.now()} | O personagem ${c["name"]} é do anime $anime",
      );
    }
  }
}

Future<void> deleteCharacter(String name) async {
  List<dynamic> listCharacter = await fetchLiveList();

  int originalLength = listCharacter.length;

  listCharacter.removeWhere(
    (character) =>
        character["name"].toString().toLowerCase() == name.toLowerCase(),
  );

  if (listCharacter.length == originalLength) {
    streamController.add(
      "${DateTime.now()} | Não foi encontrado nenhum personagem com o nome: $name",
    );
    return;
  }

  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String content = encoder.convert(listCharacter);

  Response response = await patch(
    Uri.parse(gistId),
    headers: {"Authorization": "Bearer $githubApiKey"},
    body: json.encode({
      "description": "animes.json",
      "files": {
        "animes.json": {"content": content},
      },
    }),
  );

  if (response.statusCode.toString()[0] == "2") {
    streamController.add(
      "${DateTime.now()} | Personagem $name foi deletado com sucesso!",
    );
  } else {
    streamController.add(
      "${DateTime.now()} | Ocorreu um erro durante a tentativa de deletar o personagem.",
    );
  }
}

Future<void> sendDataAsync(Map<String, dynamic> mapCharacter) async {
  List<dynamic> listCharacter = await fetchLiveList();
  listCharacter.add(mapCharacter);

  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String content = encoder.convert(listCharacter);

  String url = gistId;

  Response response = await patch(
    Uri.parse(url),
    headers: {"Authorization": "Bearer $githubApiKey"},
    body: json.encode({
      "description": "animes.json",
      "public": true,
      "files": {
        "animes.json": {"content": content},
      },
    }),
  );

  if (response.statusCode.toString()[0] == "2") {
    streamController.add("${DateTime.now()} | A adição foi bem-sucedida.");
  } else {
    streamController.add(
      "${DateTime.now()} | Ocorreu um problema durante a tentativa de adicionar um personagem.",
    );
  }
}
