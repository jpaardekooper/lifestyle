import 'package:lifestylescreening/models/interest_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/repositories/interest_repository_interface.dart';

class InterestRepository extends IInterestRepository {
  @override
  Future<List<InterestModel>> getInterestList() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('interests')
        // .where('published', isEqualTo: 1)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return InterestModel.fromSnapshot(doc);
    }).toList();
  }
}
