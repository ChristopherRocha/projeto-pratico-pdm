# 📱 Sincronizador Offline-First com Flutter + SQLite + API .NET

## 🚀 O que foi criado

Sistema completo de sincronização offline-first para seu app Flutter com backend .NET:

### Arquitetura
```
┌─────────────────────────────────────────┐
│          Flutter App                    │
├─────────────────────────────────────────┤
│  UI Layer (main.dart)                   │
│       ↓                                 │
│  Repositories (EventRepo, etc)          │
│       ↓                                 │
│  SQLite Database (trabalho_pratico.db)  │
│       ↓                                 │
│  SyncService (monitora internet)        │
│       ↓                                 │
│  ApiService (comunica com API .NET)     │
└─────────────────────────────────────────┘
        ↓ (quando houver internet)
┌─────────────────────────────────────────┐
│   API .NET (localhost:5000)             │
│   GET/POST/PUT/DELETE /api/events       │
│   GET/POST/PUT/DELETE /api/contacts     │
│   GET/POST/PUT/DELETE /api/users        │
└─────────────────────────────────────────┘
```

---

## ⚙️ Configuração

### 1️⃣ Base URL da API

Edite `lib/services/api_config.dart`:

```dart
class ApiConfig {
  // ALTERE PARA SUA API
  static const String apiBaseUrl = 'http://10.0.2.2:5000';
  // ...
}
```

**Valores por plataforma:**
- **Android Emulator**: `http://10.0.2.2:5000` (endereço especial do Android)
- **iOS Simulator**: `http://localhost:5000`
- **Dispositivo físico**: `http://seu_ip_da_maquina:5000`
  - Descubra o IP: `ipconfig` (Windows) ou `ifconfig` (Mac/Linux)

### 2️⃣ Configuração CORS na API .NET

Sua API precisa aceitar requisições do app. No Startup.cs ou Program.cs:

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// ...
app.UseCors("AllowFlutter");
```

---

## 🧪 Testando Localmente

### Passo 1: Rodar a App

```bash
cd trabalho_pratico
flutter pub get
flutter run
```

Você verá logs assim:
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

### Passo 2: Criar Dados (sem precisar da API)

```dart
// Em qualquer tela, você pode fazer:
final eventRepo = EventRepository();
final event = await eventRepo.createEvent(
  title: 'Reunião',
  date: DateTime.now(),
  location: 'Sala 1',
  contactId: 'contact-123',
  description: 'Teste',
);
```

**O dado é salvo no SQLite imediatamente** ✓

Os dados aparecem para o usuário, mesmo sem internet.

### Passo 3: Desabilitar Internet (no emulador)

**Android:**
```bash
adb shell setprop gsm.nitz_time_received 0
# Ou pela interface do emulador: mais opções (⋮) → Extended Controls → 
#  Cellular → Signal strength → None
```

**iOS:**
```bash
# No Simulator: Hardware → Network Link Conditioner → Off
# Ou desligar seu WiFi local
```

### Passo 4: Criar Mais Dados Offline

Sua app continua funcionando sem nenhum erro! ✓

Todos os dados são salvos no SQLite local. Na tela inicial, você verá:
```
📡 Status de Sincronização
🔄 Sincronizando...  (se houver rede)
✓ Pronto              (se tudo estiver ok)
```

### Passo 5: Reabilitar Internet

Quanto a internet volta:
1. `ConnectivityService` detecta
2. `SyncService` é acionado automaticamente
3. Lê todos os dados com `syncStatus='pending'`
4. Envia para sua API .NET via `ApiService`
5. Se sucesso, marca como `syncStatus='synced'`

Você verá logs como:
```
Internet restaurada!
=== INICIANDO SINCRONIZAÇÃO ===
--- Sincronizando Usuários ---
Usuários pendentes: 2
✓ Usuário sincronizado: João
✓ Usuário sincronizado: Maria
--- Sincronizando Contatos ---
...
=== SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO ===
```

### Passo 6: Forçar Sincronização (teste manual)

Na tela da app, clique em **"🔄 Sincronizar Agora"** para testar manualmente.

---

## 📊 Status de Sincronização

Cada item tem um `syncStatus`:
- `pending` - Esperando sincronizar
- `synced` - Já foi para a API
- `error` - Erro durante sincronização (vai tentar novamente)

```dart
final event = await eventRepo.getEvent('id-123');
print(event.syncStatus); // "pending", "synced" ou "error"
```

---

## 🔍 Ver o Banco SQLite

### Android Emulator:
```bash
adb shell
cd /data/data/com.seu.app/databases/
sqlite3 trabalho_pratico.db

