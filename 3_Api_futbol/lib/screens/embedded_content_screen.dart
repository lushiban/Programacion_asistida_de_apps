import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Muestra el reproductor o el widget oficial sin salir de Flutter.
/// La pantalla crea un único WebView al abrirse, así que la lista no carga
/// reproductores ni consume consultas de ScoreBat innecesariamente.
class EmbeddedContentScreen extends StatefulWidget {
  const EmbeddedContentScreen({
    super.key,
    required this.title,
    required this.uri,
  });

  final String title;
  final Uri uri;

  @override
  State<EmbeddedContentScreen> createState() => _EmbeddedContentScreenState();
}

class _EmbeddedContentScreenState extends State<EmbeddedContentScreen> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF101A12))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _progress = 0;
                _failed = false;
              });
            }
          },
          onProgress: (value) {
            if (mounted) setState(() => _progress = value);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _progress = 100);
          },
          // Los errores de subrecursos (anuncios, imágenes) no ocultan el video.
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() => _failed = true);
            }
          },
        ),
      );
    _load();
  }

  void _load() {
    setState(() {
      _failed = false;
      _progress = 0;
    });
    _controller.loadRequest(widget.uri);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title, overflow: TextOverflow.ellipsis),
      actions: [
        IconButton(
          tooltip: 'Recargar contenido',
          onPressed: _load,
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: SafeArea(
      top: false,
      child: Column(
        children: [
          if (!_failed && _progress < 100)
            LinearProgressIndicator(
              value: _progress == 0 ? null : _progress / 100,
              semanticsLabel: 'Cargando contenido de ScoreBat',
            ),
          Expanded(
            child: _failed
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 48),
                          const SizedBox(height: 16),
                          const Text(
                            'No se pudo cargar el contenido de ScoreBat.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _load,
                            child: const Text('Volver a intentar'),
                          ),
                        ],
                      ),
                    ),
                  )
                : WebViewWidget(controller: _controller),
          ),
        ],
      ),
    ),
  );
}
