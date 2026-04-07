# 🧪 Teste Prático Completo - Passo a Passo

## O que você vai fazer

Vamos testar o sistema offline-first:
1. ✅ Criar dados SEM internet
2. ✅ App não vai travar
3. ✅ Ligar internet
4. ✅ Ver sincronização automática

---

## Prepare seu PC (5 minutos)

### 1. API .NET rodando
```bash
# Terminal 1: Na pasta da API .NET
dotnet run --urls "http://localhost:5000"
```

Se vir `Now listening on: http://localhost:5000` ✓

### 2. Editar base URL
**Abra:** `lib/services/api_config.dart`

```dart
class ApiConfig {
  // ALTERE AQUI
  static const String apiBaseUrl = 'http://10.0.2.2:5000'; // Android
  // static const String apiBaseUrl = 'http://localhost:5000'; // iOS
  // static const String apiBaseUrl = 'http://192.168.1.XX:5000'; // Seu PC (descubra com ipconfig)
}
```

### 3. Rodar app
```bash
# Terminal 2: Na pasta do Flutter
flutter run
```

Você deve ver:
```
✓ Banco de dados pronto
✓ Conectividade pronta
✓ API pronta
✓ Sincronizador pronto
```

---

## Teste 1: Criar Dados (COM internet)

**No Android Studio ou VS Code:**

1. Abra o console do Flutter (está rodando `flutter run`)

2. Importe as classes:
```dart
import 'package:trabalho_pratico/repositories/index.dart';
```

3. Cole isto no console do Flutter:
```dart
// Teste rápido
await (await package:trabalho_pratico.repositories.EventRepository().createEvent(
  title: 'Teste 1',
  date: DateTime.now().add(Duration(days: 1)),
  location: 'Local',
  contactId: 'abc',
  description: 'Teste',
)).then((e) => print('✓ Evento criado: ${e.title}'));
```

Ou melhor ainda, crie um botão na tela para testar (veja `main.dart`).

**Esperado:**
```
┌─────────────────────┐
│ Evento criado: Teste 1
│ Status: pending
│ Sincronizando... ✓
└─────────────────────┘
```

**Nos logs, você deve ver:**
```
--- Sincronizando Eventos ---
Eventos pendentes: 1
✓ Evento sincronizado: Teste 1
```

---

## Teste 2: Criar Dados (SEM internet)

### 2.1. Desconectar
**Android Emulator:**
- Clique em `...` (mais)
- Extended Controls
- Cellular → Signal strength → Off

**iOS Simulator:**
- Siri/Spotlight busque "Network Link Conditioner"
- Ou desconecte WiFi do seu PC

**Seu PC:**
```bash
# Windows
ipconfig /all | findstr "Status"

# Depois desconecte internet
```

### 2.2. Criar evento no app
- Botão de adicionar na tela
- Preencher campos
- Salvar

**Esperado:**
```
✓ Evento criado: Teste Offline
✓ Salvo no SQLite
Status: pending (não sincroniza)
App não trava! ✓
```

### 2.3. Criar mais 2 eventos
Crie 3-4 eventos SEM internet

**SIM, todos vão salvar sem problema!**

**Nos logs:**
```
Evento criado localmente
Pendente de sincronização
```

---

## Teste 3: Reconectar Internet

### 3.1. Ativar internet
**Android Emulator:**
- Cellular → Signal strength → back to Full

**iOS Simulator:**
- Reconectar WiFi

**Seu PC:**
- Reconectar

### 3.2. Ver sincronização automática
Nos logs do Flutter, você deve ver:
```
Internet restaurada!
=== INICIANDO SINCRONIZAÇÃO ===
--- Sincronizando Eventos ---
Eventos pendentes: 4
✓ Evento sincronizado: Teste Offline
✓ Evento sincronizado: Teste Offline 2
✓ Evento sincronizado: Teste Offline 3
✓ Evento sincronizado: Teste Offline 4
=== SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO ===
```

---

## Teste 4: Ver Dados no Banco SQLite

### 4.1. Acessar banco do emulador
```bash
adb pull /data/data/com.seu.app/databases/trabalho_pratico.db ./
```

