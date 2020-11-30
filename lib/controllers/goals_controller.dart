import 'package:lifestylescreening/models/goals_model.dart';
import 'package:lifestylescreening/repositories/goals_repository.dart';
import 'package:lifestylescreening/repositories/goals_repository_interface.dart';

class GoalsController {
  final IGoalsRepository _goalsRepository = GoalsRepository();

  Future<List<GoalsModel>> getGoalsList() {
    return _goalsRepository.getGoalsList();
  }
}
