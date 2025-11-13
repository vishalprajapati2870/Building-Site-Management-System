import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/globals/auth_provider.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:building_site_build_by_vishal/models/site_model.dart';

@NowaGenerated()
class AddSitePage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const AddSitePage({super.key});

  @override
  State<AddSitePage> createState() {
    return _AddSitePageState();
  }
}

@NowaGenerated()
class _AddSitePageState extends State<AddSitePage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _latController = TextEditingController();

  final TextEditingController _lngController = TextEditingController();

  final TextEditingController _radiusController = TextEditingController(
    text: '100',
  );

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_nameController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _latController.text.trim().isEmpty ||
        _lngController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = AuthProvider.of(context, listen: false);
      final dataProvider = DataProvider.of(context, listen: false);
      final site = SiteModel(
        id: 'site_${DateTime.now().millisecondsSinceEpoch}',
        ownerId: authProvider.currentUser!.id!,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        lat: double.parse(_latController.text.trim()),
        lng: double.parse(_lngController.text.trim()),
        geofenceRadiusMeters: double.parse(_radiusController.text.trim()),
        createdAt: DateTime.now(),
        isActive: true,
      );
      dataProvider.addSite(site);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Site created successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Site')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Create a new construction site with geofencing',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Site Name *',
                hintText: 'e.g., Downtown Construction',
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address *',
                hintText: '123 Main St, City',
                prefixIcon: const Icon(Icons.place),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Text(
              'GPS Coordinates',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Latitude *',
                      hintText: '37.7749',
                      prefixIcon: const Icon(Icons.my_location),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _lngController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Longitude *',
                      hintText: '-122.4194',
                      prefixIcon: const Icon(Icons.explore),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _radiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Geofence Radius (meters)',
                hintText: '100',
                prefixIcon: const Icon(Icons.radar),
                suffixText: 'm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Workers must be within this distance to check in',
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create Site', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
