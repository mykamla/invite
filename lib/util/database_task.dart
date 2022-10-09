import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseTask {
  /// Delete old events and videos from storage
  Future<void> batchDeleteOldEvent() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    return  FirebaseFirestore.instance
        .collection('events').where('date_fin', isLessThan: DateTime.now().toUtc()).get().then((querySnapshot) async {

      for (var document in querySnapshot.docs) {
        ///delete videos from storage
        querySnapshot.docs.forEach((element) {
          (element['video_link'] as List).forEach((url) async {
            try{
              await FirebaseStorage.instance.refFromURL(url).delete();
            }catch(e){
              print(e);
            }
          });
        });
        batch.delete(document.reference);
      }
      return batch.commit();
    });
  }

  /// Delete old message from storage; call it only after batchEventVideo() method to work
  Future<void> batchDeleteChat() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    return  FirebaseFirestore.instance.collection('messages').get().then((querySnapshot) {
      for (var document_messages in querySnapshot.docs) {
        querySnapshot.docs.forEach((element) async {

          print('@@@batch');
          print(element['uid_event']);

          await FirebaseFirestore.instance.collection('events').doc(element['uid_event']).get().then((value) {
           // if(!value.exists){batch.delete(document_messages.reference);}
          });
        });
      }
      return batch.commit();
    });
  }
}