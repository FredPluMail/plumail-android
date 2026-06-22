import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const PluMailApp());
}

Future<void> contactSupport() async {
  final uri = Uri.parse(
    'mailto:contact@plumail.net?subject=Support%20PluMail',
  );
  await launchUrl(uri);
}

class PluMailApp extends StatelessWidget {
  const PluMailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const PluMailMenu(),
            transitionDuration: const Duration(milliseconds: 450),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String loadingText(double value) {
    if (value < 0.35) return "INITIALISATION...";
    if (value < 0.70) return "CONNEXION...";
    return "CHARGEMENT...";
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFE653C9);
    const darkGreen = Color(0xFF245018);
    const cream = Color(0xFFF3F7E8);
    const titleGreen = Color(0xFF73E86F);

    return Scaffold(
      backgroundColor: const Color(0xFF396B22),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final percent = (controller.value * 100).floor();
                  final text = loadingText(controller.value);

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: const Offset(10, 10),
                        child: Container(
                          width: 360,
                          height: 220,
                          color: darkGreen.withOpacity(0.65),
                        ),
                      ),
                      Container(
                        width: 360,
                        height: 220,
                        padding: const EdgeInsets.all(6),
                        color: titleGreen,
                        child: Container(
                          color: pink,
                          child: Column(
                            children: [
                              Container(
                                height: 42,
                                color: darkGreen,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      child: PixelText(
                                        text: "PLUMAIL",
                                        pixelSize: 3.5,
                                        color: pink,
                                      ),
                                    ),
                                    PixelText(
                                      text: "X",
                                      pixelSize: 3.5,
                                      color: cream,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              PixelText(
                                text: text,
                                pixelSize: 3.1,
                                color: cream,
                              ),
                              const SizedBox(height: 20),
                              PixelProgressBar(value: controller.value),
                              const SizedBox(height: 14),
                              PixelText(
                                text: "$percent%",
                                pixelSize: 2.7,
                                color: cream,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PixelProgressBar extends StatelessWidget {
  final double value;

  const PixelProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF245018);
    const cream = Color(0xFFF3F7E8);

    final blocks = (value * 18).floor();

    return Container(
      width: 285,
      height: 42,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: cream,
        border: Border.all(color: darkGreen, width: 4),
      ),
      child: Row(
        children: List.generate(18, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              color: index < blocks ? darkGreen : Colors.transparent,
            ),
          );
        }),
      ),
    );
  }
}

class PluMailMenu extends StatelessWidget {
  const PluMailMenu({super.key});

