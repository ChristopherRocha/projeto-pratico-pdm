# 📡 Estrutura de Resposta Esperada da API .NET

Seus endpoints .NET devem retornar/aceitar dados neste formato:

---

## 📦 User

### POST/PUT `/api/users`
**Request:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "João Silva",
  "email": "joao@example.com"
}
```

**Response (200 OK):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "João Silva",
  "email": "joao@example.com"
}
```

### GET `/api/users`
**Response (200 OK):**
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "João Silva",
    "email": "joao@example.com"
  },
  {
    "id": "660e8400-e29b-41d4-a716-446655440001",
    "name": "Maria Santos",
    "email": "maria@example.com"
  }
]
```

### DELETE `/api/users/{id}`
**Response (204 No Content)** ou **(200 OK)**

---

## 👤 Contact

### POST/PUT `/api/contacts`
**Request:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440100",
  "name": "Maria Santos",
  "email": "maria@example.com",
  "phoneNumber": "11999999999",
  "userId": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response (200 OK):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440100",
  "name": "Maria Santos",
  "email": "maria@example.com",
  "phoneNumber": "11999999999",
  "userId": "550e8400-e29b-41d4-a716-446655440000"
}
```

### GET `/api/contacts`
**Response (200 OK):**
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440100",
    "name": "Maria Santos",
    "email": "maria@example.com",
    "phoneNumber": "11999999999",
    "userId": "550e8400-e29b-41d4-a716-446655440000"
  }
]
```

### DELETE `/api/contacts/{id}`
**Response (204 No Content)** ou **(200 OK)**

---

## 📅 Event

### POST/PUT `/api/events`
**Request:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440200",
  "title": "Reunião com Cliente",
  "date": "2026-04-15T14:30:00.000Z",
  "location": "Sala de Conferência A",
  "contactId": "550e8400-e29b-41d4-a716-446655440100",
  "description": "Discussão sobre novo projeto",
  "message": "Trazer documentação atualizada"
}
```

**Response (200 OK):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440200",
  "title": "Reunião com Cliente",
  "date": "2026-04-15T14:30:00.000Z",
  "location": "Sala de Conferência A",
  "contactId": "550e8400-e29b-41d4-a716-446655440100",
  "description": "Discussão sobre novo projeto",
  "message": "Trazer documentação atualizada"
}
```

### GET `/api/events`
**Response (200 OK):**
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440200",
    "title": "Reunião com Cliente",
    "date": "2026-04-15T14:30:00.000Z",
    "location": "Sala de Conferência A",
    "contactId": "550e8400-e29b-41d4-a716-446655440100",
    "description": "Discussão sobre novo projeto",
    "message": "Trazer documentação atualizada"
  }
]
```

### DELETE `/api/events/{id}`
**Response (204 No Content)** ou **(200 OK)**

---

## ⚙️ Implementação Recomendada em .NET

### Program.cs
```csharp
var builder = WebApplicationBuilder.CreateBuilder(args);

// Adicionar CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Controllers
builder.Services.AddControllers();

var app = builder.Build();

// Usar CORS ANTES dos endpoints
app.UseCors("AllowFlutter");
app.MapControllers();

app.Run("http://localhost:5000");
```

### EventsController.cs
```csharp
[ApiController]
[Route("api/[controller]")]
public class EventsController : ControllerBase
{
    private List<Event> events = new(); // Seu banco

    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(events);
    }

    [HttpPost]
    public IActionResult Create([FromBody] Event @event)
    {
        events.Add(@event);
        return Ok(@event);
    }

    [HttpPut("{id}")]
    public IActionResult Update(string id, [FromBody] Event @event)
    {
        var existing = events.FirstOrDefault(e => e.Id == id);
        if (existing == null) return NotFound();
        
        existing.Title = @event.Title;
        existing.Date = @event.Date;
        // ... outros campos
        
        return Ok(@event);
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(string id)
    {
        events.RemoveAll(e => e.Id == id);
        return NoContent();
    }
}
```

---

## ✅ Checklist para API

- [ ] Endpoint GET `/api/events` retorna lista de objetos
- [ ] Endpoint POST `/api/events` cria novo (retorna 200)
- [ ] Endpoint PUT `/api/events/{id}` atualiza (retorna 200)
- [ ] Endpoint DELETE `/api/events/{id}` deleta (retorna 204 ou 200)
- [ ] Mesmos endpoints para `/api/contacts` e `/api/users`
- [ ] CORS habilitado (`Access-Control-Allow-*` headers)
- [ ] Campos JSON exatamente como acima
- [ ] Dates em formato ISO 8601 (exemplo: `2026-04-15T14:30:00Z`)
- [ ] IDs são strings (UUIDs)

---

## 🧪 Testando Endpoints Manualmente

### Com cURL (Windows)
```bash
# GET
curl http://localhost:5000/api/events -v

# POST
curl -X POST http://localhost:5000/api/events ^
  -H "Content-Type: application/json" ^
  -d "{\"id\":\"test\",\"title\":\"Teste\",\"date\":\"2026-04-15T14:30:00Z\",\"location\":\"Local\",\"contactId\":\"123\",\"description\":\"Desc\",\"message\":null}"

# PUT
curl -X PUT http://localhost:5000/api/events/test ^
  -H "Content-Type: application/json" ^
  -d "{\"title\":\"Atualizado\"}"

# DELETE
curl -X DELETE http://localhost:5000/api/events/test -v
```

### Com Postman
1. Crie collection com 3 pastas (Events, Contacts, Users)
2. Cada pasta com GET, POST, PUT, DELETE
3. Teste cada endpoint
4. Exporte ambiente com `{{baseUrl}}` = `http://localhost:5000`

---

## 🐛 Troubleshooting

### "CORS error"
```
❌ Access to XMLHttpRequest blocked by CORS policy
```
**Solução:** Adicione `app.UseCors("AllowFlutter");` antes dos controllers

### "404 Not Found"
```
❌ The requested resource cannot be found
```
**Solução:** Verifique se endpoints estão exatamente `/api/events`, `/api/contacts`, `/api/users`

### "400 Bad Request"
```
❌ The request could not be understood by the server
```
**Solução:** Verifique JSON (tipos, aspas, campos obrigatórios)

### "500 Internal Server Error"
**Solução:** Veja logs do .NET (debug)

---

## 📝 Resposta de Erro (Opcional)

Se quiser retornar erros estruturados:

```json
{
  "error": "Contato não encontrado",
  "statusCode": 404
}
```

App já trata como erro e coloca em status `error` no SQLite.

---

**Agora é só conectar a API e sincronizar! 🚀**
