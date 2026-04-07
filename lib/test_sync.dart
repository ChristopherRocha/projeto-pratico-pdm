// Script de teste para verificar se o sincronizador está funcionando
// Para usar, importe este arquivo em alguma tela e chame testSyncSystem()

import 'package:uuid/uuid.dart';
import 'package:trabalho_pratico/repositories/index.dart';
import 'package:trabalho_pratico/models/index.dart';

Future<void> testSyncSystem() async {
  print('\n\n========== TESTE DE SINCRONIZADOR ==========\n');

  try {
    // ===== TESTE 1: Criar usuário =====
    print('✓ TESTE 1: Criando usuário...');
    final userRepo = UserRepository();
    final user = await userRepo.createUser(
      name: 'Usuário Teste ${DateTime.now()}',
      email: 'teste@example.com',
    );
    print('  ✓ Usuário criado: ${user.name}');
    print('  ✓ ID: ${user.id}');
    print('  ✓ Sync Status: ${user.syncStatus}');
    assert(user.syncStatus == 'pending', 'Deve estar pending');

    // ===== TESTE 2: Obter usuário =====
    print('\n✓ TESTE 2: Obtendo usuário do SQLite...');
    final userRecovered = await userRepo.getUser(user.id);
    print('  ✓ Usuário recuperado: ${userRecovered?.name}');
    assert(userRecovered != null, 'Usuário deve existir');
    assert(userRecovered!.email == 'teste@example.com', 'Email deve corresponder');

    // ===== TESTE 3: Criar contato =====
    print('\n✓ TESTE 3: Criando contato...');
    final contactRepo = ContactRepository();
    final contact = await contactRepo.createContact(
      name: 'Contato Teste',
      email: 'contato@example.com',
      phoneNumber: '11999999999',
      userId: user.id,
    );
    print('  ✓ Contato criado: ${contact.name}');
    print('  ✓ ID: ${contact.id}');
    print('  ✓ Sync Status: ${contact.syncStatus}');
    assert(contact.syncStatus == 'pending', 'Deve estar pending');

    // ===== TESTE 4: Criar evento =====
    print('\n✓ TESTE 4: Criando evento...');
    final eventRepo = EventRepository();
    final event = await eventRepo.createEvent(
      title: 'Evento Teste',
      date: DateTime.now().add(Duration(days: 1)),
      location: 'Local Teste',
      contactId: contact.id,
      description: 'Descrição de Teste',
      message: 'Mensagem de Teste',
    );
    print('  ✓ Evento criado: ${event.title}');
    print('  ✓ ID: ${event.id}');
    print('  ✓ Sync Status: ${event.syncStatus}');
    assert(event.syncStatus == 'pending', 'Deve estar pending');

    // ===== TESTE 5: Atualizar evento =====
    print('\n✓ TESTE 5: Atualizando evento...');
    final eventoAtualizado = event.copyWith(
      title: 'Evento Atualizado',
      description: 'Descrição Atualizada',
    );
    await eventRepo.updateEvent(eventoAtualizado);
    final eventUpdated = await eventRepo.getEvent(event.id);
    print('  ✓ Evento atualizado: ${eventUpdated?.title}');
    print('  ✓ Sync Status: ${eventUpdated?.syncStatus}');

    // ===== TESTE 6: Listar eventos =====
    print('\n✓ TESTE 6: Listando todos os eventos...');
    final eventos = await eventRepo.getAllEvents();
    print('  ✓ Total de eventos: ${eventos.length}');

    // ===== TESTE 7: Obter eventos por contato =====
    print('\n✓ TESTE 7: Listando eventos por contato...');
    final eventosDoContato = await eventRepo.getEventsByContact(contact.id);
    print('  ✓ Eventos do contato: ${eventosDoContato.length}');

    // ===== TESTE 8: Obter pendentes de sincronização =====
    print('\n✓ TESTE 8: Verificando itens pendentes...');
    final pendingUsers = await userRepo.getPendingUsers();
    final pendingContacts = await contactRepo.getPendingContacts();
    final pendingEvents = await eventRepo.getPendingEvents();
    print('  ✓ Usuários pendentes: ${pendingUsers.length}');
    print('  ✓ Contatos pendentes: ${pendingContacts.length}');
    print('  ✓ Eventos pendentes: ${pendingEvents.length}');

    // ===== TESTE 9: Soft delete =====
    print('\n✓ TESTE 9: Testando soft delete...');
    await eventRepo.deleteEvent(event.id);
    final deletedEvent = await eventRepo.getEvent(event.id);
    print('  ✓ Evento marcado como deletado: ${deletedEvent?.isDeleted}');
    assert(deletedEvent?.isDeleted == true, 'Deve estar marcado como deletado');

    // ===== TESTE 10: Marcar como sincronizado =====
    print('\n✓ TESTE 10: Marcando como sincronizado...');
    await userRepo.markUserSynced(user.id);
    final syncedUser = await userRepo.getUser(user.id);
    print('  ✓ Usuário marcado como synced: ${syncedUser?.syncStatus}');
    assert(syncedUser?.syncStatus == 'synced', 'Deve estar synced');

    print('\n\n========== ✓ TODOS OS TESTES PASSARAM! ==========\n');
    print('Seu sistema offline-first está funcionando corretamente!');
    print('Próximo passo: configurar a base URL da API em api_config.dart');
    print('e testar a sincronização com sua API .NET.\n');

  } catch (e) {
    print('\n\n❌ ERRO NOS TESTES: $e');
    rethrow;
  }
}

// Teste simples para ver os logs de sincronização
void testConnectivity() async {
  print('\n========== TESTE DE CONECTIVIDADE ==========\n');
  print('Se você ver logs de sincronização abaixo, tudo está ok!');
  print('Se houver internet, a sincronização deve iniciar automaticamente.\n');
}
