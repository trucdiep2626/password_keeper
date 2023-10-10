package kma.dieptt.password_keeper

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class AutofillActivity: FlutterFragmentActivity() {

        override fun getDartEntrypointFunctionName(): String {
            return "autofillEntryPoint"
        }

}

