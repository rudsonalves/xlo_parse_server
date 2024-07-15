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
