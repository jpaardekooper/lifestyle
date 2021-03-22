import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/tags_model.dart';
import 'package:lifestylescreening/repositories/tags_repository_interface.dart';

class TagsRepository extends ITagsRepository {
  @override
  Future<List<TagsModel>> getTagsList() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('recipeTags').get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return TagsModel.fromSnapshot(doc);
    }).toList();
  }
}
