# TODO: Add Search Filtering Options

## 1. Update Search Model
- [ ] Add Location class and location field to SearchUser in search_model.dart

## 2. Update Search Controller
- [ ] Add filterType RxString in SearchFilterController
- [ ] Modify performSearch to handle different filter types with client-side filtering for location and age

## 3. Update Dashboard View
- [ ] Add filter selector dropdown UI above search bar
- [ ] Update search bar hint text dynamically based on filter type
- [ ] Update search results display to show relevant info (location for location filter, age for others)

## 4. Testing
- [ ] Test search functionality with different filters (name, location, age)
