import 'package:lifestylescreening/models/goals_model.dart';

abstract class IGoalsRepository {
  Future<List<GoalsModel>> getGoalsList();
}
