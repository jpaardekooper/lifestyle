
import 'package:lifestylescreening/models/tags_model.dart';
import 'package:lifestylescreening/repositories/tags_repository.dart';
import 'package:lifestylescreening/repositories/tags_repository_interface.dart';

class TagsController {
  final ITagsRepository _goalsRepository = TagsRepository();

  Future<List<TagsModel>> getTagsList() {
    return _goalsRepository.getTagsList();
  }
}
