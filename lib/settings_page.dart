import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'theme_provider.dart';
import 'localization_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _volume = 0.5;
  double _brightness = 0.5;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final currentBrightness = await ScreenBrightness().current;
      setState(() {
        _brightness = currentBrightness;
      });
    } catch (e) {
      debugPrint("Ошибка загрузки настроек: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = Provider.of<LocalizationProvider>(context);
    bool isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(loc.t('language')),
                DropdownButton<String>(
                  value: loc.language,
                  items: ['Русский', 'English']
                      .map((lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      loc.setLanguage(value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(loc.t('volume')),
                Expanded(
                  child: Slider(
                    value: _volume,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: (_volume * 100).toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _volume = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(loc.t('brightness')),
                Expanded(
                  child: Slider(
                    value: _brightness,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: (_brightness * 100).toInt().toString(),
                    onChanged: (value) async {
                      setState(() {
                        _brightness = value;
                      });
                      try {
                        await ScreenBrightness().setScreenBrightness(value);
                      } catch (e) {
                        debugPrint("Ошибка установки яркости: $e");
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(loc.t('dark_theme')),
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(loc.t('back')),
            ),
          ],
        ),
      ),
    );
  }
}
