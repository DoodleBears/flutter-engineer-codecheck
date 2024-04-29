import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemExpansionProvider =
    StateNotifierProvider<ItemExpansionNotifier, List<bool>>((ref) {
  return ItemExpansionNotifier();
});

class ItemExpansionNotifier extends StateNotifier<List<bool>> {
  ItemExpansionNotifier() : super([]);

  void toggleExpansion(int index) {
    if (index < state.length) {
      state = List<bool>.from(state)..[index] = !state[index];
    }
  }

  void initializeExpansions(int count) {
    state = List<bool>.filled(count, false);
  }

  void extendExpansions(int additionalCount) {
    state = List<bool>.from(state)
      ..addAll(List<bool>.filled(additionalCount, false));
  }
}
