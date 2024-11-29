import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/logic/cubit/product/product_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedConnectorType;
  String? selectedChargerType;
  String? activeFilterCategory = 'Connector Type';

  final connectorTypes = ['Single', 'Dual'];
  final chargerTypes = ['AC', 'DC'];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  // Load filters from SharedPreferences
  Future<void> _loadFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedConnectorType = prefs.getString('connectorType');
      selectedChargerType = prefs.getString('chargerType');
    });
  }

  // Save selected filters to SharedPreferences
  Future<void> _saveFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('connectorType', selectedConnectorType ?? '');
    prefs.setString('chargerType', selectedChargerType ?? '');
  }

  // Clear selected filters and reset the active category
  void _clearFilters() {
    setState(() {
      selectedConnectorType = null;
      selectedChargerType = null;
      activeFilterCategory = 'Connector Type';
    });
    context.read<ProductCubit>().fetchAllProducts();
    _clearSavedFilters();
  }

  // Remove filters from SharedPreferences
  Future<void> _clearSavedFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('connectorType');
    prefs.remove('chargerType');
  }

  // Get the filter count for each category
  String _getFilterCount(String filterType) {
    if (filterType == 'Connector Type') {
      return selectedConnectorType != null ? '(1)' : '';
    } else if (filterType == 'Charger Type') {
      return selectedChargerType != null ? '(1)' : '';
    }
    return '';
  }

  // Build the filter category list
  Widget _buildFilterCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...['Connector Type', 'Charger Type'].map(
              (category) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildFilterCategoryItem(category),
          ),
        ),
      ],
    );
  }

  // Build individual filter category list item
  Widget _buildFilterCategoryItem(String category) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      tileColor: activeFilterCategory == category
          ? Colors.blue.shade100
          : Colors.white,
      title: Text(
        '$category ${_getFilterCount(category)}',
        style: const TextStyle(fontSize: 15),
      ),
      onTap: () {
        setState(() {
          activeFilterCategory = category;
        });
      },
    );
  }

  // Build the filter options based on selected category
  Widget _buildFilterOptions() {
    final options = activeFilterCategory == 'Connector Type'
        ? connectorTypes
        : chargerTypes;

    final selectedValue = activeFilterCategory == 'Connector Type'
        ? selectedConnectorType
        : selectedChargerType;

    return Column(
      children: options.map((type) {
        return RadioListTile<String>(
          title: Text(type),
          value: type,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              if (activeFilterCategory == 'Connector Type') {
                selectedConnectorType = value;
              } else {
                selectedChargerType = value;
              }
            });
            _saveFilters();
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter Products',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20.0), // Height of the divider
          child: Divider(
            thickness: 1,
            color: Colors.grey, // Divider color
          ),
        ),
      ),

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter categories
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: const Color(0xFFB0C4DE),
              child: _buildFilterCategoryList(),
            ),
          ),
          // Vertical divider
          const VerticalDivider(thickness: 1, width: 20),
          // Filter options
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeFilterCategory ?? '',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  _buildFilterOptions(),
                ],
              ),
            ),
          ),
        ],
      ),
      // Apply filters button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.read<ProductCubit>().fetchProducts(
                connectorType: selectedConnectorType,
                chargerType: selectedChargerType,
              );
              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
        ),
      ),
    );
  }
}
