# Fix Product Loading in ProductBloc

The issue where products are not loading is caused by the empty event handlers in `ProductBloc`. Additionally, there is a naming conflict and duplication between `product_bloc.dart` and `product_event.dart`.

## Proposed Changes

### [Product BLoC Component]

#### [MODIFY] [product_bloc.dart](file:///C:/Users/ELCOT/kishal-stylish/lib/bloc/product/product_bloc.dart)
- Remove duplicate event definitions (`ProductEvent`, `FetchProducts`, etc.).
- Import `product_event.dart`.
- Implement `_fetchProducts`, `_loadMoreProducts`, `_refreshProducts`, `_searchProducts`, `_filterProducts`, and `_sortProducts` using the `ProductRepository`.
- Maintain pagination state (page, limit) within the event handlers or the BLoC state if needed.

#### [MODIFY] [main.dart](file:///C:/Users/ELCOT/kishal-stylish/lib/main.dart)
- Remove the `hide FetchProducts` from the `product_event.dart` import once the duplication is resolved.

## Verification Plan

### Manual Verification
- Run the app and verify that the products are loaded on the home screen.
- Verify that searching, filtering, and sorting products work as expected.
- Verify that loading more products works when scrolling.
