
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MGApp());
}

class MGApp extends StatelessWidget {
  const MGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MG Digital Service',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1457A6),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;
  bool hindi = false;

  final String website = 'https://jansevacom.vercel.app/';

  final String mapUrl =
      'https://www.google.com/maps/search/?api=1&query=2VHX%2B3P%20Mahuvar%2C%20Gujarat';

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(website));
  }

  Future<void> openMap() async {
    await launchUrl(
      Uri.parse(mapUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = hindi
        ? ['होम', 'सेवाएँ', 'पोर्टफोलियो', 'लोकेशन']
        : ['Home', 'Services', 'Portfolio', 'Location'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MG Digital Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => hindi = !hindi);
            },
            child: Text(hindi ? 'EN' : 'हिंदी'),
          ),
        ],
      ),
      body: selected == 3
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 70,
                    color: Colors.blue,
                  ),
                  Text(
                    hindi ? 'हमारा स्थान' : 'Our Location',
                    style: const TextStyle(fontSize: 23),
                  ),
                  const Text('2VHX+3P, Mahuvar, Gujarat'),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: openMap,
                    icon: const Icon(Icons.directions),
                    label: Text(
                      hindi ? 'रास्ता देखें' : 'Get Directions',
                    ),
                  ),
                ],
              ),
            )
          : WebViewWidget(controller: controller),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) {
          setState(() => selected = index);

          if (index == 0 || index == 1) {
            controller.loadRequest(Uri.parse(website));
          }

          if (index == 2) {
            controller.loadRequest(
              Uri.parse('${website}#portfolio'),
            );
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: labels[0],
          ),
          NavigationDestination(
            icon: const Icon(Icons.miscellaneous_services),
            label: labels[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.photo_library),
            label: labels[2],
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_on),
            label: labels[3],
          ),
        ],
      ),
    );
  }
}
