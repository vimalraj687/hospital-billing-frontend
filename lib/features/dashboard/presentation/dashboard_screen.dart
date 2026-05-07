import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth_provider.dart';

// dashboard
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final size = MediaQuery.of(context).size;

    int crossAxisCount = 3;

    if (size.width < 600) {
      crossAxisCount = 1;
    } else if (size.width < 900) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff4f7fb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(
                10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade700,
                    Colors.indigo.shade800,
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  14,
                ),
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Hospital Dashboard',
              style: TextStyle(
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: TextButton.icon(
              icon: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
              ),
              onPressed: () {
                ref
                    .read(
                      authProvider.notifier,
                    )
                    .logout();
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HERO SECTION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(
              40,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade800,
                  Colors.indigo.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Manage patients, billing, reports and hospital operations easily.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(
                      0.85,
                    ),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // DASHBOARD CARDS
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                32,
              ),
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: size.width < 600 ? 2.0 : 1.15,
                children: [
                  _buildCard(
                    context: context,
                    title: 'Patients',
                    subtitle: 'Manage patient records and profiles',
                    icon: Icons.people_outline,
                    color: Colors.blue,
                  ),
                  _buildCard(
                    context: context,
                    title: 'Billing',
                    subtitle: 'Invoices, payments and transactions',
                    icon: Icons.receipt_long_outlined,
                    color: Colors.green,
                  ),
                  _buildCard(
                    context: context,
                    title: 'Reports',
                    subtitle: 'Analytics and hospital insights',
                    icon: Icons.bar_chart_outlined,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required MaterialColor color,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.shade50.withOpacity(
                0.35,
              ),
            ],
          ),
          borderRadius: BorderRadius.circular(
            30,
          ),
          border: Border.all(
            color: color.shade100,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(
                0.08,
              ),
              blurRadius: 24,
              spreadRadius: 1,
              offset: const Offset(
                0,
                10,
              ),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(
                0.9,
              ),
              blurRadius: 10,
              offset: const Offset(
                -4,
                -4,
              ),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              30,
            ),
            splashColor: color.withOpacity(
              0.08,
            ),
            hoverColor: color.withOpacity(
              0.04,
            ),
            onTap: () {
              if (title == 'Patients') {
                context.go(
                  '/patients',
                );
              } else if (title == 'Billing') {
                context.go(
                  '/bills',
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(
                28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                          18,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.shade400,
                              color.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            22,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(
                                0.25,
                              ),
                              blurRadius: 18,
                              offset: const Offset(
                                0,
                                8,
                              ),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: color.shade50,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Open',
                              style: TextStyle(
                                color: color.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: color.shade700,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // TITLE
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      color: Colors.grey[900],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // SUBTITLE
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // BOTTOM BAR
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 18,
                          color: color.shade700,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            'Secure hospital management system',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
