import 'package:flutter/material.dart';
import '../components/app_drawer.dart';

class ContactsScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const ContactsScreen({
    Key? key,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'João Silva', 'email': 'joao@email.com', 'phone': '(11) 99999-0001'},
      {'name': 'Maria Santos', 'email': 'maria@email.com', 'phone': '(11) 99999-0002'},
      {'name': 'Pedro Oliveira', 'email': 'pedro@email.com', 'phone': '(11) 99999-0003'},
      {'name': 'Ana Costa', 'email': 'ana@email.com', 'phone': '(11) 99999-0004'},
      {'name': 'Carlos Ferreira', 'email': 'carlos@email.com', 'phone': '(11) 99999-0005'},
      {'name': 'Fernanda Gomes', 'email': 'fernanda@email.com', 'phone': '(11) 99999-0006'},
      {'name': 'Ricardo Martins', 'email': 'ricardo@email.com', 'phone': '(11) 99999-0007'},
      {'name': 'Juliana Rocha', 'email': 'juliana@email.com', 'phone': '(11) 99999-0008'},
      {'name': 'Lucas Barbosa', 'email': 'lucas@email.com', 'phone': '(11) 99999-0009'},
      {'name': 'Patricia Alves', 'email': 'patricia@email.com', 'phone': '(11) 99999-0010'},
      {'name': 'Bruno Castro', 'email': 'bruno@email.com', 'phone': '(11) 99999-0011'},
      {'name': 'Camila Ribeiro', 'email': 'camila@email.com', 'phone': '(11) 99999-0012'},
      {'name': 'Diego Mendes', 'email': 'diego@email.com', 'phone': '(11) 99999-0013'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos Cadastrados'),
        backgroundColor: Colors.green.shade600,
        elevation: 2,
      ),
      drawer: AppDrawer(onNavigate: onNavigate),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade600,
                child: Text(
                  contact['name']![0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                contact['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          contact['email']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        contact['phone']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Editar'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Editar contato')),
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Excluir'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contato excluído')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adicionar novo contato')),
          );
        },
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add),
      ),
    );
  }
}
