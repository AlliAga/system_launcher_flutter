import 'package:cm_launcher/providers/application_provider.dart';
import 'package:cm_launcher/widgets/neomorphism_widget.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppListScreen extends StatelessWidget {
  const AppListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Application>>(
      initialData: context.read<ApplicationProvider>().getInitialApps,
      future: context.read<ApplicationProvider>().getApps,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Application> apps = snapshot.data!;

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: apps.length,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            var app = apps[index];

            return GestureDetector(
              onTap: () async => await app.openApp(),
              child: Neomorphism(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    app is ApplicationWithIcon
                        ? Expanded(
                            child: Image(
                              image: MemoryImage(app.icon),
                            ),
                          )
                        : const Icon(Icons.flutter_dash),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      app.appName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 0.85,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