### 4.2. Abrir com DB Browser
1. Baixe [DB Browser for SQLite](https://sqlitebrowser.org/)
2. Abra `trabalho_pratico.db`
3. Clique em "Browse Data"
4. Selecione tabela `events`

**Você verá:**
```
┌────┬──────────┬──────────┬────────┬─────────────┬────────┐
│ id │  title   │   date   │ isDirty│ syncStatus  │ ...    │
├────┼──────────┼──────────┼────────┼─────────────┼────────┤
│ 1  │ Teste 1  │ 2026-... │   0    │   synced    │ ...    │
│ 2  │ Offline  │ 2026-... │   0    │   synced    │ ...    │
└────┴──────────┴──────────┴────────┴─────────────┴────────┘
```

✓ Todos têm `syncStatus = 'synced'` = conseguiu sincronizar!

---

## Teste 5: Forçar Sincronização

Na tela do app, tem um botão **"🔄 Sincronizar Agora"**

Clique nele e veja os logs:
```
🔄 Sincronização forçada acionada pelo usuário
=== INICIANDO SINCRONIZAÇÃO ===
(nem deve sincronizar nada, pois já tudo está syncado)
=== SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO ===
```

---

## Teste 6: Soft Delete

### 6.1. Deletar um evento
```dart
final eventRepo = EventRepository();
await eventRepo.deleteEvent('id-do-evento');
```

### 6.2. Ver no banco
```bash
sqlite3 trabalho_pratico.db
SELECT * FROM events WHERE isDeleted = 1;
```

**Esperado:**
- Evento marca `isDeleted = 1` (mas não remove fisicamente)
- `syncStatus = 'pending'` (pronto para sincronizar)

### 6.3. Conectar internet
- Sincroniza o delete para a API
- API remove o evento
- App marca como `syncStatus = 'synced'`

---

## Checklist de Sucesso

- [ ] App rodou sem erros
- [ ] Criou evento COM internet → sincronizou automaticamente
- [ ] Criou eventos SEM internet → salvou no SQLite
- [ ] Ligou internet → sincronizou todos os eventos
- [ ] Banco SQLite criado corretamente
- [ ] Soft delete funcionando
- [ ] Log de sincronização mostrou sucesso

---

## Se algo der errado

### "Erro: CORS error"
```
❌ Access to XMLHttpRequest from origin 'null'
```
**Solução:**
- Verifique `Program.cs` da API
- Confirme `app.UseCors("AllowFlutter");`
- Reinicie API .NET

### "Erro: Cannot GET /api/events"
```
❌ POST http://10.0.2.2:5000/api/events 404
```
**Solução:**
- Confirme endpoints em `/api/events`, `/api/contacts`, `/api/users`
- Teste com `curl` direto

```bash
curl http://localhost:5000/api/events
```

### "Erro: Banco não criou"
```
❌ Failed to open database
```
**Solução:**
```bash
flutter clean
flutter pub get
flutter run --verbose
```

### "Erro: não sincroniza automaticamente"
- Verifique internet (adb ou simulator)
- Clique "Sincronizar Agora" manualmente
- Veja logs com `flutter run -v`

---

## Próximo: Criar UI

Agora que tudo funciona offline-first:

1. Criar tela de listagem de eventos
2. Criar tela de adicionar evento (com formulário)
3. Editar evento
4. Deletar evento
5. Filtrar por data/contato
6. Pesquisar

Você já tem toda a camada de dados pronta! ✓

---

## Demo para o Professor

**Cenário 1: Com internet**
1. App aberto
2. Criar evento
3. Mostrar que sincronizou automaticamente
4. Abrir API no browser, confirmar que criou

**Cenário 2: Sem internet**
1. Desconectar WiFi/internet
2. Criar 5 eventos
3. Mostrar os 5 no SQLite
4. Reconectar internet
5. Mostrar sincronização automática
6. Confirmar que todos foram para a API

**Conclusão:**
"O app funciona perfeitamente offline! Dados salvam no SQLite e sincronizam quando internet volta."

---

**Bora testar! 🚀**
