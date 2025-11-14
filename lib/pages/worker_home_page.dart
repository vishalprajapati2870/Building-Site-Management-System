import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/globals/auth_provider.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:building_site_build_by_vishal/pages/login_page.dart';
import 'package:building_site_build_by_vishal/models/assignment_model.dart';
import 'package:building_site_build_by_vishal/models/site_model.dart';
import 'package:building_site_build_by_vishal/components/assignment_card.dart';
import 'package:building_site_build_by_vishal/models/time_log_model.dart';
import 'package:building_site_build_by_vishal/models/user_model.dart';

@NowaGenerated()
class WorkerHomePage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() {
    return _WorkerHomePageState();
  }
}

@NowaGenerated()
class _WorkerHomePageState extends State<WorkerHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = AuthProvider.of(context, listen: true);
    final dataProvider = DataProvider.of(context, listen: true);
    final List<Widget> pages = [
      _AssignmentsTab(workerId: authProvider.currentUser?.id ?? ''),
      _HistoryTab(workerId: authProvider.currentUser?.id ?? ''),
      const _ProfileTab(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('SiteGuard Worker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

@NowaGenerated()
class _AssignmentsTab extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const _AssignmentsTab({required this.workerId, super.key});

  final String workerId;

  @override
  State<_AssignmentsTab> createState() => __AssignmentsTabState();
}

@NowaGenerated()
class __AssignmentsTabState extends State<_AssignmentsTab> {
  List<AssignmentModel> _todayAssignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    final dataProvider = DataProvider.of(context, listen: false);
    final assignments = await dataProvider.getTodayAssignments(widget.workerId);
    if (mounted) {
      setState(() {
        _todayAssignments = assignments;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = DataProvider.of(context, listen: true);
    return RefreshIndicator(
      onRefresh: _loadAssignments,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todayAssignments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_late_outlined,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No assignments for today',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later or contact your manager',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _todayAssignments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final assignment = _todayAssignments[index];
                final site = dataProvider.getSiteById(assignment.siteId);
                return AssignmentCard(
                  assignment: assignment,
                  siteName: site?.name ?? 'Unknown Site',
                  siteAddress: site?.address ?? '',
                );
              },
            ),
    );
  }
}

@NowaGenerated()
class _HistoryTab extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const _HistoryTab({required this.workerId, super.key});

  final String workerId;

  @override
  Widget build(BuildContext context) {
    final dataProvider = DataProvider.of(context, listen: true);
    final timeLogs = dataProvider.timeLogs
        .where((log) => log.workerId == workerId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return timeLogs.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No history yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: timeLogs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final log = timeLogs[index];
              final isCheckIn = log.type == 'checkin';
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCheckIn
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isCheckIn ? Icons.login : Icons.logout,
                          color: isCheckIn ? Colors.green : Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCheckIn ? 'Check In' : 'Check Out',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year} at ${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (log.serverValidated)
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 20,
                        )
                      else
                        const Icon(
                          Icons.pending,
                          color: Colors.orange,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

@NowaGenerated()
class _ProfileTab extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const _ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = AuthProvider.of(context, listen: true);
    final user = authProvider.currentUser;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.name ?? 'Worker',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 32),
          if (user?.skills != null && user!.skills!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skills',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user!.skills!
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          if (user?.hourlyRate != null)
            ListTile(
              leading: Icon(
                Icons.attach_money,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Hourly Rate'),
              trailing: Text(
                '\$${user?.hourlyRate?.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          const SizedBox(height: 16),
          if (user?.createdAt != null)
            ListTile(
              leading: Icon(
                Icons.calendar_today_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Member Since'),
              subtitle: Text(
                '${user!.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
        ],
      ),
    );
  }
}
