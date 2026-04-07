import 'repositories/index.dart';

/// Exemplo de uso do sistema offline-first
/// Este arquivo demonstra como usar os repositórios para criar, atualizar e sincronizar dados

void exemploUso() async {
  // ============ EXEMPLO 1: Criar um usuário ============
  final userRepo = UserRepository();
  
  final user = await userRepo.createUser(
    name: 'João Silva',
    email: 'joao@example.com',
  );
  print('Usuário criado: ${user.name} (${user.syncStatus})');
  // Output: Usuário criado: João Silva (pending) <- Pronto para sincronizar

  // ============ EXEMPLO 2: Criar um contato ============
  final contactRepo = ContactRepository();
  
  final contact = await contactRepo.createContact(
    name: 'Maria Santos',
    email: 'maria@example.com',
    phoneNumber: '1199999999',
    userId: user.id,
  );
  print('Contato criado: ${contact.name} (${contact.syncStatus})');
  // Output: Contato criado: Maria Santos (pending) <- Pronto para sincronizar

  // ============ EXEMPLO 3: Criar um evento ============
  final eventRepo = EventRepository();
  
  final event = await eventRepo.createEvent(
    title: 'Reunião com Cliente',
    date: DateTime.now().add(Duration(days: 1)),
    location: 'Sala de Conferência',
    contactId: contact.id,
    description: 'Discussão sobre novo projeto',
    message: 'Não se esquecer de trazer a documentação',
  );
  print('Evento criado: ${event.title} (${event.syncStatus})');
  // Output: Evento criado: Reunião com Cliente (pending) <- Pronto para sincronizar

  // ============ EXEMPLO 4: Listar eventos criados localmente ============
  final eventos = await eventRepo.getAllEvents();
  print('Total de eventos locais: ${eventos.length}');

  // ============ EXEMPLO 5: Atualizar um evento ============
  final eventoAtualizado = event.copyWith(
    title: 'Reunião com Cliente - CONFIRMADA',
    description: 'Discussão sobre novo projeto - com cliente principal',
  );
  await eventRepo.updateEvent(eventoAtualizado);
  print('Evento atualizado e marcado como pending');

  // ============ EXEMPLO 6: Obter eventos pendentes de sincronização ============
  final pendentes = await eventRepo.getPendingEvents();
  print('Eventos pendentes de sincronização: ${pendentes.length}');
  for (var e in pendentes) {
    print('  - ${e.title} (${e.syncStatus})');
  }

  // ============ EXEMPLO 7: Deletar um evento (soft delete) ============
  await eventRepo.deleteEvent(event.id);
  final eventoVerificacao = await eventRepo.getEvent(event.id);
  print('Evento deletado (soft delete): isDeleted=${eventoVerificacao?.isDeleted}');

  // ============ FLUXO OFFLINE-FIRST RESUMO ============
  // 1. Usuário cria/edita dados -> Salvo no SQLite com syncStatus='pending'
  // 2. UI mostra os dados imediatamente do SQLite (sem aguardar a API)
  // 3. Quando internet volta:
  //    - SyncService detecta conexão
  //    - Lê todos os items com syncStatus='pending'
  //    - Envia para a API .NET
  //    - Se sucesso, marca como syncStatus='synced'
  //    - Se erro, mantém syncStatus='pending' para tentar novamente
}
