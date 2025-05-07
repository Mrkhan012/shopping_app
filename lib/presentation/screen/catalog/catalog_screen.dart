import 'package:ecommerce/core/utils/app_text_styles.dart';
import 'package:ecommerce/core/utils/colros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/product_providers.dart';
import '../../widgets/product_tile.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  bool isLoading = true; // Loading state flag
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

    searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        backgroundColor: kDefaultBlueColor,
        foregroundColor: Colors.white,
        title: const Text('Catalog'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      style: const TextStyle(color: kAppBrightWhiteColor), 

                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      labelStyle: const TextStyle(color: kAppBrightWhiteColor),
                      hintStyle: const TextStyle(color: kAppBrightWhiteColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon:
                          const Icon(Icons.search, color: kAppBrightWhiteColor),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list,
                      color: kAppBrightWhiteColor),
                  onPressed: () => _showFilterSheet(context, ref),
                )
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : filteredProducts.isEmpty
              ? Center(
                  child: Text(
                    'No products found',
                    style: AppTextStyles.subtitle.copyWith(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (_, index) =>
                      ProductTile(product: filteredProducts[index]),
                ),
    );
  }

 void _showFilterSheet(BuildContext context, WidgetRef ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final range = ref.watch(priceRangeProvider);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Filter by Category", style: AppTextStyles.title),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [ 'Clothing', 'Electronics', 'Accessories']
                      .map((cat) {
                    return ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (_) {
                        ref.read(selectedCategoryProvider.notifier).state = cat;
                        setModalState(() {}); // Refresh bottom sheet UI
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text("Price Range", style: AppTextStyles.title),
                RangeSlider(
                  values: range,
                  min: 100,
                  max: 10000,
                  divisions: 100,
                  labels: RangeLabels(
                    '₹${range.start.round()}',
                    '₹${range.end.round()}',
                  ),
                  onChanged: (val) {
                    ref.read(priceRangeProvider.notifier).state = val;
                    setModalState(() {}); // Refresh bottom sheet UI immediately
                  },
                ),
                const SizedBox(height: 10),
                Text('₹${range.start.round()} - ₹${range.end.round()}'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.clear),
                      label: const Text("Clear"),
                      onPressed: () {
                        ref.invalidate(searchQueryProvider);
                        ref.invalidate(selectedCategoryProvider);
                        ref.read(priceRangeProvider.notifier).state =
                            const RangeValues(100, 10000);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Apply"),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
    },
  );
}
}