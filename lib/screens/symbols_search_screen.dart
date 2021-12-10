import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:invest_analize/controllers/search_controller.dart';
import 'package:invest_analize/widgets/symbol_widget.dart';

class SymbolsSearchScreen extends SearchDelegate {
  final controller = SearchController();
  @override
  ThemeData appBarTheme(BuildContext context) => Get.theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900],
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(14),
            ),
          ),
        ),
      );
  @override
  String? get searchFieldLabel => 'Buscar';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Obx(() => AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              width: 15,
              padding: const EdgeInsets.all(4),
              child: controller.isLooking.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),
            ),
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.query(query);
    return _buildList();
  }

  Obx _buildList() {
    return Obx(
      () => Stack(
        children: [
          ListView.builder(
            controller: controller.scrolController,
            padding: const EdgeInsets.only(
              top: 18,
              bottom: 90,
            ),
            itemCount: controller.symbols.length,
            itemBuilder: (context, index) => SymbolWidget(
              onTap: () =>
                  controller.openStockScreen(controller.symbols[index]),
              symbol: controller.symbols[index],
            ),
          ),
          _buildFloatingActionButton()
        ],
      ),
    );
  }

  Positioned _buildFloatingActionButton() {
    return Positioned(
      right: 8,
      bottom: 18,
      child: Obx(
        () => Visibility(
          visible: controller.isScrollButtonVisible.value,
          child: FloatingActionButton(
            child: const Icon(
              Icons.arrow_upward,
            ),
            onPressed: controller.scrollToTop,
          ),
        ),
      ),
    );
  }
}
