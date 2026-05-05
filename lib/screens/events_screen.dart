import 'package:flutter/material.dart';
import '../components/app_drawer.dart';

class EventsScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const EventsScreen({
    Key? key,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'title': 'Reunião com Equipe',
        'date': '05/05/2026',
        'time': '10:00',
        'location': 'Sala de Conferência',
        'description': 'Discussão sobre próximos projetos',
        'icon': Icons.group,
        'color': Colors.blue,
      },
      {
        'title': 'Almoço de Negócios',
        'date': '05/05/2026',
        'time': '12:30',
        'location': 'Restaurante Downtown',
        'description': 'Com cliente importante',
        'icon': Icons.restaurant,
        'color': Colors.orange,
      },
      {
        'title': 'Chamada com Cliente',
        'date': '05/05/2026',
        'time': '14:00',
        'location': 'Videochamada',
        'description': 'Apresentação do projeto',
        'icon': Icons.video_call,
        'color': Colors.green,
      },
      {
        'title': 'Revisão de Código',
        'date': '06/05/2026',
        'time': '09:00',
        'location': 'Online',
        'description': 'Revisão do módulo de sincronização',
        'icon': Icons.code,
        'color': Colors.purple,
      },
      {
        'title': 'Treinamento Flutter',
        'date': '06/05/2026',
        'time': '15:00',
        'location': 'Auditório',
        'description': 'Workshop com especialista',
        'icon': Icons.school,
        'color': Colors.red,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Eventos'),
        backgroundColor: Colors.orange.shade600,
        elevation: 2,
      ),
      drawer: AppDrawer(onNavigate: onNavigate),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(
                    color: event['color'] as Color,
                    width: 4,
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (event['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    event['icon'] as IconData,
                    color: event['color'] as Color,
                    size: 28,
                  ),
                ),
                title: Text(
                  event['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event['date'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event['time'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event['location'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['description'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Visualizar: ${event['title']}'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adicionar novo evento')),
          );
        },
        backgroundColor: Colors.orange.shade600,
        child: const Icon(Icons.add),
      ),
    );
  }
}
