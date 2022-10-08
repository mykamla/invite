import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BackgroundTask {
  /// Delete old events and videos from storage
  Future<void> batchDeleteOldEvent() {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return  FirebaseFirestore.instance
        .collection('events').where('date_fin', isGreaterThan: DateTime.now().toUtc()).get().then((querySnapshot) {

      for (var document in querySnapshot.docs) {
        ///delete videos from storage
        querySnapshot.docs.forEach((element) {
          (element['videoLink'] as List).forEach((url) async {
            await FirebaseStorage.instance.refFromURL(url).delete();
          });
        });
        batch.delete(document.reference);
      }
      return batch.commit();
    });
  }

  /// Delete old message from storage; call it only after batchEventVideo() method to work
  Future<void> batchDeleteChat(WriteBatch batch) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    return  FirebaseFirestore.instance.collection('messages').get().then((querySnapshot) {
      for (var document_messages in querySnapshot.docs) {
        querySnapshot.docs.forEach((element) async {
          await FirebaseFirestore.instance.collection('events').doc(element['uid_event']).get().then((value) {
            if(!value.exists){batch.delete(document_messages.reference);}
          });
        });
      }
      return batch.commit();
    });
  }
}