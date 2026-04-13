import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // НОВЫЙ ИМПОРТ RIVERPOD
import '../../provider.dart';

class CatFactView extends ConsumerWidget {
  const CatFactView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Подключаемся к ViewModel
    final viewModel = ref.watch(catFactViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кошачьи факты'),
        // НОВОЕ: actions - это элементы в правой части AppBar
        actions: [
          PopupMenuButton<String>(
            // Задаем иконку "три полоски" (если убрать эту строчку, будут стандартные 3 точки)
            icon: const Icon(Icons.menu), 
            // Что делать при выборе пункта меню
            onSelected: (String value) {
              final vm = ref.read(catFactViewModelProvider.notifier);
              final auVm = ref.read(authViewModelProvider.notifier);
              if (value == 'single') {
                vm.getSingleFact();
              } else if (value == 'multiple') {
                vm.getMultipleFacts();
              } else if (value == 'clear') {
                vm.clearFacts();
              } else if (value == 'logout') {
                auVm.logout();
              }
            },
            // Сами пункты выпадающего меню
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'single',
                child: Text('Один факт'),
              ),
              const PopupMenuItem<String>(
                value: 'multiple',
                child: Text('Несколько фактов'),
              ),
              const PopupMenuItem<String>(
                value: 'clear',
                child: Text(
                  'Очистить список', 
                  style: TextStyle(color: Colors.red), // Сделаем текст красным
                ),
              ),
              const PopupMenuDivider(), // Тонкая линия-разделитель для красоты
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text(
                  'Выйти', 
                  style: TextStyle(color: Colors.red), // Сделаем текст красным
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  // Дергаем метод из ViewModel без прослушивания (read)
                  onPressed: () => ref.read(catFactViewModelProvider.notifier).getSingleFact(),
                  child: const Text('Один факт'),
                ),
                ElevatedButton(
                  onPressed: () => ref.read(catFactViewModelProvider.notifier).getMultipleFacts(),
                  child: Text('Несколько (${viewModel.numberOfFacts})'),
                ),
              ],
            ),
          ),

          Text(
            'Количество фактов: ${viewModel.numberOfFacts}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: viewModel.numberOfFacts.toDouble(), // Текущее значение
            min: 2,                                    // Минимум
            max: 15,                                   // Максимум
            divisions: 13,                             // Шаги (15 - 2 = 13), чтобы ползунок прыгал только по целым числам
            label: viewModel.numberOfFacts.toString(), // Всплывающая подсказка над ползунком
            onChanged: (double value) {
              // Вызываем метод изменения при движении
              ref.read(catFactViewModelProvider.notifier).updateNumberOfFacts(value);
            },
          ),
          const Divider(), // Просто визуальная линия-разделитель

          // Показываем индикатор или список фактов
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: viewModel.facts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(viewModel.facts[index].fact),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}