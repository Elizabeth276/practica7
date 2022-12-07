import 'package:flutter/material.dart';
import 'package:practica7/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => OnboardingProvider(),
        child: OnboardingPage(controller: controller));
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    OnboardingProvider provider = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            provider.setPaginaActual(index);
          },
          children: [
            buildPage(
                context,
                Theme.of(context).primaryColor,
                'assets/img/introduction_page1.png',
                'Registro de personal',
                '¡Lleva el control y registro de los empleados de tu empresa en tu celular!'),
            buildPage(
                context,
                Theme.of(context).primaryColorDark,
                'assets/img/introduction_page2.png',
                'Registro de incidencias',
                '¡Registra las incidencias del mes cometidas por los empleados llenando un simple formulario!'),
            buildPage(
                context,
                Theme.of(context).secondaryHeaderColor,
                'assets/img/introduction_page3.png',
                'Administra tu tiempo',
                '¡Nuestra App también funciona como agenda, registra tus actividades diarias para que no se te olvide realizarlas!'),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.jumpToPage(2);
              },
              child: Text(
                'OMITIR',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: Colors.black26,
                  activeDotColor: Theme.of(context).primaryColor,
                ),
                onDotClicked: (index) => controller.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn),
              ),
            ),
            TextButton(
              onPressed: () {
                provider.getActualPage() == 2
                    ? Navigator.pushReplacementNamed(context, '/dash')
                    : controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
              },
              child: Text(
                provider.getActualPage() == 2 ? 'CONTINUAR' : 'SIGUIENTE',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildPage(BuildContext context, Color color, String urlImage,
      String title, String subtitle) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                urlImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 17,
                  letterSpacing: 2),
            ),
          )
        ],
      ),
    );
  }
}
