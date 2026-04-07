# 📚 Índice Completo da Documentação

Bem-vindo! Use este índice para navegar pela documentação do sincronizador offline-first.

---

## 🚀 Comece Aqui

### 1. **RESUMO_SINCRONIZADOR.md** 
   Leia primeiro! Visão geral do que foi criado.
   - ⏱️ 5 minutos
   - 📊 Arquitetura visual
   - ✅ Checklist rápido

### 2. **CHECKLIST_SETUP.md**
   Configuração passo a passo.
   - ⏱️ 10 minutos
   - 🔧 Setup da API .NET
   - 🐛 Troubleshooting

### 3. **TESTE_PRATICO.md**
   Teste tudo na prática.
   - ⏱️ 20 minutos
   - ✅ Testes sem internet
   - 🔍 Validação do banco

---

## 📖 Documentação Detalhada

### **SINCRONIZADOR_README.md** (Guia Principal)
Guia completo de uso e arquitetura.

**Tópicos:**
- ⚙️ Configuração
- 🧪 Testes localmente
- 🌐 Status de sincronização
- 🛠️ Troubleshooting
- 📌 Próximas melhorias

**Quando ler:** Depois de começar, para entender detalhes.

---

### **API_RESPONSE_FORMAT.md** (API .NET)
Formato esperado dos endpoints da API.

**Tópicos:**
- 📦 JSON de User, Contact, Event
- 🔄 Implementação em C#
- ✅ Checklist para API
- 🧪 Testes com cURL/Postman
- 🐛 Troubleshooting de API

**Quando ler:** Se sua API tem campos diferentes.

---

### **lib/api_response_mapper.dart** (Customização)
Mapeador para APIs com formato diferente.

**Quando usar:** Se sua API não retorna exatamente como esperado.

**Exemplo:**
```dart
// Sua API usa "eventName" em vez de "title"?
// Customize aqui!
```

---

## 💻 Código

### **lib/models/** - Modelos de Dados
```
user.dart       ← Usuário (campos de sync inclusos)
contact.dart    ← Contato (com soft delete)
event.dart      ← Evento
```

**Todos têm:**
- `toMap()` - salvar no SQLite
- `fromMap()` - ler do SQLite
- `toJson()` - enviar à API
- `copyWith()` - atualizar campos

---

### **lib/database/** - Banco de Dados
```
database_helper.dart ← SQLite singleton com 3 tabelas
```

**Funcionalidades:**
- CRUD completo
- Queries de sincronização
- Soft delete support

---

### **lib/repositories/** - Camada de Negócio
```
user_repository.dart     ← CRUD de usuários
contact_repository.dart  ← CRUD de contatos
event_repository.dart    ← CRUD de eventos
```

**Cada um oferece:**
- `createXXX()`
- `getXXX()`
- `getAllXXX()`
- `updateXXX()`
- `deleteXXX()` - soft delete
- `getPendingXXX()` - para sincronização

---

### **lib/services/** - Comunicação e Conectividade
```
api_config.dart              ← ⚠️ ALTERE A BASE URL AQUI
api_service.dart             ← HTTP client (Dio)
connectivity_service.dart    ← Monitora internet
sync_service.dart            ← Orquestra sincronização
```

**Fluxo:**
```
ConnectivityService (detecta internet)
        ↓
SyncService (é acionado)
        ↓
ApiService (envia para API)
```

---

### **lib/main.dart** - Inicializa Tudo
```dart
main() {
  // 1. Inicializa banco de dados
  // 2. Inicializa conectividade
  // 3. Inicializa API
  // 4. Inicializa sincronizador
}
```

**Tela inicial com:**
- ✓ Contador de teste
- 📡 Status de sincronização
- 🔄 Botão de sincronizar manual

---

## 🧪 Testes e Exemplos

### **lib/example_usage.dart**
Exemplos de como usar cada repositório.

```dart
// Exemplo: criar evento
final event = await eventRepo.createEvent(
  title: 'Reunião',
  date: DateTime.now(),
  location: 'Sala 1',
  contactId: 'contact-123',
  description: 'Teste',
);
```

---

### **lib/test_sync.dart**
Script de teste automático com 10 testes.

```bash
# Usar em uma tela para testar:
await testSyncSystem();
```

