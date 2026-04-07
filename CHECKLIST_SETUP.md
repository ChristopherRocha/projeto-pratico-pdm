# ✅ Checklist de Setup - Sincronizador Offline-First

## Antes de Testar

- [ ] **Flutter instalado e atualizado**
  ```bash
  flutter --version
  flutter upgrade
  ```

- [ ] **Dependências instaladas**
  ```bash
  cd trabalho_pratico
  flutter pub get
  ```

---

## Configuração da API .NET

- [ ] **API .NET rodando localmente**
  ```bash
  dotnet run --urls "http://localhost:5000"
  # Ou sua porta configurada
  ```

- [ ] **Base URL correta em `lib/services/api_config.dart`**
  ```dart
  static const String apiBaseUrl = 'http://10.0.2.2:5000'; // Android
  ```

- [ ] **CORS configurado na API .NET**
  ```csharp
  // Program.cs
  app.UseCors("AllowFlutter");
  ```

- [ ] **Endpoints esperados na API:**
  ```
  GET    /api/events
  POST   /api/events
  PUT    /api/events/{id}
  DELETE /api/events/{id}
  
  GET    /api/contacts
  POST   /api/contacts
  PUT    /api/contacts/{id}
  DELETE /api/contacts/{id}
  
  GET    /api/users
  POST   /api/users
  PUT    /api/users/{id}
  DELETE /api/users/{id}
  ```

---

## Teste Básico

- [ ] **Rodar app**
  ```bash
  flutter run
  ```

- [ ] **Ver logs de inicialização**
  ```
  🔧 Inicializando banco de dados...
  ✓ Banco de dados pronto
  🔧 Inicializando monitoramento de conectividade...
  ✓ Conectividade pronta
  🔧 Inicializando serviço de API...
  ✓ API pronta
  🔧 Inicializando sincronizador...
  ✓ Sincronizador pronto
  ```

- [ ] **Testar criação de dados** (sem internet)
  - Criar evento/contato via repositório
  - Dado deve aparecer imediatamente ✓

- [ ] **Testar sincronização**
  - Ativar internet
  - Clicar "🔄 Sincronizar Agora"
  - Ver logs de sincronização com sucesso ✓

---

## Debug

### Se não sincronizar:

- [ ] **Verificar base URL**
  - Android Emulator: `http://10.0.2.2:5000` (não localhost!)
  - iOS Simulator: `http://localhost:5000`
  - Dispositivo real: `http://seu_ip:5000`

- [ ] **Testar conexão com API manualmente**
  ```bash
  # Seu PC
  curl http://localhost:5000/api/events
  
  # Android Emulator
  adb shell curl http://10.0.2.2:5000/api/events
  ```

- [ ] **Verificar logs do Flutter**
  ```bash
  flutter run -v  # verbose mode
  ```

- [ ] **Verificar CORS na API**
  - Response deve ter headers:
    ```
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE
    ```

### Se SQLite não inicializar:

- [ ] **Verificar permissões**
  - Android: `READ_EXTERNAL_STORAGE` e `WRITE_EXTERNAL_STORAGE`

- [ ] **Limpar app e cache**
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

---

## Fluxo de Teste Completo

### 1. Setup Inicial
```bash
flutter pub get
flutter run
```

### 2. Criar Dados (COM internet)
- Criar evento/contato via botões na app
- Ver sincronização automática nos logs

### 3. Desabilitar Internet
- **Android**: `adb shell setprop gsm.nitz_time_received 0`
- **iOS**: Desligar WiFi
- **Windows**: Desconectar rede

### 4. Criar Mais Dados (SEM internet)
- Criar mais eventos/contatos
- App não deve travar ✓
- Dados salvos no SQLite ✓

### 5. Reabilitar Internet
- **Android**: `adb shell setprop gsm.nitz_time_received 1`
- **iOS**: Ligar WiFi
- **Windows**: Reconectar rede

### 6. Verificar Sincronização
- Ver logs de sincronização
- Confirmar que todos os dados foram para a API ✓

---

## Estrutura Verificada

- [ ] `lib/models/` - User, Contact, Event
- [ ] `lib/database/` - DatabaseHelper
- [ ] `lib/repositories/` - EventRepo, ContactRepo, UserRepo
- [ ] `lib/services/` - ApiService, ConnectivityService, SyncService
- [ ] `lib/main.dart` - Inicializa tudo
- [ ] `pubspec.yaml` - Dependências (sqflite, dio, connectivity_plus, path, uuid)

---

## Comandos Úteis

```bash
# Limpar tudo
flutter clean

# Reinstalar dependências
flutter pub get

# Rodar em verbose (mostra logs detalhados)
flutter run -v

# Rodar em release
flutter run --release

# Ver erros de análise
flutter analyze

# Formatar código
dart format lib/

# Acessar SQLite do emulador Android
adb pull /data/data/com.seu.app/databases/trabalho_pratico.db ./
sqlite3 trabalho_pratico.db
```

---

## Próximas Melhorias

Após validar que tudo funciona:

- [ ] Criar UI completa para gerenciar eventos/contatos
- [ ] Adicionar busca e filtros
- [ ] Implementar tratamento de conflitos
- [ ] Adicionar notificações de sincronização
- [ ] Criar widget de status em tempo real
- [ ] Implementar retry automático com exponential backoff
- [ ] Adicionar testes unitários

---

**Quando tudo funcionar, seu app está ready para produção offline-first! 🚀**
