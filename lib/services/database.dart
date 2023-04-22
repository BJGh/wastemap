import 'package:calory_calc/models/food_track_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  final DateTime currentDate;
  DatabaseService({required this.uid, required this.currentDate});
  final DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final DateTime weekStart = DateTime(2020, 09, 07);
  // collection reference
  final CollectionReference foodTrackCollection =
      FirebaseFirestore.instance.collection('foodTracks');
  Future addFoodTrackEntry(FoodTrackTask food) async {
    return await foodTrackCollection
        .doc(food.createdOn.millisecondsSinceEpoch.toString())
        .set({
      'food_name': food.food_name,
      'calories': food.calories,
      'carbs': food.carbs,
      'fat': food.fat,
      'protein': food.protein,
      'mealTime': food.mealTime,
      'createdOn': food.createdOn,
      'grams': food.grams
    });
  }

  Future deleteFoodTrackEntry(FoodTrackTask deleteEntry) async {
    print(deleteEntry.toString());
    return await foodTrackCollection
        .doc(deleteEntry.createdOn.millisecondsSinceEpoch.toString())
        .delete();
  }

  List<FoodTrackTask> _scanListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data()
          as Map<String, dynamic>; // added cast to Map<String, dynamic>
      return FoodTrackTask(
        id: doc.id,
        food_name: data.containsKey('food_name') ? data['food_name'] : '',
        calories: data.containsKey('calories') ? data['calories'] : 0,
        carbs: data.containsKey('carbs') ? data['carbs'] : 0,
        fat: data.containsKey('fat') ? data['fat'] : 0,
        protein: data.containsKey('protein') ? data['protein'] : 0,
        mealTime: data.containsKey('mealTime') ? data['mealTime'] : "",
        createdOn: data.containsKey('createdOn')
            ? doc.get('createdOn').toDate()
            : DateTime.now(),
        grams: data.containsKey('grams') ? data['grams'] : 0,
      );
    }).toList();
  }

  Stream<List<FoodTrackTask>> get foodTracks {
    return foodTrackCollection.snapshots().map(_scanListFromSnapshot);
  }

  Future<List<dynamic>> getAllFoodTrackData() async {
    QuerySnapshot snapshot = await foodTrackCollection.get();
    List<dynamic> result = snapshot.docs.map((doc) => doc.data()).toList();
    return result;
  }

  Future<String> getFoodTrackData(String uid) async {
    DocumentSnapshot snapshot = await foodTrackCollection.doc(uid).get();
    return snapshot.toString();
  }
}
