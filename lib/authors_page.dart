import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization_provider.dart';

class AuthorsPage extends StatelessWidget {
  const AuthorsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('authors')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${loc.t('developer')}: Кулаковская Варвара, Загаров Павел'),
            const SizedBox(height: 20),
            Text('${loc.t('designer')}: Шарипов Роман, Леонтьев Андрей'),
            const SizedBox(height: 20),
            Text('${loc.t('tester')}: Репин Павел'),
            const SizedBox(height: 40),
            ElevatedButton(
              child: Text(loc.t('back')),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
