import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:building_site_build_by_vishal/models/time_log_model.dart';
import 'package:building_site_build_by_vishal/models/site_model.dart';

@NowaGenerated()
class ReportsPage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() {
    return _ReportsPageState();
  }
}

@NowaGenerated()
class _ReportsPageState extends State<ReportsPage> {
  DateTime _selectedDate = DateTime.now();

  String _selectedPeriod = 'Daily';
  
  List<TimeLogModel> _filteredTimeLogs = [];
  
  @override
  void initState() {
    super.initState();
    _updateFilteredData();
  }
  
  void _updateFilteredData() {
    final dataProvider = DataProvider.of(context, listen: false);
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;
    
    if (_selectedPeriod == 'Daily') {
      startDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      endDate = startDate.add(const Duration(days: 1));
    } else if (_selectedPeriod == 'Weekly') {
      final weekStart = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      startDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
      endDate = startDate.add(const Duration(days: 7));
    } else { // Monthly
      startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
      endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    }
    
    _filteredTimeLogs = dataProvider.timeLogs.where((log) {
      return log.timestamp.isAfter(startDate) && log.timestamp.isBefore(endDate);
    }).toList();
    
    setState(() {});
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked!;
      });
      _updateFilteredData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = DataProvider.of(context, listen: true);
    // Update filtered data when timeLogs change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateFilteredData();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export feature coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: _selectDate,
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bar_chart,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedPeriod,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: ['Daily', 'Weekly', 'Monthly']
                                .map(
                                  (period) => DropdownMenuItem(
                                    value: period,
                                    child: Text(period),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPeriod = value!;
                              });
                              _updateFilteredData();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Overview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Total Hours',
                    value: _calculateTotalHours().toStringAsFixed(1),
                    unit: 'hrs',
                    icon: Icons.access_time,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    title: 'Workers',
                    value: _getUniqueWorkersCount().toString(),
                    unit: 'active',
                    icon: Icons.people,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Sites',
                    value: _getUniqueSitesCount().toString(),
                    unit: 'active',
                    icon: Icons.location_city,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    title: 'Check-ins',
                    value: _filteredTimeLogs.where((log) => log.type == 'checkin').length.toString(),
                    unit: _selectedPeriod.toLowerCase(),
                    icon: Icons.check_circle,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_filteredTimeLogs.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 64,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No activity data for selected period',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredTimeLogs.length > 5
                    ? 5
                    : _filteredTimeLogs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = _filteredTimeLogs[index];
                  final site = dataProvider.getSiteById(log.siteId);
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: log.type == 'checkin'
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.orange.withValues(alpha: 0.2),
                        child: Icon(
                          log.type == 'checkin' ? Icons.login : Icons.logout,
                          color: log.type == 'checkin'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      title: Text(
                        site?.name ?? 'Unknown Site',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${log.timestamp.day}/${log.timestamp.month} at ${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: Icon(
                        log.serverValidated ? Icons.verified : Icons.pending,
                        color:
                            log.serverValidated ? Colors.green : Colors.orange,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
  
  double _calculateTotalHours() {
    final checkIns = <String, DateTime>{};
    final checkOuts = <String, DateTime>{};
    
    for (final log in _filteredTimeLogs) {
      if (log.type == 'checkin') {
        checkIns[log.workerId] = log.timestamp;
      } else if (log.type == 'checkout') {
        checkOuts[log.workerId] = log.timestamp;
      }
    }
    
    double totalHours = 0;
    for (final entry in checkIns.entries) {
      final checkout = checkOuts[entry.key];
      if (checkout != null) {
        final duration = checkout.difference(entry.value);
        totalHours += duration.inMinutes / 60.0;
      }
    }
    
    return totalHours;
  }
  
  int _getUniqueWorkersCount() {
    return _filteredTimeLogs.map((log) => log.workerId).toSet().length;
  }
  
  int _getUniqueSitesCount() {
    return _filteredTimeLogs.map((log) => log.siteId).toSet().length;
  }
}

@NowaGenerated()
class _MetricCard extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  final String title;

  final String value;

  final String unit;

  final IconData icon;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
