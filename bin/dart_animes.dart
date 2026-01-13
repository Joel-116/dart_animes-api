import 'package:dart_animes/api_key.dart';
import 'package:http/http.dart';
import 'dart:convert';

const String gistRawUrl =
    "https://gist.githubusercontent.com/Joel-116/98da7e34252e27f87f1e875080e62365/raw/93f79b6599568c076e113e5e9ad91f4768fb7460/animes.json";
const String gistId =
    "https://api.github.com/gists/98da7e34252e27f87f1e875080e62365";

void main() {}

Future<List<dynamic>> fetchLiveList() async {
  Response response = await get(
    Uri.parse(gistId),
    headers: {"Authorization": "Bearer $githubApiKey"},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> gistData = json.decode(response.body);
    String content = gistData['files']['animes.json']['content'];
    return json.decode(content);
  }
  return [];
}

void requestEnergy(String energy) async {
  List<dynamic> characters = await fetchLiveList();
  for (var character in characters) {
    if (character["energy"] == energy) {
      print("O personagem ${character["name"]} usa a energia $energy");
    }
  }
}

Future<void> requestAge(int age) async {
  List<dynamic> characters = await fetchLiveList();

  for (var character in characters) {
    if (character["age"] > age) {
      print(
        "O personagem ${character["name"]} tem mais de $age de idade, tendo ${character["age"]} anos!",
      );
    } else if (character["age"] == age) {
      print("O personagem ${character["name"]} tem $age anos!");
    }
  }
}

Future<void> requestAnime(String anime) async {
  List<dynamic> characters = await fetchLiveList();

  for (var character in characters) {
    if (character["anime"] == anime) {
      print("O personagem ${character["name"]} é do anime $anime");
    }
  }
}

Future<void> deleteCharacter(String name) async {
  List<dynamic> listCharacter = await fetchLiveList();
  
  int originalLength = listCharacter.length;

  listCharacter.removeWhere((character) => 
    character["name"].toString().toLowerCase() == name.toLowerCase());

  if (listCharacter.length == originalLength) {
    print("Nenhum personagem encontrado com o nome: $name");
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

  if (response.statusCode == 200) {
    print("Personagem '$name' removido com sucesso!");
  } else {
    print("Erro ao deletar: ${response.statusCode}");
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

  print(response.statusCode);

  switch (response.statusCode) {
    case 200:
      // A requisição foi bem-sucedida, processa os dados
      print('Dados recebidos: ${response.body}');
      break;
    case 201:
      // Recurso criado com sucesso
      print('Recurso criado com sucesso.');
      break;
    case 204:
      // Nenhum conteúdo retornado
      print('Operação concluída, mas sem dados para exibir.');
      break;
    case 400:
      // Requisição inválida
      print('Erro na requisição: ${response.reasonPhrase}');
      break;
    case 401:
      // Não autorizado
      print('Acesso não autorizado. Verifique suas credenciais.');
      break;
    case 403:
      // Permissão
      print("Você não tem a permissão necessária para editar este gist.");
      break;
    case 404:
      // Recurso não encontrado
      print('Recurso não encontrado.');
      break;
    case 500:
      // Erro interno no servidor
      print('Erro no servidor. Tente novamente mais tarde.');
      break;
    default:
      // Outros códigos de erro
      print('Erro desconhecido: ${response.statusCode}');
  }
}