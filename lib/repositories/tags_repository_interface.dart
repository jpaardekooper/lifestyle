import 'package:lifestylescreening/models/tags_model.dart';

abstract class ITagsRepository {
  Future<List<TagsModel>> getTagsList();
}
