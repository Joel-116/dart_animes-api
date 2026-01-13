import 'package:dart_animes/api_key.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
 sendDataAsync(
    {"nome" : "Yuji Itadori",
    "idade" : "17",
    "anime" : "Jujutsu Kaisen",
    "energia" : "Juryoku"},
  );
}

void requestEnergy(String energia) async {
  String url =
      "https://gist.githubusercontent.com/Joel-116/98da7e34252e27f87f1e875080e62365/raw/db39ce93d5b30c1a17e8f90111e91ccd9069cf70/gistfile1.txt";

  Response response = await get(Uri.parse(url));

  List<dynamic> listResponse = json.decode(response.body);

  for (var personagem in listResponse) {
    if(personagem["energia"] == energia) {
      print("O personagem ${personagem["nome"]} usa a energia $energia");
    }
  }
  
}

Future<void> requestAge(int idade) async {
  String url =
      "https://gist.githubusercontent.com/Joel-116/98da7e34252e27f87f1e875080e62365/raw/db39ce93d5b30c1a17e8f90111e91ccd9069cf70/gistfile1.txt";

  Response response = await get(Uri.parse(url));

  List<dynamic> listResponse = json.decode(response.body);

  for(var personagem in listResponse) {
    if(personagem["idade"] >= idade) {
      print("O personagem ${personagem["nome"]} tem mais de $idade de idade, tendo ${personagem["idade"]} anos!");
    }
  }
}

Future<void> requestAnime(String anime) async {
  String url =
      "https://gist.githubusercontent.com/Joel-116/98da7e34252e27f87f1e875080e62365/raw/db39ce93d5b30c1a17e8f90111e91ccd9069cf70/gistfile1.txt";

  Response response = await get(Uri.parse(url));

  List<dynamic> listResponse = json.decode(response.body);

  for(var personagem in listResponse) {
    if(personagem["anime"] == anime) {
      print("O personagem ${personagem["nome"]} é do anime $anime");
    }
  }
}

Future<List<dynamic>> requestDataAsync() async {
  String url =
      "https://gist.githubusercontent.com/Joel-116/98da7e34252e27f87f1e875080e62365/raw/db39ce93d5b30c1a17e8f90111e91ccd9069cf70/gistfile1.txt";
  Response response = await get(Uri.parse(url));
  return json.decode(response.body);
}


Future<void> sendDataAsync(Map<String, dynamic> mapAccount) async {
  List<dynamic> listAccounts = await requestDataAsync();
  listAccounts.add(mapAccount);
  String content = json.encode(listAccounts);

  String url = "https://api.github.com/gists/98da7e34252e27f87f1e875080e62365";

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