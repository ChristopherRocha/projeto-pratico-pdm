import 'api_service.dart';
import 'connectivity_service.dart';
import '../repositories/index.dart';

class SyncService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final EventRepository _eventRepository = EventRepository();
  final ContactRepository _contactRepository = ContactRepository();
  final UserRepository _userRepository = UserRepository();

  bool _isSyncing = false;

  SyncService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  })  : _apiService = apiService,
        _connectivityService = connectivityService;

  /// Inicializa o sincronizador
  Future<void> init() async {
    // Monitora mudanças de conectividade
    _connectivityService.addListener((isConnected) {
      if (isConnected) {
        print('Internet disponível! Iniciando sincronização...');
        syncAll();
      }
    });

    // Se já está conectado, faz sincronização inicial
    if (_connectivityService.isConnected) {
      print('App iniciou com internet. Fazendo sincronização inicial...');
      await Future.delayed(Duration(seconds: 2)); // Pequeno delay
      await syncAll();
    }
  }

  /// Sincroniza tudo (usuários, contatos, eventos)
  Future<void> syncAll() async {
    if (_isSyncing) {
      print('Sincronização já em andamento...');
      return;
    }

    _isSyncing = true;
    print('=== INICIANDO SINCRONIZAÇÃO ===');

    try {
      // Sincroniza na ordem: usuários -> contatos -> eventos
      await _syncUsers();
      await _syncContacts();
      await _syncEvents();

      print('=== SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO ===');
    } catch (e) {
      print('Erro durante sincronização: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Sincroniza usuários
  Future<void> _syncUsers() async {
    try {
      print('\n--- Sincronizando Usuários ---');
      final pendingUsers = await _userRepository.getPendingUsers();
      print('Usuários pendentes: ${pendingUsers.length}');

      for (var user in pendingUsers) {
        try {
          if (user.isDeleted) {
            await _apiService.deleteUser(user);
            print('✓ Usuário deletado: ${user.id}');
          } else if (user.remoteId == null) {
            final syncedUser = await _apiService.createUser(user);
            if (syncedUser.remoteId != null) {
              await _userRepository.saveUserRemoteId(user.id, syncedUser.remoteId!);
            } else {
              await _userRepository.markUserSynced(user.id);
            }
            print('✓ Usuário criado na API: ${user.name}');
          } else if (user.isDirty) {
            final syncedUser = await _apiService.updateUser(user);
            if (syncedUser.remoteId != null) {
              await _userRepository.saveUserRemoteId(user.id, syncedUser.remoteId!);
            } else {
              await _userRepository.markUserSynced(user.id);
            }
            print('✓ Usuário atualizado: ${user.name}');
          }

          // Marca como sincronizado
          await _userRepository.markUserSynced(user.id);
        } catch (e) {
          print('✗ Erro ao sincronizar usuário ${user.id}: $e');
        }
      }
    } catch (e) {
      print('Erro ao sincronizar usuários: $e');
    }
  }

  /// Sincroniza contatos
  Future<void> _syncContacts() async {
    try {
      print('\n--- Sincronizando Contatos ---');
      final pendingContacts = await _contactRepository.getPendingContacts();
      print('Contatos pendentes: ${pendingContacts.length}');

      for (var contact in pendingContacts) {
        try {
          if (contact.isDeleted) {
            await _apiService.deleteContact(contact);
            print('✓ Contato deletado: ${contact.id}');
          } else if (contact.remoteId == null) {
            final syncedContact = await _apiService.createContact(contact);
            if (syncedContact.remoteId != null) {
              await _contactRepository.saveContactRemoteId(contact.id, syncedContact.remoteId!);
            } else {
              await _contactRepository.markContactSynced(contact.id);
            }
            print('✓ Contato criado na API: ${contact.name}');
          } else if (contact.isDirty) {
            final syncedContact = await _apiService.updateContact(contact);
            if (syncedContact.remoteId != null) {
              await _contactRepository.saveContactRemoteId(contact.id, syncedContact.remoteId!);
            } else {
              await _contactRepository.markContactSynced(contact.id);
            }
            print('✓ Contato atualizado: ${contact.name}');
          }

          // Marca como sincronizado
          await _contactRepository.markContactSynced(contact.id);
        } catch (e) {
          print('✗ Erro ao sincronizar contato ${contact.id}: $e');
        }
      }
    } catch (e) {
      print('Erro ao sincronizar contatos: $e');
    }
  }

  /// Sincroniza eventos
  Future<void> _syncEvents() async {
    try {
      print('\n--- Sincronizando Eventos ---');
      final pendingEvents = await _eventRepository.getPendingEvents();
      print('Eventos pendentes: ${pendingEvents.length}');

      for (var event in pendingEvents) {
        try {
          if (event.isDeleted) {
            await _apiService.deleteEvent(event);
            print('✓ Evento deletado: ${event.id}');
          } else {
            final contact = await _contactRepository.getContact(event.contactId);
            final contactRemoteId = contact?.remoteId ?? event.contactRemoteId;

            if (contactRemoteId == null) {
              print('✗ Evento ${event.id} aguardando contato remoto');
              continue;
            }

            final eventWithRemoteContact = event.copyWith(contactRemoteId: contactRemoteId);

            if (event.remoteId == null) {
              final syncedEvent = await _apiService.createEvent(eventWithRemoteContact);
              if (syncedEvent.remoteId != null) {
                await _eventRepository.saveEventRemoteData(
                  event.id,
                  syncedEvent.remoteId!,
                  contactRemoteId: contactRemoteId,
                );
              } else {
                await _eventRepository.markEventSynced(event.id);
              }
              print('✓ Evento criado na API: ${event.title}');
            } else if (event.isDirty) {
              final syncedEvent = await _apiService.updateEvent(eventWithRemoteContact);
              if (syncedEvent.remoteId != null) {
                await _eventRepository.saveEventRemoteData(
                  event.id,
                  syncedEvent.remoteId!,
                  contactRemoteId: contactRemoteId,
                );
              } else {
                await _eventRepository.markEventSynced(event.id);
              }
              print('✓ Evento atualizado: ${event.title}');
            }
          }

          // Marca como sincronizado
          await _eventRepository.markEventSynced(event.id);
        } catch (e) {
          print('✗ Erro ao sincronizar evento ${event.id}: $e');
        }
      }
    } catch (e) {
      print('Erro ao sincronizar eventos: $e');
    }
  }

  /// Sincroniza um evento específico (on-demand)
  Future<void> syncEvent(String eventId) async {
    try {
      final event = await _eventRepository.getEvent(eventId);
      if (event != null) {
        final contact = await _contactRepository.getContact(event.contactId);
        final contactRemoteId = contact?.remoteId ?? event.contactRemoteId;
        if (contactRemoteId == null) {
          return;
        }

        final eventWithRemoteContact = event.copyWith(contactRemoteId: contactRemoteId);

        if (event.remoteId == null) {
          final syncedEvent = await _apiService.createEvent(eventWithRemoteContact);
          if (syncedEvent.remoteId != null) {
            await _eventRepository.saveEventRemoteData(
              event.id,
              syncedEvent.remoteId!,
              contactRemoteId: contactRemoteId,
            );
          }
        } else {
          final syncedEvent = await _apiService.updateEvent(eventWithRemoteContact);
          if (syncedEvent.remoteId != null) {
            await _eventRepository.saveEventRemoteData(
              event.id,
              syncedEvent.remoteId!,
              contactRemoteId: contactRemoteId,
            );
          }
        }
        await _eventRepository.markEventSynced(eventId);
        print('✓ Evento sincronizado: $eventId');
      }
    } catch (e) {
      print('Erro ao sincronizar evento $eventId: $e');
    }
  }

  /// Sincroniza um contato específico (on-demand)
  Future<void> syncContact(String contactId) async {
    try {
      final contact = await _contactRepository.getContact(contactId);
      if (contact != null) {
        if (contact.remoteId == null) {
          final syncedContact = await _apiService.createContact(contact);
          if (syncedContact.remoteId != null) {
            await _contactRepository.saveContactRemoteId(contact.id, syncedContact.remoteId!);
          }
        } else {
          final syncedContact = await _apiService.updateContact(contact);
          if (syncedContact.remoteId != null) {
            await _contactRepository.saveContactRemoteId(contact.id, syncedContact.remoteId!);
          }
        }
        await _contactRepository.markContactSynced(contactId);
        print('✓ Contato sincronizado: $contactId');
      }
    } catch (e) {
      print('Erro ao sincronizar contato $contactId: $e');
    }
  }

  /// Sincroniza um usuário específico (on-demand)
  Future<void> syncUser(String userId) async {
    try {
      final user = await _userRepository.getUser(userId);
      if (user != null) {
        if (user.remoteId == null) {
          final syncedUser = await _apiService.createUser(user);
          if (syncedUser.remoteId != null) {
            await _userRepository.saveUserRemoteId(user.id, syncedUser.remoteId!);
          }
        } else {
          final syncedUser = await _apiService.updateUser(user);
          if (syncedUser.remoteId != null) {
            await _userRepository.saveUserRemoteId(user.id, syncedUser.remoteId!);
          }
        }
        await _userRepository.markUserSynced(userId);
        print('✓ Usuário sincronizado: $userId');
      }
    } catch (e) {
      print('Erro ao sincronizar usuário $userId: $e');
    }
  }

  /// Retorna se está sincronizando
  bool get isSyncing => _isSyncing;

  /// Força sincronização (útil para testes manuais)
  Future<void> forceSync() async {
    print('\n🔄 Sincronização forçada acionada pelo usuário');
    await syncAll();
  }
}
