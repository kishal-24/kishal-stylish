const double kShippingFee = 30.0;

double calculateSubtotal(List<Map<String, dynamic>> items) {
  double total = 0.0;

  for (final item in items) {
    final dynamic priceValue = item['price'];
    final int quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

    double itemPrice = 0.0;
    if (priceValue is num) {
      itemPrice = priceValue.toDouble();
    } else {
      final sanitized =
          priceValue
              ?.toString()
              .replaceAll('₹', '')
              .replaceAll(',', '')
              .trim() ??
          '0';
      itemPrice = double.tryParse(sanitized) ?? 0.0;
    }

    total += itemPrice * quantity;
  }

  return total;
}

double calculateShipping(double subtotal) {
  return subtotal > 0 ? kShippingFee : 0.0;
}

double calculateGrandTotal(double subtotal) {
  return subtotal + calculateShipping(subtotal);
}

double calculateOrderTotal(List<Map<String, dynamic>> items) {
  final subtotal = calculateSubtotal(items);
  return calculateGrandTotal(subtotal);
}
