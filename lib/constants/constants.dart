import 'package:flutter_application_1/functions/global_functions.dart';
import 'package:flutter_application_1/providers/category_provider/upload_provider.dart';
import 'package:flutter_application_1/providers/chat_provider/chat_provider.dart';
import 'package:flutter_application_1/providers/sell_provider/seller_provider.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';
import 'package:flutter_application_1/services/chat_service/chat_service.dart';
import 'package:flutter_application_1/services/firestore/firestore_services.dart';

// functions
GlobalFunctions globalFunctions = GlobalFunctions();

// providers
// AuthProvider authProvider = AuthProvider();
UploadCategoryProvider uploadCategoryProvider = UploadCategoryProvider();
SellerProvider sellerProvider = SellerProvider();

ChatProvider chatProvider = ChatProvider();
// services
FirestoreService firestoreService = FirestoreService();
AuthServices authServices = AuthServices();
ChatService chatService = ChatService();
