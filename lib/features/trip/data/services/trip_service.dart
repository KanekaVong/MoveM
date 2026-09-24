import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../dto/request/create_trip_request.dart';
import 'package:flutter/foundation.dart';
import '../dto/request/update_trip_request.dart';

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

  Future<Response> addChecklist(
      String activityId,
      String itemName,
      ) async {
    return await dio.post(
      'tasks/$activityId/checklists',
      data: {
        'itemName': itemName,
      },
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
      'tasks/checklists/$checklistId/complete',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<Response> updateChecklist(
      int checklistId,
      String itemName,
      ) async {
    return await dio.put(
      'tasks/$checklistId/checklists',
      data: {
        'id': checklistId,
        'itemName': itemName,
      },
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

}