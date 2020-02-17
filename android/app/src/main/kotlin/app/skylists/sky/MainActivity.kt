package app.skylists.sky

import androidx.annotation.NonNull
import android.util.Log
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.*
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    var TAG: String = "SKY LISTS"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        var currentUser: FirebaseUser? = FirebaseAuth.getInstance().currentUser
        var listenerRegistration : ListenerRegistration = ListenerRegistration {  }
        var scheduledListsListener: EventListener<QuerySnapshot> = EventListener { snapshots, e ->
            if (e != null) {
                Log.w(TAG, "Listen to scheduled lists failed.", e)
                return@EventListener
            }

            if (snapshots != null && !snapshots.isEmpty) {
                for (dc in snapshots.documentChanges) {
                    dc.document.toObject(ScheduledListObject::class.java)
                    when (dc.type) {
                        DocumentChange.Type.ADDED -> Log.d(TAG, "New list sched: ${dc.document.data}")
                        DocumentChange.Type.MODIFIED -> Log.d(TAG, "Modified list sched: ${dc.document.data}")
                        DocumentChange.Type.REMOVED -> Log.d(TAG, "Removed list sched: ${dc.document.data}")
                    }
                }
            } else {
                Log.d(TAG, "Listen to scheduled lists current data is null")
            }
        }


        if (currentUser != null) {
            listenerRegistration = Firebase.firestore.collection("users").document(currentUser.uid).collection("scheduledlists").addSnapshotListener(scheduledListsListener)
        } else {
            FirebaseAuth.getInstance().addAuthStateListener { auth ->
                var listenerCurrentUser = auth.currentUser
                if (listenerCurrentUser != null) {
                    Log.d(TAG, "Logged in")
                    listenerRegistration = Firebase.firestore.collection("users").document(listenerCurrentUser.uid).collection("scheduledlists").addSnapshotListener(scheduledListsListener)
                } else {
                    listenerRegistration?.remove()
                    Log.d(TAG, "Not logged in")
                }
            }
        }
    }
}

data class ScheduledListObject(var listId: String = "")