Testa:
- 1. Criar usuário
- 2. Obter usuário
- 3. Criar contato
- 4. Criar evento
- 5. Atualizar evento
- 6. Listar eventos
- 7. Eventos por contato
- 8. Pendentes
- 9. Soft delete
- 10. Marcar como synced

---

## 📋 Configuração Rápida

### 1️⃣ Editar Base URL
**Arquivo:** `lib/services/api_config.dart`

```dart
static const String apiBaseUrl = 'http://10.0.2.2:5000';
```

✅ Pronto!

### 2️⃣ Verificar API .NET
- [ ] API rodando em `localhost:5000`
- [ ] Endpoints criados (`/api/events`, etc)
- [ ] CORS habilitado

### 3️⃣ Rodar App
```bash
flutter run
```

✅ Pronto!

---

## 🔀 Decisão: Por Onde Começar?

**Novo no projeto?**
→ Leia `RESUMO_SINCRONIZADOR.md` (5 min)
→ Depois `CHECKLIST_SETUP.md` (10 min)

**Quer clonar e rodar?**
→ `TESTE_PRATICO.md` (20 min)

**Tem problemas?**
→ `SINCRONIZADOR_README.md` → Troubleshooting
→ ou `API_RESPONSE_FORMAT.md` se for problema de API

**Quer customizar para sua API?**
→ `API_RESPONSE_FORMAT.md`
→ depois `lib/api_response_mapper.dart`

---

## 📊 Estrutura Visual

```
projeto-pratico/
├── 📚 DOCUMENTAÇÃO
│   ├── RESUMO_SINCRONIZADOR.md      ← Comece aqui!
│   ├── CHECKLIST_SETUP.md           ← Depois aqui
│   ├── TESTE_PRATICO.md             ← Teste tudo
│   ├── SINCRONIZADOR_README.md      ← Guia principal
│   ├── API_RESPONSE_FORMAT.md       ← Para API
│   └── INDICE.md                    ← Você está aqui
│
├── 💻 lib/
│   ├── main.dart                    ← Entrada
│   ├── models/
│   │   ├── user.dart
│   │   ├── contact.dart
│   │   └── event.dart
│   ├── database/
│   │   └── database_helper.dart
│   ├── repositories/
│   │   ├── user_repository.dart
│   │   ├── contact_repository.dart
│   │   └── event_repository.dart
│   ├── services/
│   │   ├── api_config.dart          ← ⚠️ ALTERE
│   │   ├── api_service.dart
│   │   ├── connectivity_service.dart
│   │   └── sync_service.dart
│   ├── example_usage.dart
│   ├── test_sync.dart
│   └── api_response_mapper.dart
│
└── 📦 pubspec.yaml                  ← Dependências
```

---

## ⚡ Quick Reference

| Ação | Como Fazer |
|------|-----------|
| Criar evento | `await eventRepo.createEvent(...)` |
| Listar eventos | `await eventRepo.getAllEvents()` |
| Atualizar evento | `await eventRepo.updateEvent(event)` |
| Deletar evento | `await eventRepo.deleteEvent(id)` |
| Ver pendentes | `await eventRepo.getPendingEvents()` |
| Forçar sync | `await syncService.forceSync()` |
| Alterar base URL | Edite `api_config.dart` |
| Ver banco SQLite | Use DB Browser ou `adb pull` |

---

## 🎯 Checklist de Implementação

- [ ] Ler `RESUMO_SINCRONIZADOR.md`
- [ ] Editar base URL em `api_config.dart`
- [ ] Configurar CORS na API .NET
- [ ] Rodar `flutter run`
- [ ] Ver logs de inicialização
- [ ] Testar offline (desconectar internet)
- [ ] Testar sincronização (conectar internet)
- [ ] Validar banco SQLite
- [ ] Criar UI para eventos
- [ ] Apresentar ao professor

---

## 🤝 Suporte

**Se der problema:**
1. Veja `SINCRONIZADOR_README.md` → Troubleshooting
2. Veja `API_RESPONSE_FORMAT.md` → Errors
3. Rodar com verbose: `flutter run -v`
4. Procure a mensagem de erro na documentação

---

## 📞 Contato

Se tiver dúvida ou erro:
1. Leia a documentação (provavelmente está lá)
2. Veja os logs do `flutter run -v`
3. Teste cada parte isoladamente
4. Se for erro de API, teste endpoints com curl

---

**Boa sorte com o trabalho prático! 🚀**

*Última atualização: 2026-04-07*
