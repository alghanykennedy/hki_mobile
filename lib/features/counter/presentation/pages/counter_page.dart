import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hki_mobile/features/counter/presentation/controllers/counter_controller.dart';

class CounterPage extends GetView<CounterController> {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HKI Mobile Starter')),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Clean Architecture + GetX'),
              const SizedBox(height: 12),
              Text(
                '${controller.count.value}',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: controller.increment,
                child: const Text('Increment'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
