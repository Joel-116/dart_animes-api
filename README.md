## 🚀 Como Rodar o Projeto

Por favor, siga os passos abaixo:

1. **Configuração da Chave de API:**
   - No GitHub, gere um **Personal Access Token (classic)**.
   - Certifique-se de marcar a permissão **"gist"**.
   - No seu projeto local, crie o arquivo `lib/api_key.dart` (este arquivo já está no `.gitignore`).
   - Adicione o seguinte código ao arquivo:
     ```dart
     const String githubApiKey = "SUA_CHAVE_AQUI";
     ```

2. **Preparação do Gist:**
   - Acesse os dados iniciais [neste link](https://gist.githubusercontent.com/Joel-116/98da7e34252e27f87f1e875080e62365/raw/db39ce93d5b30c1a17e8f90111e91ccd9069cf70/gistfile1.txt) e copie o conteúdo JSON.
   - Vá para [gist.github.com](https://gist.github.com/) e cole o JSON.
   - Clique na seta ao lado de "Create secret gist" e selecione **"Create public gist"**.

3. **Vínculo com o Código:**
   - Após criar seu Gist, abra a página dele e clique em **"Raw"**, e copie a URL par a variável `GistRawUrl`.
   - Para a variável `GistID`, pegue a URL do seu Gist e faça a seguinte alteração:
     De: https://github.com/usuario/ID_DO_GIST
     Para: https://api.github.com/gists/ID_DO_GIST