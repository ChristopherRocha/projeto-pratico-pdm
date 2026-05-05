import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Function(String) onNavigate;

  const AppDrawer({
    Key? key,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.blue.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Usuário',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue.shade600),
            title: const Text('Página Inicial'),
            onTap: () {
              Navigator.pop(context);
              onNavigate('home');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue.shade600),
            title: const Text('Perfil do Usuário'),
            onTap: () {
              Navigator.pop(context);
              onNavigate('profile');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.contacts, color: Colors.green.shade600),
            title: const Text('Contatos Cadastrados'),
            onTap: () {
              Navigator.pop(context);
              onNavigate('contacts');
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Colors.orange.shade600),
            title: const Text('Todos os Eventos'),
            onTap: () {
              Navigator.pop(context);
              onNavigate('events');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              onNavigate('login');
            },
          ),
        ],
      ),
    );
  }
}
