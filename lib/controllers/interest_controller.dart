import 'package:lifestylescreening/models/interest_model.dart';
import 'package:lifestylescreening/repositories/interest_repository.dart';
import 'package:lifestylescreening/repositories/interest_repository_interface.dart';

class InterestController {
  final IInterestRepository _interestRepository = InterestRepository();

  Future<List<InterestModel>> streamSurveys() {
    return _interestRepository.getInterestList();
  }
}