  void openWebView(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewPage(
          title: title,
          url: url,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF396B22),
      body: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: w * 0.05,
                    right: w * 0.05,
                    top: h * 0.105,
                    child: PixelButton(
                      text: "J AI UN COMPTE !",
                      showArrow: true,
                      onTap: () {
                        openWebView(
                          context,
                          "PLUMAIL",
                          "https://mail.plumail.net",
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: w * 0.05,
                    right: w * 0.05,
                    top: h * 0.335,
                    child: PixelButton(
                      text: "JE VEUX UN COMPTE !",
                      showArrow: true,
                      onTap: () {
                        openWebView(
                          context,
                          "INSCRIPTION",
                          "https://registration.plumail.net",
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: w * 0.05,
                    right: w * 0.05,
                    top: h * 0.565,
                    child: PixelButton(
                      text: "J AI BESOIN D AIDE !",
                      showArrow: true,
                      onTap: contactSupport,
                    ),
                  ),
                  Positioned(
                    left: w * 0.075,
                    right: w * 0.075,
                    bottom: h * 0.035,
                    child: const Footer(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  int loadingProgress = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF245018))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              loadingProgress = progress;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<bool> handleBack() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFE653C9);
    const darkGreen = Color(0xFF245018);
    const cream = Color(0xFFF3F7E8);

    return WillPopScope(
      onWillPop: handleBack,
      child: Scaffold(
        backgroundColor: darkGreen,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 54,
                color: darkGreen,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (await controller.canGoBack()) {
                          await controller.goBack();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const PixelText(
                        text: "<",
                        pixelSize: 4,
                        color: pink,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: PixelText(
                        text: widget.title,
                        pixelSize: 3,
                        color: pink,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const PixelText(
                        text: "X",
                        pixelSize: 4,
                        color: cream,
                      ),
                    ),
                  ],
                ),
              ),
              if (loadingProgress < 100)
                LinearProgressIndicator(
                  value: loadingProgress / 100,
                  backgroundColor: cream,
                  color: pink,
                  minHeight: 4,
                ),
              Expanded(
                child: WebViewWidget(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PixelButton extends StatefulWidget {
  final String text;
  final bool showArrow;
  final VoidCallback? onTap;

  const PixelButton({
    super.key,
    required this.text,
    this.showArrow = false,
    this.onTap,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool pressed = false;

  void _pressDown(_) => setState(() => pressed = true);

  void _pressUp(_) async {
    setState(() => pressed = false);
    await Future.delayed(const Duration(milliseconds: 70));
    widget.onTap?.call();
  }

  void _pressCancel() => setState(() => pressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _pressDown,
      onTapUp: _pressUp,
      onTapCancel: _pressCancel,
      child: AnimatedScale(
        scale: pressed ? 0.965 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: AnimatedSlide(
          offset: pressed ? const Offset(0, 0.035) : Offset.zero,
          duration: const Duration(milliseconds: 80),
          child: CustomPaint(
            painter: ButtonPainter(pressed: pressed),
            child: SizedBox(
              height: 92,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: PixelText(
                            text: widget.text,
                            pixelSize: 4.1,
                            color: const Color(0xFF245018),
                          ),
                        ),
                      ),
                    ),
                    if (widget.showArrow) ...[
                      const SizedBox(width: 10),
                      const PixelText(
                        text: ">",
                        pixelSize: 4.2,
                        color: Color(0xFFE653C9),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonPainter extends CustomPainter {
  final bool pressed;

  ButtonPainter({required this.pressed});

  @override
  void paint(Canvas canvas, Size size) {
    final shadowOffset = pressed ? 4.0 : 8.0;

    final shadow = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        shadowOffset,
        shadowOffset,
        size.width - shadowOffset,
        size.height - shadowOffset,
      ),
      const Radius.circular(28),
    );

    final main = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width - 8, size.height - 8),
      const Radius.circular(28),
    );

    canvas.drawRRect(shadow, Paint()..color = const Color(0xCCF3F7E8));
    canvas.drawRRect(main, Paint()..color = const Color(0xFFF3F7E8));
    canvas.drawRRect(
      main,
      Paint()
        ..color = const Color(0xFFE653C9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = pressed ? 5 : 4,
    );
  }

  @override
  bool shouldRepaint(covariant ButtonPainter oldDelegate) {
    return oldDelegate.pressed != pressed;
  }
}

class PixelText extends StatelessWidget {
  final String text;
  final double pixelSize;
  final Color color;

  const PixelText({
    super.key,
    required this.text,
    required this.pixelSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PixelTextPainter(text, pixelSize, color),
      size: Size(text.length * pixelSize * 6, pixelSize * 7),
    );
  }
}

class PixelTextPainter extends CustomPainter {
  final String text;
  final double p;
  final Color color;

  PixelTextPainter(this.text, this.p, this.color);

  static const Map<String, List<String>> font = {
    "A": ["01110", "10001", "10001", "11111", "10001", "10001", "10001"],
    "B": ["11110", "10001", "10001", "11110", "10001", "10001", "11110"],
    "C": ["01111", "10000", "10000", "10000", "10000", "10000", "01111"],
    "D": ["11110", "10001", "10001", "10001", "10001", "10001", "11110"],
    "E": ["11111", "10000", "10000", "11110", "10000", "10000", "11111"],
    "G": ["01111", "10000", "10000", "10111", "10001", "10001", "01111"],
    "H": ["10001", "10001", "10001", "11111", "10001", "10001", "10001"],
    "I": ["11111", "00100", "00100", "00100", "00100", "00100", "11111"],
    "J": ["00111", "00010", "00010", "00010", "00010", "10010", "01100"],
    "L": ["10000", "10000", "10000", "10000", "10000", "10000", "11111"],
    "M": ["10001", "11011", "10101", "10101", "10001", "10001", "10001"],
    "N": ["10001", "11001", "10101", "10011", "10001", "10001", "10001"],
    "O": ["01110", "10001", "10001", "10001", "10001", "10001", "01110"],
    "P": ["11110", "10001", "10001", "11110", "10000", "10000", "10000"],
    "R": ["11110", "10001", "10001", "11110", "10100", "10010", "10001"],
    "S": ["01111", "10000", "10000", "01110", "00001", "00001", "11110"],
    "T": ["11111", "00100", "00100", "00100", "00100", "00100", "00100"],
    "U": ["10001", "10001", "10001", "10001", "10001", "10001", "01110"],
    "V": ["10001", "10001", "10001", "10001", "10001", "01010", "00100"],
    "X": ["10001", "10001", "01010", "00100", "01010", "10001", "10001"],
    "<": ["00001", "00010", "00100", "01000", "00100", "00010", "00001"],
    ">": ["10000", "01000", "00100", "00010", "00100", "01000", "10000"],
    " ": ["00000", "00000", "00000", "00000", "00000", "00000", "00000"],
    "!": ["00100", "00100", "00100", "00100", "00100", "00000", "00100"],
    ".": ["00000", "00000", "00000", "00000", "00000", "00000", "00100"],
    "%": ["11001", "11010", "00100", "01000", "10110", "00110", "00000"],
    "1": ["00100", "01100", "00100", "00100", "00100", "00100", "01110"],
    "2": ["01110", "10001", "00001", "00010", "00100", "01000", "11111"],
    "3": ["11110", "00001", "00001", "01110", "00001", "00001", "11110"],
    "4": ["00010", "00110", "01010", "10010", "11111", "00010", "00010"],
    "5": ["11111", "10000", "10000", "11110", "00001", "00001", "11110"],
    "6": ["01111", "10000", "10000", "11110", "10001", "10001", "01110"],
    "7": ["11111", "00001", "00010", "00100", "01000", "01000", "01000"],
    "8": ["01110", "10001", "10001", "01110", "10001", "10001", "01110"],
    "9": ["01110", "10001", "10001", "01111", "00001", "00001", "11110"],
    "0": ["01110", "10001", "10011", "10101", "11001", "10001", "01110"],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final chars = text.toUpperCase().split("");

    for (int i = 0; i < chars.length; i++) {
      final glyph = font[chars[i]] ?? font[" "]!;
      for (int y = 0; y < glyph.length; y++) {
        for (int x = 0; x < glyph[y].length; x++) {
          if (glyph[y][x] == "1") {
            canvas.drawRect(
              Rect.fromLTWH(i * p * 6 + x * p, y * p, p, p),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const pink = Color(0xFFE653C9);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pink.withOpacity(0.18),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          PixelText(text: "....................", pixelSize: 1.7, color: pink),
          SizedBox(height: 10),
          PixelText(text: "PLUMAIL", pixelSize: 3.2, color: pink),
          SizedBox(height: 9),
          PixelText(text: "MESSAGERIE", pixelSize: 2.1, color: pink),
          SizedBox(height: 7),
          PixelText(text: "INDEPENDANTE", pixelSize: 2.1, color: pink),
          SizedBox(height: 9),
          PixelText(text: "V1.0", pixelSize: 2.1, color: pink),
        ],
      ),
    );
  }
}