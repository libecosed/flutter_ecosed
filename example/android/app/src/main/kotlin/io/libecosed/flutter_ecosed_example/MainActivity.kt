package io.libecosed.flutter_ecosed_example

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        // 启用边到边
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }

    override fun createFlutterFragment(): FlutterFragment {
        return super.createFlutterFragment()
    }
}
