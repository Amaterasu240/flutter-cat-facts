import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import '../../provider.dart';

class CatFactView extends ConsumerWidget {
  const CatFactView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(catFactViewModelProvider);
    
    final catNotifier = ref.read(catFactViewModelProvider.notifier);
    final authNotifier = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Кошачьи факты', style: TextStyle(fontSize: 20.sp)),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Icon(Icons.menu, size: 28.w),
              ),
              items: [
                DropdownItem<String>(
                  value: 'single',
                  child: Row(
                    children: [
                      Icon(Icons.pets, size: 20.w, color: Colors.deepPurple),
                      SizedBox(width: 10.w),
                      Text('Один факт', style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                ),
                DropdownItem<String>(
                  value: 'multiple',
                  child: Row(
                    children: [
                      Icon(Icons.reorder, size: 20.w, color: Colors.deepPurple),
                      SizedBox(width: 10.w),
                      Text('Несколько', style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                ),
                DropdownItem<String>(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20.w, color: Colors.deepPurple),
                      SizedBox(width: 10.w),
                      Text('Очистить', style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                ),
                const DropdownItem<String>(
                  value: 'divider', 
                  enabled: false,   
                  child: Divider(),
                ),
                DropdownItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20.w, color: Colors.red),
                      SizedBox(width: 10.w),
                      Text('Выйти', style: TextStyle(fontSize: 14.sp, color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'single') catNotifier.getSingleFact();
                if (value == 'multiple') catNotifier.getMultipleFacts();
                if (value == 'clear') catNotifier.clearFacts();
                if (value == 'logout') authNotifier.logout();
              },
              dropdownStyleData: DropdownStyleData(
                width: 180.w,
                padding: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r), 
                ),
                offset: const Offset(0, 0),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: () => catNotifier.getSingleFact(),
                  child: const Text('Один факт'),
                ),
                FilledButton(
                  onPressed: () => catNotifier.getMultipleFacts(),
                  child: Text('Несколько (${viewModel.numberOfFacts})'),
                ),
              ],
            ),
          ),

          Text(
            'Количество фактов: ${viewModel.numberOfFacts}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          
          Slider(
            value: viewModel.numberOfFacts.toDouble(),
            min: 2,
            max: 15,
            divisions: 13,
            label: viewModel.numberOfFacts.toString(),
            onChanged: (double value) => catNotifier.updateNumberOfFacts(value),
          ),
          
          const Divider(),

          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: viewModel.facts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Text(
                            viewModel.facts[index].fact,
                            style: TextStyle(fontSize: 15.sp),
                          ),
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