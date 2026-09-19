import 'package:flutter_test/flutter_test.dart';

import 'package:stylish/utils/order_total.dart';

void main() {
  test('order total adds shipping once for buy-now checkout', () {
    final items = [
      {'price': 200.0, 'quantity': 2},
      {'price': 50.0, 'quantity': 1},
    ];

    final subtotal = calculateSubtotal(items);

    expect(subtotal, 450.0);
    expect(calculateShipping(subtotal), 30.0);
    expect(calculateOrderTotal(items), 480.0);
    expect(calculateGrandTotal(subtotal), 480.0);
  });
}
