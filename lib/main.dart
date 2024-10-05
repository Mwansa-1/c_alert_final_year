import 'package:c_alert/blogapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:go_router/go_router.dart';

// Pages import
import 'nav.dart';
import 'feed.dart';
import 'profile.dart';
import 'new_test.dart';
import 'new_test1.dart';
import 'home.dart';
import 'more_info.dart';
import 'previous_tests.dart';
import 'bluetooth_scan.dart';
import 'detailspage.dart';
import 'result.dart';
import 'waiting_page.dart';
import 'blog_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      // Home page with sub-routes
      GoRoute(
        path: '/',
        builder: (context, state) => Nav(
          child: const HomePage(),
          currentIndex: 0,
        ),
        routes: [
          GoRoute(
            path: 'new_test',
            builder: (context, state) => Nav(
              child: const NewTestPage(),
              currentIndex: 0,
            ),
          ),
          GoRoute(
            path: 'previous_tests',
            builder: (context, state) => Nav(
              child: const PreviousTestsPage(),
              currentIndex: 0,
            ),
          ),
          GoRoute(
            path: 'waiting_page',
            builder: (context, state) {
              final BluetoothDevice device = state.extra as BluetoothDevice;
              return Nav(
                child: WaitingPage(device: device),
                currentIndex: 0,
              );
            },
          ),
          GoRoute(
            path: 'new_test1',
            builder: (context, state) {
              final BluetoothDevice device = state.extra as BluetoothDevice;
              return Nav(
                child: NewTestPage1(device: device),
                currentIndex: 0,
              );
            },
          ),
        ],
      ),
      // Feed Page
      GoRoute(
          path: '/feed',
          builder: (context, state) => Nav(
                child: const FeedPage(),
                currentIndex: 1,
              ),
          routes: [
            GoRoute(
              path: 'previous_tests',
              builder: (context, state) => Nav(
                child: const PreviousTestsPage(),
                currentIndex: 0,
              ),
            ),
            // GoRoute(
            //   path: 'blog_details',
            //   builder: (context, state) => Nav(
            //     child: BlogDetailsPage(blogPost: state.extra as BlogPost),
            //     currentIndex: 1,
            //   ),
            // ),
          ]),
      // Profile Page
      GoRoute(
        path: '/profile',
        builder: (context, state) => Nav(
          child: const ProfilePage(),
          currentIndex: 2,
        ),
        routes: [
          GoRoute(
            path: 'new_test',
            builder: (context, state) => Nav(
              child: const NewTestPage(),
              currentIndex: 0,
            ),
          ),
          GoRoute(
            path: 'previous_tests',
            builder: (context, state) => Nav(
              child: const PreviousTestsPage(),
              currentIndex: 0,
            ),
          ),
          GoRoute(
            path: 'new_test1',
            builder: (context, state) {
              final BluetoothDevice device = state.extra as BluetoothDevice;
              return Nav(
                child: NewTestPage1(device: device),
                currentIndex: 0,
              );
            },
          ),
          GoRoute(
            path: 'waiting_page',
            builder: (context, state) {
              final BluetoothDevice device = state.extra as BluetoothDevice;
              return Nav(
                child: WaitingPage(device: device),
                currentIndex: 0,
              );
            },
          ),
        ],
      ),
      // Bluetooth Scan Page
      GoRoute(
        path: '/bluetooth_scan',
        builder: (context, state) => Nav(
          child: const BluetoothScan(),
          currentIndex: 0,
        ),
      ),
      // Device Details Page
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final BluetoothDevice device = state.extra as BluetoothDevice;
          return Nav(
            child: DetailPage(server: device),
            currentIndex: 0,
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Cholera Alert',
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
