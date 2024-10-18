import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_request_cycle_web/models/request_cycle.dart';

class RequestCycleService {
  String collection = 'requestCycle';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  Future<RequestCycleModel?> selectData(String id) async {
    RequestCycleModel? ret;
    await firestore.collection(collection).doc(id).get().then((value) {
      ret = RequestCycleModel.fromSnapshot(value);
    });
    return ret;
  }
}
