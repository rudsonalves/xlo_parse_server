# xlo_parse_server

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


[ParseException.ErrorCode Enumeration](https://parseplatform.org/Parse-SDK-dotNET/api/html/T_Parse_ParseException_ErrorCode.htm)


# ChangeLog

## 2024/07/18 - version: 0.3.4+10

Add enhancements and refactor filter and home functionalities

1. lib/common/models/filter.dart
   - Imported `foundation.dart` for `listEquals`.
   - Added `minPrice` and `maxPrice` to `FilterModel`.
   - Modified the constructor to initialize `state`, `city`, `sortBy`, `advertiser`, `mechanicsId`, `minPrice`, and `maxPrice` with default values.
   - Added `isEmpty` getter to check if the filter is empty.
   - Overrode `toString`, `==`, and `hashCode` to include `minPrice` and `maxPrice`.

2. lib/components/custon_field_controllers/currency_text_controller.dart
   - Added `decimalDigits` parameter to control the number of decimal places.
   - Updated `_formatter` to use `currency` instead of `simpleCurrency`.
   - Updated `_applyMask` and `currencyValue` methods to use `_getDivisionFactor`.
   - Added `_getDivisionFactor` method to calculate the division factor based on `decimalDigits`.

3. lib/features/filters/filters_controller.dart
   - Imported `filter.dart` and `currency_text_controller.dart`.
   - Added `minPriceController` and `maxPriceController` for handling price input.
   - Updated `init` method to accept an optional `FilterModel`.
   - Added `setInitialValues` method to set initial values for the filter.
   - Updated `submitState` and `submitCity` methods to handle exceptions.
   - Updated `mechUpdateNames` method to use `_joinMechNames`.
   - Removed unnecessary log statements.

4. lib/features/filters/filters_screen.dart
   - Updated constructor to accept a `FilterModel`.
   - Updated `initState` to call `ctrl.init` with the provided filter.
   - Updated `_sendFilter` method to use `ctrl.filter`.
   - Added UI components for min and max price input.
   - Added validation for price range.

5. lib/features/filters/widgets/text_form_dropdown.dart
   - Added `focusNode` parameter to `TextFormDropdown`.

6. lib/features/home/home_controller.dart
   - Removed unused methods and properties related to mechanics.

7. lib/features/home/home_screen.dart
   - Updated the filter button to pass the current filter to the `FiltersScreen`.
   - Removed mechanics-related UI components.

8. lib/features/new_address/new_address_screen.dart
   - Removed commented-out code.

9. lib/my_material_app.dart
   - Updated `onGenerateRoute` to pass the `FilterModel` to the `FiltersScreen`.

10. lib/features/filters/filters_screen.dart
    - Enhanced the `FiltersScreen` UI to include new fields for price range filtering.
    - Added input validation for the price range to ensure logical consistency between min and max prices.
    - Adjusted the `FilterModel` handling to accommodate new fields and ensure existing filter states are preserved during navigation and state changes.

11. lib/features/home/home_controller.dart
    - Simplified the `HomeController` by removing mechanics-related methods and properties, focusing it solely on managing the home screen state.

12. lib/features/home/home_screen.dart
    - Enhanced the filter button functionality to display the current filter state.
    - Simplified the UI by removing mechanics-related buttons, focusing the user interface on the primary filtering functionality.

13. lib/features/new_address/new_address_screen.dart
    - Cleaned up the code by removing commented-out lines, ensuring a cleaner and more maintainable codebase.

14. lib/my_material_app.dart
    - Updated the routing logic to correctly pass and handle `FilterModel` instances when navigating to the `FiltersScreen`.
    - Included additional logging for debugging purposes, ensuring better traceability of filter state throughout the application.

These updates collectively enhance the app's structure and overall architecture, improve user experience through better search and filter functionalities, and maintain consistency across the application codebase. The changes reflect ongoing efforts to provide robust and user-friendly features while ensuring a clean, maintainable, and high-performance application.


## 2024/07/22 - version: 0.3.3+9

Add functionalities and general refactorings

1. Added Makefile:
   - Commands to manage Docker (`docker_up` and `docker_down`).
   - Commands for Flutter clean (`flutter_clean`).
   - Commands for Git operations (`git_cached`, `git_commit`, and `git_push`).

2. Added `FilterModel` in `lib/common/models/filter.dart`:
   - Modeling filters for advertisements.

3. Refactored file and class names:
   - Renamed `lib/common/models/uf.dart` to `lib/common/models/state.dart` and updated class name from `UFModel` to `StateBrModel`.

4. Added `SearchHistory` singleton in `lib/common/singletons/search_history.dart`:
   - Manages search history with SharedPreferences.

5. Added `TextStyles` in `lib/common/theme/text_styles.dart`:
   - Defined common text styles for the application.

6. Updated `advert_screen.dart`:
   - Removed unnecessary logging.
   - Integrated new state management for advertisement creation.

7. Enhanced `BaseController` and `BaseScreen`:
   - Added search functionality and integrated `SearchDialog`.

8. Added `SearchDialogController` and `SearchDialog` widget:
   - Manages search functionality and history display.

9. Added `FiltersController` and `FiltersScreen`:
   - Allows filtering advertisements by location, sorting, and mechanics.

10. Updated `mechanics_manager.dart`:
    - Added methods to retrieve mechanics names by IDs.

11. General updates and bug fixes:
    - Improved state handling and UI updates.
    - Refactored method names for clarity and consistency.

12. Updated `pubspec.yaml` version to 0.3.2+8.

13. Updated `home_screen.dart`:
    - Integrated `HomeController` for state management.
    - Added segmented buttons for mechanics and filter selection.
    - Implemented navigation to `MecanicsScreen` and `FiltersScreen`.

14. Added `home_controller.dart` and `home_state.dart`:
    - Managed home screen state and mechanics selection.

15. Updated `main.dart`:
    - Initialized `SearchHistory` during app startup.

16. Updated `state_manager.dart`:
    - Renamed methods and classes to match updated state model.

17. Updated `my_material_app.dart`:
    - Added route for `FiltersScreen`.

18. Updated `ibge_repository.dart`:
    - Renamed methods and updated to use `StateBrModel`.

19. Added tests for `IbgeRepository` in `ibge_repository_test.dart`:
    - Ensured correct functionality for state and city retrieval.

20. Refactored `home_screen.dart`:
    - Integrated `HomeController` for managing the state.
    - Added segmented buttons for mechanics and filter selection.
    - Implemented navigation to `MecanicsScreen` and `FiltersScreen`.

21. Added `home_controller.dart` and `home_state.dart`:
    - Managed the state of the home screen.
    - Provided functionality for mechanics selection and updating the view based on the selected mechanics.

22. Updated `main.dart`:
    - Initialized `SearchHistory` during app startup to ensure search functionality is ready when the app launches.

23. Updated `state_manager.dart`:
    - Renamed methods and classes to align with the updated state model, enhancing code readability and consistency.

24. Updated `my_material_app.dart`:
    - Added a route for `FiltersScreen` to integrate the new filter functionality into the app's navigation.

25. Updated `ibge_repository.dart`:
    - Renamed methods to use `StateBrModel` instead of the previous `UFModel`, ensuring consistency with the updated data models.

26. Added tests for `IbgeRepository` in `ibge_repository_test.dart`:
    - Ensured the correct functionality for state and city retrieval, verifying that the refactored code behaves as expected.

27. Refactored `mechanics_manager.dart`:
    - Added methods `nameFromId` and `namesFromIdList` for retrieving mechanic names based on their IDs.
    - Enhanced functionality to manage and retrieve mechanic names, aiding in cleaner code and improved readability.

28. Added `text_styles.dart`:
    - Defined a centralized `TextStyles` class to manage text styles across the app.
    - Simplified text styling management and ensured consistency in text appearance.

29. Added `search_controller.dart` and `search_dialog.dart`:
    - Implemented a custom search controller and dialog for managing search history and suggestions.
    - Enhanced the search experience by providing users with a history of previous searches and suggestions based on input.

30. Refactored `advert_screen.dart`:
    - Removed redundant log statements for a cleaner codebase.
    - Ensured better readability and maintainability of the code.

31. Refactored `base_controller.dart` and `base_screen.dart`:
    - Integrated search functionality into the base screen.
    - Improved navigation and state management within the base screen.

32. Refactored `filters_controller.dart` and `filters_screen.dart`:
    - Enhanced filters management with improved state handling.
    - Provided a user-friendly interface for selecting filters and mechanics.

33. Updated `Makefile`:
    - Added common commands for Docker, Flutter, and Git operations.
    - Simplified development workflows by providing reusable Makefile commands.

34. Updated `pubspec.yaml`:
    - Bumped the version to `0.3.2+8` to reflect the new features and improvements.
    - Ensured dependencies are up to date, supporting the latest features and bug fixes.

35. Added `home_controller.dart` and `home_screen.dart`:
    - Introduced a home controller to manage the state and interactions on the home screen.
    - Implemented UI elements to allow users to filter and select mechanics easily.
    - Enhanced user experience by providing a more interactive and responsive home screen.

36. Added `filters_states.dart`:
    - Defined states for the filters feature to manage loading, success, and error states.
    - Improved state management, making the filters feature more robust and easier to maintain.

37. Added `search_dialog_bar.dart` and `search_dialog_search_bar.dart`:
    - Provided additional search dialog implementations for various UI scenarios.
    - Enhanced search functionality with better UI integration and user experience.

38. Updated `state_manager.dart`:
    - Refactored to use `StateBrModel` instead of `UFModel`.
    - Improved clarity and consistency in naming conventions.

39. Updated `ibge_repository.dart`:
    - Refactored methods to align with the new state model naming conventions.
    - Ensured consistency and clarity in data retrieval methods.

40. Refactored `my_material_app.dart`:
    - Added route for the new `FiltersScreen`.
    - Improved navigation and ensured all new screens are accessible.

41. Updated `ibge_repository_test.dart`:
    - Refactored tests to align with the new `StateBrModel`.
    - Ensured tests remain up-to-date and cover the new functionality.

42. Added `text_styles.dart`:
    - Introduced a centralized file for text styles to ensure consistency across the app.
    - Made it easier to manage and update text styles in one place.

43. Updated `Makefile`:
    - Added commands for Docker operations (`docker_up`, `docker_down`), Flutter operations (`flutter_clean`), and Git operations (`git_cached`, `git_commit`, `git_push`).
    - Simplified and automated common development tasks, improving developer productivity.

44. Updated `search_history.dart`:
    - Implemented a singleton pattern for managing search history.
    - Added methods to save and retrieve search history using `SharedPreferences`.
    - Enhanced search functionality by providing users with suggestions based on their search history.

45. Updated `advert_screen.dart`:
    - Removed unnecessary imports and log statements.
    - Improved readability and maintainability of the code.

46. Updated `base_controller.dart`:
    - Added constants for page titles and methods to manage page navigation and search functionality.
    - Improved the controller's responsibility to manage state and UI updates more effectively.

47. Updated `base_screen.dart`:
    - Introduced a method for handling search dialog interactions.
    - Enhanced the app bar to dynamically display the search bar or title based on the current page.
    - Improved user experience by integrating a search functionality directly into the app bar.

48. Updated `home_screen.dart`:
    - Added segmented buttons for mechanics and filter selection.
    - Integrated new mechanics and filter selection features into the home screen.

49. Updated `mechanics_manager.dart`:
    - Added methods to retrieve mechanic names by their IDs.
    - Improved data handling for mechanics, making it easier to work with mechanic-related data.

50. Updated `state_manager.dart`:
    - Continued to refine state management by ensuring alignment with the new state model.

51. Updated `main.dart`:
    - Added initialization for the `SearchHistory` singleton.
    - Ensured all necessary initializations are done before the app runs.

52. Incremented `pubspec.yaml` version to 0.3.2+8:
    - Reflecting all the changes and additions made in this update cycle.

This commit encompasses multiple additions and refactorings across the project to enhance functionality, improve code clarity, and manage state more effectively. These changes improve the overall structure, enhance user experience with better search and filter functionalities, and maintain consistency across the application. These updates further improve the app's maintainability, performance, and user experience, ensuring that the app remains robust and user-friendly. The comprehensive updates aim to improve the app’s overall architecture, enhance user experience, and maintain a clean and maintainable codebase. The addition of new models, controllers, and screens reflects ongoing efforts to provide robust and user-friendly features. These updates continue to improve the app’s structure, usability, and developer experience by refining existing features, introducing new functionalities, and ensuring consistency across the codebase.


## 2024/07/18 - version: 0.3.1+7

feat: Refactor and enhance advertisement and mechanic modules

- **lib/common/models/category.dart** to **lib/common/models/mechanic.dart**
  - Renamed `CategoryModel` to `MechanicModel`.

- **lib/components/custon_field_controllers/currency_text_controller.dart**
  - Added `currencyValue` getter to parse the text into a double.

- **lib/features/advertisement/advert_controller.dart**
  - Replaced `CategoryModel` with `MechanicModel`.
  - Added `AdvertState` for state management.
  - Added methods to handle state changes and error handling.

- **lib/features/advertisement/advert_screen.dart**
  - Updated to reflect new state management.
  - Added navigation to `BaseScreen` upon successful ad creation.

- **lib/features/advertisement/advert_state.dart** (new)
  - Added state classes for advertisement management.

- **lib/features/advertisement/widgets/advert_form.dart**
  - Updated to use `selectedMechIds` for mechanics selection.

- **lib/features/base/base_screen.dart**
  - Updated navigation to `AdvertScreen` reflecting new changes.

- **lib/features/mecanics/mecanics_screen.dart**
  - Replaced `categories` with `mechanics`.
  - Updated route name and method names to reflect mechanics instead of categories.

- **lib/manager/mechanics_manager.dart**
  - Replaced `CategoryModel` with `MechanicModel`.

- **lib/repository/advert_repository.dart**
  - Renamed variables to reflect advertisement context.
  - Updated methods to handle the new advert model.

- **lib/repository/constants.dart**
  - Updated constants to reflect advertisement context.

- **lib/repository/mechanic_repository.dart**
  - Renamed methods to reflect mechanics context.

- **pubspec.yaml & pubspec.lock**
  - Updated dependencies versions.
  - Bumped project version to `0.3.1+7`.

- **lib/features/new_address/** (new)
  - **new_address_controller.dart**: Added new address management logic, including form validation and fetching address data from ViaCEP.
  - **new_address_screen.dart**: Created new screen for managing new addresses, including saving and validating address information.
  - **new_address_state.dart**: Added state classes for new address management.
  - **widgets/address_form.dart**: Added new address form for input fields related to address management.

- **lib/features/address/address_controller.dart**
  - Moved logic related to address state management to `AddressManager`.
  - Simplified the controller to delegate address operations to `AddressManager`.

- **lib/features/address/address_screen.dart**
  - Updated screen to utilize `AddressManager` for fetching and managing addresses.
  - Added buttons for adding and removing addresses.

- **lib/manager/address_manager.dart** (new)
  - Added a manager for handling address operations, including saving, deleting, and fetching addresses.
  - Included methods to check for duplicate address names and manage address lists.

These changes collectively refactor the existing advertisement and address modules, introduce better state management, improve the mechanics handling, and streamline address-related operations. Additionally, it includes new features and improvements for handling advertisements and mechanics.


## 2024/07/18 - version: 0.3.0+6

feat: Implement address management with AddressManager and new address screens

- **lib/common/singletons/current_user.dart**
  - Replaced `AddressRepository` with `AddressManager` for managing addresses.
  - Removed `_loadAddresses` method, added `addressByName` and `saveAddress` methods.

- **lib/features/address/address_controller.dart**
  - Simplified `AddressController` to delegate address management to `AddressManager`.
  - Removed form state and validation logic, focusing on address selection and removal.

- **lib/features/address/address_screen.dart**
  - Updated to use new `NewAddressScreen` for adding addresses.
  - Added floating action buttons for adding and removing addresses.

- **lib/features/advertisement/advert_controller.dart**
  - Updated to use `CurrentUser.addressByName` for selecting addresses.

- **lib/features/advertisement/widgets/advert_form.dart**
  - Updated address selection to use `CurrentUser.addressByName`.

- **lib/features/new_address/new_address_controller.dart** (new)
  - Added new controller for managing new address form state and validation.

- **lib/features/new_address/new_address_screen.dart** (new)
  - Added new screen for adding and editing addresses.
  - Integrated `NewAddressController` for form management and submission.

- **lib/features/address/address_state.dart** (renamed to `new_address_state.dart`)
  - Renamed and updated states to be used by `NewAddressController`.

- **lib/features/address/widgets/address_form.dart** (renamed to `new_address/widgets/address_form.dart`)
  - Updated to use `NewAddressController` for form state management.

- **lib/manager/address_manager.dart** (new)
  - Added new manager for handling address CRUD operations and caching.
  - Implemented methods for saving, deleting, and fetching addresses.

- **lib/my_material_app.dart**
  - Added route for `NewAddressScreen`.
  - Updated `onGenerateRoute` to handle new address route.

- **lib/repository/address_repository.dart**
  - Simplified `saveAddress` method.
  - Added `delete` method for removing addresses.
  - Updated error handling and logging.

- **lib/repository/constants.dart**
  - Updated `keyAddressTable` to `'Addresses'`.

This commit message provides a detailed breakdown of changes made to each file, highlighting the specific updates and improvements in the address management system.


## 2024/07/18 - version: 0.2.3+5

feat: Implement new features for address management and validation

- **lib/common/models/address.dart**
  - Added `operator ==` and `hashCode` methods to `AddressModel` for better address comparison and management.

- **lib/common/singletons/current_user.dart**
  - Updated to load addresses and provide access to address names.
  - Improved logic for address initialization and retrieval.

- **lib/common/validators/validators.dart**
  - Added `AddressValidator` for validating various address fields.
  - Enhanced `Validator.zipCode` to clean and validate the zip code correctly.

- **lib/components/form_fields/custom_form_field.dart**
  - Added `textCapitalization` property to `CustomFormField`.

- **lib/components/form_fields/dropdown_form_field.dart**
  - Added `textCapitalization` and `onSelected` properties to `DropdownFormField`.

- **lib/features/advertisement/widgets/advert_form.dart**
  - Added `textCapitalization` property to `AdvertForm`.

- **lib/features/address/address_controller.dart**
  - Enhanced `AddressController` to manage addresses more efficiently.
  - Added methods for validation and setting the form from addresses.
  - Included `zipFocus` to manage focus on the zip code field.

- **lib/features/address/address_screen.dart**
  - Updated `AddressScreen` to validate and save addresses upon leaving the screen.
  - Integrated `PopScope` to handle back navigation and save address changes.

- **lib/features/address/widgets/address_form.dart**
  - Updated `AddressForm` to use `AddressValidator`.
  - Added logic to initialize address types from `CurrentUser`.

- **lib/features/advertisement/advertisement_controller.dart**
  - Renamed `AdvertisementController` to `AdvertController`.
  - Updated methods for address handling and validation.

- **lib/features/advertisement/advertisement_screen.dart**
  - Renamed `AdvertisementScreen` to `AdvertScreen`.

- **lib/features/advertisement/widgets/advertisement_form.dart**
  - Renamed `AdvertisementForm` to `AdvertForm`.
  - Updated address selection logic.

- **lib/features/advertisement/widgets/image_list_view.dart**
  - Updated to use `AdvertController` instead of `AdvertisementController`.

- **lib/features/base/base_screen.dart**
  - Updated route for `AdvertScreen`.

- **lib/features/mecanics/mecanics_screen.dart**
  - Updated `MecanicsScreen` to handle null descriptions gracefully.

- **lib/my_material_app.dart**
  - Updated routes to use `AdvertScreen`.

- **lib/repository/ad_repository.dart**
  - Renamed `AdRepository` to `AdvertRepository`.

- **lib/repository/address_repository.dart**
  - Enhanced `saveAddress` method to handle address name uniqueness per user.
  - Added `_getAddressByName` to fetch addresses by name.
  - Improved error handling and logging.

- **lib/repository/constants.dart**
  - Updated `keyAddressTable` to `'Addresses'`.

This commit message provides a detailed breakdown of changes made to each file, highlighting the specific updates and improvements.


## 2024/07/17 - version: 0.2.2+4

feat: Implement new features for address management, category handling, and insert functionality

- **lib/common/models/address.dart**
  - Added `operator ==` and `hashCode` methods to `AddressModel` for better address management.

- **lib/common/singletons/current_user.dart**
  - Updated to load addresses and provide access to address names.

- **lib/common/validators/validators.dart**
  - Added `AddressValidator` for validating various address fields.
  - Improved `Validator.zipCode` to clean and validate the zip code correctly.

- **lib/components/form_fields/custom_form_field.dart**
  - Added `textCapitalization` property to `CustomFormField`.

- **lib/components/form_fields/dropdown_form_field.dart**
  - Added `textCapitalization` and `onSelected` properties to `DropdownFormField`.

- **lib/features/address/address_controller.dart**
  - Enhanced `AddressController` to manage addresses more efficiently.
  - Added methods for validation and setting the form from addresses.
  - Added `zipFocus` to manage focus on the zip code field.

- **lib/features/address/address_screen.dart**
  - Updated `AddressScreen` to validate and save addresses upon leaving the screen.
  - Included `PopScope` to handle back navigation.

- **lib/features/address/widgets/address_form.dart**
  - Updated `AddressForm` to use `AddressValidator`.
  - Added logic to initialize address types from `CurrentUser`.

- **lib/features/advertisement/advertisement_controller.dart**
  - Renamed `AdvertisementController` to `AdvertController`.
  - Updated methods for address handling and validation.

- **lib/features/advertisement/advertisement_screen.dart**
  - Renamed `AdvertisementScreen` to `AdvertScreen`.

- **lib/features/advertisement/widgets/advertisement_form.dart**
  - Renamed `AdvertisementForm` to `AdvertForm`.
  - Updated address selection logic.

- **lib/features/advertisement/widgets/image_list_view.dart**
  - Updated to use `AdvertController` instead of `AdvertisementController`.

- **lib/features/base/base_screen.dart**
  - Updated route for `AdvertScreen`.

- **lib/features/mecanics/mecanics_screen.dart**
  - Updated `MecanicsScreen` to handle null descriptions gracefully.

- **lib/my_material_app.dart**
  - Updated routes to use `AdvertScreen`.

- **lib/repository/ad_repository.dart**
  - Renamed `AdRepository` to `AdvertRepository`.

- **lib/repository/address_repository.dart**
  - Enhanced `saveAddress` method to handle address name uniqueness per user.
  - Added `_getAddressByName` to fetch addresses by name.
  - Improved error handling and logging.

- **lib/repository/constants.dart**
  - Updated `keyAddressTable` to `'Addresses'`.

This commit message provides a detailed breakdown of changes made to each file, highlighting the specific updates and improvements.


## 2024/07/17 - version: 0.2.1+3:

feat: Address management updates and enhancements

This commit introduces several new features and updates to address management within the application. Key changes include:

- Added unique name verification for addresses per user.
- Implemented logic to handle address creation and updates.
- Enhanced error handling and response validation.
- Included additional model fields for address details.

Detailed Changes:
- lib/common/models/address.dart: Added new model for addresses.
- lib/common/models/category.dart: Renamed CategoryModel to MechanicModel.
- lib/common/models/city.dart: Added new model for city information.
- lib/common/models/uf.dart: Added new model for state information.
- lib/common/models/user.dart: Updated user model with address-related fields.
- lib/common/models/viacep_address.dart: Added model for ViaCEP address information.
- lib/common/singletons/app_settings.dart: Adjusted settings for address handling.
- lib/common/singletons/current_user.dart: Added singleton for current user with address information.
- lib/common/validators/validators.dart: Added validation rules for address fields.
- lib/components/buttons/big_button.dart: Added focus node for address input.
- lib/components/custom_drawer/custom_drawer.dart: Integrated current user for address display.
- lib/components/custom_drawer/widgets/custom_drawer_header.dart: Updated drawer header with address info.
- lib/components/form_fields/custom_form_field.dart: Added new fields for address input.
- lib/components/others_widgets/custom_input_formatter.dart: Added custom input formatter for address fields.
- lib/features/address/address_controller.dart: Added controller for address management.
- lib/features/address/address_screen.dart: Added screen for address input and display.
- lib/features/address/address_state.dart: Added state management for address operations.
- lib/features/insert/insert_controller.dart: Enhanced insert functionality with address handling.
- lib/features/insert/insert_screen.dart: Updated insert screen with address fields.
- lib/features/insert/widgets/image_gallery.dart: Renamed to horizontal_image_gallery.dart.
- lib/features/insert/widgets/insert_form.dart: Integrated address fields into insert form.
- lib/features/login/login_controller.dart: Integrated address handling in login process.
- lib/features/mecanics/mecanics_screen.dart: Added screen for mechanics selection.
- lib/main.dart: Integrated address management on app startup.
- lib/manager/mechanics_manager.dart: Added manager for mechanics data.
- lib/manager/uf_manager.dart: Added manager for state data.
- lib/my_material_app.dart: Updated material app with new routes and address handling.
- lib/repository/address_repository.dart: Added repository for address data handling.
- lib/repository/constants.dart: Updated constants for address fields.
- lib/repository/ibge_repository.dart: Added repository for state and city data.
- lib/repository/mechanic_repository.dart: Renamed from category_repository and updated for mechanics data.
- lib/repository/user_repository.dart: Updated user repository with address handling.
- lib/repository/viacep_repository.dart: Added repository for ViaCEP data.
- pubspec.yaml: Added dependencies for address management.
- test/repository/ibge_repository_test.dart: Added tests for IBGE repository.

This commit significantly enhances the application's ability to manage user addresses, providing a robust framework for address-related data and operations.



## 2024/07/12 - version: 0.2.0+2:

feat: Implemented new features for address management, category handling, and insert functionality

This commit introduces several new features and updates, including address management, category handling, and enhancements to the insert functionality. It also includes modifications to existing models and components to support the new functionality.


Detailed Changes:

- lib/common/models/address.dart:
  - Created a new `AddressModel` to handle address-related data.
  - Implemented methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Added a `toString` method for debugging and logging purposes.

- lib/common/models/category.dart:
  - Renamed `CategoryModel` to `MechanicModel`.
  - Updated class references to reflect the new name.

- lib/common/models/city.dart:
  - Created a new `CityModel` to represent city data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Added a `toString` method for debugging and logging purposes.

- lib/common/models/uf.dart:
  - Created `RegionModel` and `UFModel` to represent region and state data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Added `toString` methods for debugging and logging purposes.

- lib/common/models/user.dart:
  - Added serialization and deserialization methods (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Implemented a `copyFromUserModel` method for cloning user instances.

- lib/common/models/viacep_address.dart:
  - Created a new `ViaCEPAddressModel` to handle address data from the ViaCEP API.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Added a `toString` method for debugging and logging purposes.

- lib/common/singletons/app_settings.dart:
  - Removed user-related properties and methods to simplify the singleton class.

- lib/common/singletons/current_user.dart:
  - Created a new `CurrentUser` singleton to manage the current user and their address.
  - Included methods for initializing and loading user and address data (`init`, `_loadUserAndAddress`).

- lib/common/validators/validators.dart:
  - Added new validators for form fields (`title`, `description`, `mechanics`, `address`, `zipCode`, `cust`).

- lib/components/buttons/big_button.dart:
  - Added `focusNode` property to manage focus state for the button.

- lib/components/custom_drawer/custom_drawer.dart:
  - Updated to use `CurrentUser` for login status checks.

- lib/components/custom_drawer/widgets/custom_drawer_header.dart:
  - Updated to use `CurrentUser` for displaying user information.

- lib/components/form_fields/custom_form_field.dart:
  - Added `readOnly`, `suffixIcon`, and `errorText` properties to enhance form field functionality.

- lib/components/others_widgets/custom_input_formatter.dart:
  - Created a new `CustomInputFormatter` to format text input based on a provided mask.

- lib/features/address/address_controller.dart:
  - Created a new `AddressController` to manage address-related state and logic.
  - Implemented methods for handling address retrieval and saving (`getAddress`, `saveAddressFrom`, `_checkZipCodeReady`).

- lib/features/address/address_screen.dart:
  - Created a new `AddressScreen` to provide a UI for managing user addresses.
  - Integrated with `AddressController` to handle form submission and state changes.

- lib/features/address/address_state.dart:
  - Defined different states for address-related operations (`AddressStateInitial`, `AddressStateLoading`, `AddressStateSuccess`, `AddressStateError`).

- lib/common/models/address.dart:
  - Created `AddressModel` to manage address-related data.
  - Implemented methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/category.dart:
  - Renamed `CategoryModel` to `MechanicModel`.
  - Updated class references to reflect the new name.

- lib/common/models/city.dart:
  - Created `CityModel` to represent city data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/uf.dart:
  - Created `RegionModel` and `UFModel` to represent region and state data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/user.dart:
  - Added serialization and deserialization methods (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Implemented a `copyFromUserModel` method for cloning user instances.

- lib/common/models/viacep_address.dart:
  - Created `ViaCEPAddressModel` to handle address data from the ViaCEP API.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/singletons/app_settings.dart:
  - Removed user-related properties and methods to simplify the singleton class.

- lib/common/singletons/current_user.dart:
  - Created a new `CurrentUser` singleton to manage the current user and their address.
  - Included methods for initializing and loading user and address data (`init`, `_loadUserAndAddress`).

- lib/common/validators/validators.dart:
  - Added new validators for form fields (`title`, `description`, `mechanics`, `address`, `zipCode`, `cust`).

- lib/components/buttons/big_button.dart:
  - Added `focusNode` property to manage focus state for the button.

- lib/components/custom_drawer/custom_drawer.dart:
  - Updated to use `CurrentUser` for login status checks.

- lib/components/custom_drawer/widgets/custom_drawer_header.dart:
  - Updated to use `CurrentUser` for displaying user information.

- lib/components/form_fields/custom_form_field.dart:
  - Added `readOnly`, `suffixIcon`, and `errorText` properties to enhance form field functionality.

- lib/components/others_widgets/custom_input_formatter.dart:
  - Created a new `CustomInputFormatter` to format text input based on a provided mask.

- lib/features/address/address_controller.dart:
  - Created a new `AddressController` to manage address-related state and logic.
  - Implemented methods for handling address retrieval and saving (`getAddress`, `saveAddressFrom`, `_checkZipCodeReady`).

- lib/features/address/address_screen.dart:
  - Created a new `AddressScreen` to provide a UI for managing user addresses.
  - Integrated with `AddressController` to handle form submission and state changes.

- lib/features/address/address_state.dart:
  - Defined different states for address-related operations (`AddressStateInitial`, `AddressStateLoading`, `AddressStateSuccess`, `AddressStateError`).

- lib/features/insert/insert_controller.dart:
  - Enhanced `InsertController` with new methods and properties for managing categories and images.
  - Added methods for form validation (`formValidate`) and managing selected categories (`getCategoriesIds`).

- lib/features/insert/insert_screen.dart:
  - Updated to initialize address data from `CurrentUser`.
  - Added logic for handling form submission (`_createAnnounce`).

- lib/features/insert/widgets/horizontal_image_gallery.dart:
  - Renamed from `image_gallery.dart`.
  - Updated widget structure to handle horizontal image gallery.

- lib/features/insert/widgets/insert_form.dart:
  - Enhanced to include additional fields and validation logic.
  - Integrated navigation for adding mechanics and addresses.

- lib/features/login/login_controller.dart:
  - Updated to use `CurrentUser` for managing login state.

- lib/features/mecanics/mecanics_screen.dart:
  - Created a new `MecanicsScreen` to handle mechanic selection.

- lib/main.dart:
  - Updated main entry point to initialize `CurrentUser` and other managers.
  - Added new routes for address and mechanic screens.

- lib/manager/mechanics_manager.dart:
  - Created `MechanicsManager` to manage mechanic data.
  - Implemented methods for initialization and data retrieval.

- lib/manager/uf_manager.dart:
  - Created `UFManager` to manage state (UF) data.
  - Implemented methods for initialization and data retrieval.

- lib/my_material_app.dart:
  - Added new routes for address and mechanic screens.
  - Updated to support dynamic route generation for mechanic screen.

- lib/repository/address_repository.dart:
  - Created `AddressRepository` to manage address-related data operations.
  - Implemented methods for saving and retrieving address data from both local storage and the server.

- lib/repository/constants.dart:
  - Updated constants to support new address and mechanic data models.

- lib/repository/ibge_repository.dart:
  - Created `IbgeRepository` to manage data retrieval from the IBGE API.
  - Implemented methods for retrieving state and city data.

- lib/repository/mechanic_repository.dart:
  - Renamed from `category_repositories.dart`.
  - Updated to support new mechanic data model.


- lib/common/models/address.dart:
  - Created `AddressModel` to manage address-related data.
  - Implemented methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/category.dart:
  - Renamed `CategoryModel` to `MechanicModel`.
  - Updated class references to reflect the new name.

- lib/common/models/city.dart:
  - Created `CityModel` to represent city data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/uf.dart:
  - Created `RegionModel` and `UFModel` to represent region and state data.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/models/user.dart:
  - Added serialization and deserialization methods (`toMap`, `fromMap`, `toJson`, `fromJson`).
  - Implemented a `copyFromUserModel` method for cloning user instances.

- lib/common/models/viacep_address.dart:
  - Created `ViaCEPAddressModel` to handle address data from the ViaCEP API.
  - Included methods for serialization and deserialization (`toMap`, `fromMap`, `toJson`, `fromJson`).

- lib/common/singletons/app_settings.dart:
  - Removed user-related properties and methods to simplify the singleton class.

- lib/common/singletons/current_user.dart:
  - Created a new `CurrentUser` singleton to manage the current user and their address.
  - Included methods for initializing and loading user and address data (`init`, `_loadUserAndAddress`).

- lib/common/validators/validators.dart:
  - Added new validators for form fields (`title`, `description`, `mechanics`, `address`, `zipCode`, `cust`).

- lib/components/buttons/big_button.dart:
  - Added `focusNode` property to manage focus state for the button.

- lib/components/custom_drawer/custom_drawer.dart:
  - Updated to use `CurrentUser` for login status checks.

- lib/components/custom_drawer/widgets/custom_drawer_header.dart:
  - Updated to use `CurrentUser` for displaying user information.

- lib/components/form_fields/custom_form_field.dart:
  - Added `readOnly`, `suffixIcon`, and `errorText` properties to enhance form field functionality.

- lib/components/others_widgets/custom_input_formatter.dart:
  - Created a new `CustomInputFormatter` to format text input based on a provided mask.

- lib/features/address/address_controller.dart:
  - Created a new `AddressController` to manage address-related state and logic.
  - Implemented methods for handling address retrieval and saving (`getAddress`, `saveAddressFrom`, `_checkZipCodeReady`).

- lib/features/address/address_screen.dart:
  - Created a new `AddressScreen` to provide a UI for managing user addresses.
  - Integrated with `AddressController` to handle form submission and state changes.

- lib/features/address/address_state.dart:
  - Defined different states for address-related operations (`AddressStateInitial`, `AddressStateLoading`, `AddressStateSuccess`, `AddressStateError`).

- lib/features/insert/insert_controller.dart:
  - Enhanced `InsertController` with new methods and properties for managing categories and images.
  - Added methods for form validation (`formValidate`) and managing selected categories (`getCategoriesIds`).

- lib/features/insert/insert_screen.dart:
  - Updated to initialize address data from `CurrentUser`.
  - Added logic for handling form submission (`_createAnnounce`).

- lib/features/insert/widgets/horizontal_image_gallery.dart:
  - Renamed from `image_gallery.dart`.
  - Updated widget structure to handle horizontal image gallery.

- lib/features/insert/widgets/insert_form.dart:
  - Enhanced to include additional fields and validation logic.
  - Integrated navigation for adding mechanics and addresses.

- lib/features/login/login_controller.dart:
  - Updated to use `CurrentUser` for managing login state.

- lib/features/mecanics/mecanics_screen.dart:
  - Created a new `MecanicsScreen` to handle mechanic selection.

- lib/main.dart:
  - Updated main entry point to initialize `CurrentUser` and other managers.
  - Added new routes for address and mechanic screens.

- lib/manager/mechanics_manager.dart:
  - Created `MechanicsManager` to manage mechanic data.
  - Implemented methods for initialization and data retrieval.

- lib/manager/uf_manager.dart:
  - Created `UFManager` to manage state (UF) data.
  - Implemented methods for initialization and data retrieval.

- lib/my_material_app.dart:
  - Added new routes for address and mechanic screens.
  - Updated to support dynamic route generation for mechanic screen.

- lib/repository/address_repository.dart:
  - Created `AddressRepository` to manage address-related data operations.
  - Implemented methods for saving and retrieving address data from both local storage and the server.

- lib/repository/constants.dart:
  - Updated constants to support new address and mechanic data models.

- lib/repository/ibge_repository.dart:
  - Created `IbgeRepository` to manage data retrieval from the IBGE API.
  - Implemented methods for retrieving state and city data.

- lib/repository/mechanic_repository.dart:
  - Renamed from `category_repositories.dart`.
  - Updated to support new mechanic data model.

- lib/repository/user_repository.dart:
  - Updated to use correct generic types for getting user attributes.

- lib/repository/viacep_repository.dart:
  - Created `ViacepRepository` to handle address data retrieval from ViaCEP API.
  - Implemented methods for fetching address data based on CEP (postal code).

- pubspec.yaml:
  - Added new dependencies for `http` and `shared_preferences` to support address and data handling.

- test/repository/ibge_repository_test.dart:
  - Added tests for `IbgeRepository` to ensure correct data retrieval from IBGE API.

This commit significantly enhances the application's ability to manage user addresses, categories, and insert functionalities, providing a robust framework for address-related data and operations.


## 2024/07/12 - version: 0.1.0+1:

Implemented InsertForm widget, updated dependencies, and made platform-specific changes

This commit introduces a new InsertForm widget, updates various project dependencies, and includes necessary platform-specific changes to ensure compatibility and functionality.

Detailed Changes:

- lib/ui/form/insert_form.dart:
  - Created a new stateful widget `InsertForm` to handle user inputs.
  - Added `InsertController` as a required parameter for managing form data.
  - Implemented `CustomFormField` components for title and description inputs with `labelText`, `fullBorder`, and `floatingLabelBehavior` properties.
  - Added a `DropdownButtonFormField` for category selection with predefined items.
  - Included a `ValueNotifier<bool>` named `hidePhone` to manage the visibility of the phone number input.
  - Overridden the `dispose` method to properly dispose of the `ValueNotifier`.

- pubspec.yaml:
  - Added `intl: ^0.19.0` for internationalization support.
  - Added `image_picker: ^1.1.2` to enable image selection from the device.
  - Added `image_cropper: ^4.0.1` for cropping images.

- lib/common/models/category.dart:
  - Defined a Category model to encapsulate the data structure and provide methods for handling category-related data.

- lib/components/custom_drawer/custom_drawer.dart:
  - Developed a CustomDrawer widget to standardize the navigation drawer across the application.
  - Included links to major sections such as Home, Insert, and Settings.

- lib/components/form_fields/custom_form_field.dart:
  - Created a reusable CustomFormField widget to ensure consistent styling and functionality across all form fields.

- lib/controllers/insert_controller.dart:
  - Implemented the InsertController class to manage form state and business logic, ensuring separation of concerns and easier testing.

- lib/main.dart:
  - Main entry point updated to include routing and integration for the new InsertForm functionality.

- lib/screens/home_screen.dart:
  - Added navigation logic to transition from the HomeScreen to the new InsertScreen.

- lib/screens/insert_screen.dart:
  - Created InsertScreen to host the InsertForm widget, integrating it into the application's navigation flow.

- lib/services/file_service.dart:
  - Implemented FileService to abstract file operations such as picking and cropping images, leveraging image_picker and image_cropper plugins.

- lib/utilities/constants.dart:
  - Updated constants to support new form and file handling features, ensuring consistent usage across the application.

- windows/flutter/generated_plugin_registrant.cc:
  - Registered `FileSelectorWindows` plugin to handle file selection on Windows.

This commit enhances the form handling capabilities of the application by introducing a new, robust InsertForm widget. It also extends the app's functionality by adding new dependencies for internationalization and image handling. The platform-specific changes ensure that these features are fully supported on Windows, providing a consistent and seamless user experience across different environments.
