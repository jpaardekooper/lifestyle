import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/goals_model.dart';
import 'package:lifestylescreening/repositories/goals_repository_interface.dart';

class GoalsRepository extends IGoalsRepository {
  @override
  Future<List<GoalsModel>> getGoalsList() async {
    var snapshot = await FirebaseFirestore.instance.collection('goals').get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return GoalsModel.fromSnapshot(doc);
    }).toList();
  }
}