# No sqlite3:
.tables                  # Ver todas as tabelas
SELECT * FROM events;    # Ver eventos
.exit
```

### Copiar para seu PC:
```bash
adb pull /data/data/com.seu.app/databases/trabalho_pratico.db ./trabalho_pratico.db
# Depois abra com DB Browser ou outro editor SQLite
```

---

## 🛠️ Troubleshooting

### "Erro ao conectar na API"

1. **Verifique a base URL:**
   - Android Emulator usa `10.0.2.2`, não `localhost`
   - Ajuste em `lib/services/api_config.dart`

2. **Verifique se a API está rodando:**
   ```bash
   curl http://localhost:5000/api/events
   ```

3. **Verifique CORS:**
   - A API deve responder com `Access-Control-Allow-*` headers

### "App trava criando dados"

- Criação fica para o SQLite (instantâneo)
- Se travar, é problema na inicialização do banco
- Veja os logs do `flutter run`

### "Não sincroniza automaticamente"

- Verifique se `ConnectivityService.init()` foi chamado no `main()`
- Veja os logs se a internet foi detectada
- Clique em "Sincronizar Agora" para testar manualmente

---

## 📝 Exemplo Prático de Uso

```dart
import 'package:trabalho_pratico/repositories/index.dart';

void criarEventoExemplo() async {
  // Criar repositório
  final eventRepo = EventRepository();
  
  // Criar evento
  final event = await eventRepo.createEvent(
    title: 'Reunião Importante',
    date: DateTime(2026, 4, 15, 14, 30),
    location: 'Sala de Conferência A',
    contactId: 'contact-uuid-123',
    description: 'Discussão sobre roadmap Q2',
    message: 'Trazer documentação atualizada',
  );
  
  print('✓ Evento criado: ${event.title}');
  print('  Status: ${event.syncStatus}'); // "pending"
  
  // Quando internet volta:
  // SyncService sincroniza automaticamente para a API .NET
  // E marca como syncStatus = 'synced'
}
```

---

## 🎯 Fluxo Offline-First Resumido

```
[Usuário abre app]
    ↓
[App tira foto/cria evento]
    ↓
[Salva no SQLite (instantâneo)]
    ↓
[Tela mostra o dado imediatamente] ✓ Sem travar!
    ↓
[App detecta internet?]
    ├─ SIM → Sincroniza com API .NET
    │         └─ Marca como "synced" se sucesso
    └─ NÃO → Continua offline, tenta depois
```

---

## 📌 Próximas Melhorias Possíveis

- [ ] Tratamento de conflitos (quando mesmo item é editado offline e online)
- [ ] Retry automático com exponential backoff
- [ ] Widget mostrando progresso de sincronização
- [ ] Pull para atualizar dados do servidor
- [ ] Cache de dados do servidor
- [ ] Notificações quando sincronizar
- [ ] Migração de schema do banco

---

## 🤝 Estrutura de Arquivos

```
lib/
├── main.dart                    # Inicializa tudo
├── models/
│   ├── user.dart
│   ├── contact.dart
│   ├── event.dart
│   └── index.dart              # Exports
├── database/
│   ├── database_helper.dart     # SQLite
│   └── index.dart
├── repositories/
│   ├── user_repository.dart
│   ├── contact_repository.dart
│   ├── event_repository.dart
│   └── index.dart
├── services/
│   ├── api_config.dart          # Configuração
│   ├── api_service.dart         # HTTP com Dio
│   ├── connectivity_service.dart # Internet
│   ├── sync_service.dart        # Orquestrador
│   └── index.dart
└── example_usage.dart           # Como usar
```

---

**Boa sorte com o trabalho prático! 🚀**
