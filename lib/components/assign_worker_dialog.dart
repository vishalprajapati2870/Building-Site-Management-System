import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/globals/auth_provider.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:building_site_build_by_vishal/models/assignment_model.dart';

@NowaGenerated()
class AssignWorkerDialog extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const AssignWorkerDialog({required this.siteId, super.key});

  final String siteId;

  @override
  State<AssignWorkerDialog> createState() {
    return _AssignWorkerDialogState();
  }
}

@NowaGenerated()
class _AssignWorkerDialogState extends State<AssignWorkerDialog> {
  String? _selectedWorkerId;

  DateTime _startTime = DateTime.now();

  DateTime _endTime = DateTime.now().add(const Duration(hours: 8));

  Future<void> _handleAssign() async {
    if (_selectedWorkerId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a worker')));
      return;
    }
    
    final authProvider = AuthProvider.of(context, listen: false);
    final dataProvider = DataProvider.of(context, listen: false);
    
    // Check if worker is already assigned
    final firebaseService = dataProvider.firebaseService;
    final isAlreadyAssigned = await firebaseService.isWorkerAlreadyAssigned(
      widget.siteId,
      _selectedWorkerId!,
      _startTime,
      _endTime,
    );
    
    if (isAlreadyAssigned) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This worker is already assigned to this site during the selected time period'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }
    
    final assignment = AssignmentModel(
      id: 'assignment_${DateTime.now().millisecondsSinceEpoch}',
      siteId: widget.siteId,
      workerId: _selectedWorkerId!,
      assignedBy: authProvider.currentUser!.id!,
      startTime: _startTime,
      endTime: _endTime,
      status: 'pending',
      createdAt: DateTime.now(),
    );
    
    await dataProvider.addAssignment(assignment);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Worker assigned successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = DataProvider.of(context, listen: true);
    return AlertDialog(
      title: const Text('Assign Worker'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Worker',
                border: OutlineInputBorder(),
              ),
              items: dataProvider.workers
                  .map(
                    (worker) => DropdownMenuItem(
                      value: worker.id,
                      child: Text(worker.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWorkerId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('Start Time'),
              subtitle: Text(
                '${_startTime.hour}:${_startTime.minute.toString().padLeft(2, '0')}',
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_startTime),
                );
                if (time != null) {
                  setState(() {
                    _startTime = DateTime(
                      _startTime.year,
                      _startTime.month,
                      _startTime.day,
                      time!.hour,
                      time!.minute,
                    );
                  });
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('End Time'),
              subtitle: Text(
                '${_endTime.hour}:${_endTime.minute.toString().padLeft(2, '0')}',
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_endTime),
                );
                if (time != null) {
                  setState(() {
                    _endTime = DateTime(
                      _endTime.year,
                      _endTime.month,
                      _endTime.day,
                      time!.hour,
                      time!.minute,
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _handleAssign, child: const Text('Assign')),
      ],
    );
  }
}
