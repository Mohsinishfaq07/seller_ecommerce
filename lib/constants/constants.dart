import 'package:flutter_application_1/functions/global_functions.dart';
import 'package:flutter_application_1/providers/auth_provider/auth_provider.dart';
import 'package:flutter_application_1/providers/category_provider/upload_provider.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';
import 'package:flutter_application_1/services/firestore/firestore_services.dart';

// functions
GlobalFunctions globalFunctions = GlobalFunctions();

// providers
AuthProvider authProvider = AuthProvider();
UploadCategoryProvider uploadCategoryProvider = UploadCategoryProvider();
// services
FirestoreService firestoreService = FirestoreService();
AuthServices authServices = AuthServices();
