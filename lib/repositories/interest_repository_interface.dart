import 'package:lifestylescreening/models/interest_model.dart';

abstract class IInterestRepository {
  Future<List<InterestModel>> getInterestList();
}
