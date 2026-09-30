import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../dto/request/create_trip_request.dart';
import 'package:flutter/foundation.dart';
import '../dto/request/update_trip_request.dart';
import '../dto/request/trip_budget_request.dart';
import '../dto/request/trip_expense_request.dart';
import '../dto/request/trip_expense_split_request.dart';

class TripService {
  final Dio dio = DioClient().dio;

  Future<Response> getMyTrips() async {
    return await dio.get(
      'trips',
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> getTripDetail(String activityId) async {
    return await dio.get(
      'trips/$activityId',
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> createTrip(CreateTripRequest request) async {
    debugPrint('CREATE TRIP REQUEST:');
    debugPrint(request.toJson().toString());

    return await dio.post(
      'trips',
      data: request.toJson(),
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> deleteTrip(String activityId) async {
    return await dio.delete(
      'trips/$activityId',
    );
  }

  Future<Response> addTripStop(
      String activityId,
      Map<String, dynamic> request,
      ) async {
    return await dio.post(
      'trips/$activityId/stops',
      data: request,
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> updateTripStop(
      String activityId,
      int stopId,
      Map<String, dynamic> request,
      ) async {
    return await dio.put(
      'trips/$activityId/stops/$stopId',
      data: request,
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> deleteTripStop(
      String activityId,
      int stopId,
      ) async {
    return await dio.delete(
      'trips/$activityId/stops/$stopId',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> reorderStops(
      String activityId,
      List<int> stopIds,
      ) async {
    return await dio.put(
      'trips/$activityId/stops/reorder',
      data: {
        'stopIds': stopIds,
      },
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> getPackingItems(
      String activityId,
      ) async {
    return await dio.get(
      'trips/$activityId/packing-items',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> addPackingItem(
      String activityId,
      String itemName,
      ) async {
    return await dio.post(
      'trips/$activityId/packing-items',
      data: {
        'itemName': itemName,
      },
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> togglePackingItem(
      String activityId,
      int itemId,
      ) async {
    return await dio.patch(
      'trips/$activityId/packing-items/$itemId/toggle',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> deletePackingItem(
      String activityId,
      int itemId,
      ) async {
    return await dio.delete(
      '/trips/$activityId/packing-items/$itemId',
    );
  }

  Future<Response> addChecklist(
      String activityId,
      String itemName,
      ) async {
    return await dio.post(
      'shared/$activityId/checklists',
      data: {
        'itemName': itemName,
      },
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> getChecklists(
      String activityId,
      ) async {
    return await dio.get(
      'tasks/$activityId/checklists',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> completeChecklist(
      int checklistId,
      ) async {
    return await dio.patch(
      'shared/checklists/$checklistId/complete',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> deleteChecklist(
      String activityId,
      int checklistId,
      ) async {
    return await dio.delete(
      'shared/$activityId/checklists/$checklistId',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> updateChecklist(
      String activityId,
      int checklistId,
      Map<String, dynamic> request,
      ) async {
    return await dio.put(
      'shared/$activityId/checklists/$checklistId',
      data: request,
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }


  Future<Response> getAttachments(
      String activityId,
      ) async {
    return await dio.get(
      'trips/$activityId/attachments',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> uploadAttachment(
      String activityId,
      MultipartFile file,
      ) async {
    final formData = FormData.fromMap({
      'file': file,
    });

    return await dio.post(
      'trips/$activityId/attachments',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> getCoverPhoto(
      String activityId,
      ) async {
    return await dio.get(
      'trips/$activityId/cover-photo',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> uploadCoverPhoto(
      String activityId,
      MultipartFile file,
      ) async {
    final formData = FormData.fromMap({
      'file': file,
    });

    return await dio.post(
      'trips/$activityId/cover-photo',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> getTripMembers(
      String activityId,
      ) async {
    return await dio.get(
      'groups/$activityId/members',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> getPendingInvites(
      String activityId,
      ) async {
    return await dio.get(
      'groups/$activityId/pending-invites',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> inviteTripMember(
      String activityId,
      String identifier,
      ) async {
    return await dio.post(
      'groups/$activityId/invite',
      data: {
        'identifier': identifier,
      },
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> removeTripMember(
      String activityId,
      int memberId,
      ) async {
    return await dio.delete(
      'groups/$activityId/members/$memberId',
    );
  }

  Future<Response> updateTrip(
      String activityId,
      UpdateTripRequest request,
      ) async {
    return await dio.put(
      'trips/$activityId',
      data: request.toJson(),
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> getTripRoute(
      String activityId, {
        String travelMode = 'DRIVING',
      }) async {
    return await dio.get(
      'trips/$activityId/route',
      queryParameters: {
        'travelMode': travelMode,
      },
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> updateTripBudget(
      String activityId,
      int budgetId,
      TripBudgetRequest request,
      ) async {
    return await dio.put(
      'trips/$activityId/budgets/$budgetId',
      data: request.toJson(),
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> createTripExpense(
      String activityId,
      TripExpenseRequest request,
      ) async {
    return await dio.post(
      'trips/$activityId/expenses',
      data: request.toJson(),
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> getTripExpenses(String activityId) async {
    return await dio.get(
      'trips/$activityId/expenses',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> deleteTripExpense(
      String activityId,
      int expenseId,
      ) async {
    return await dio.delete(
      'trips/$activityId/expenses/$expenseId',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> createExpenseSplits(
      String activityId,
      String tripActivityId,
      int expenseId,
      TripExpenseSplitRequest request,
      ) async {
    return await dio.post(
      'trips/$activityId/$tripActivityId/expenses/$expenseId/splits',
      data: request.toJson(),
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> settleExpenseSplit(
      String activityId,
      int expenseId,
      int splitId,
      ) async {
    return await dio.patch(
      'trips/$activityId/expenses/$expenseId/splits/$splitId/settle',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

}