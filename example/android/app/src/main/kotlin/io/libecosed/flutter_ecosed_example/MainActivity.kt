package io.libecosed.flutter_ecosed_example

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import com.idlefish.flutterboost.containers.FlutterBoostFragment
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.TransparencyMode

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        // 启用边到边
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }

    /**
     * 使用FlutterFragmentActivity重写创建FlutterFragment的方法用于改用FlutterBoostFragment
     */
    override fun createFlutterFragment(): FlutterFragment {
        return FlutterBoostFragment.CachedEngineFragmentBuilder()
            .destroyEngineWithFragment(false)
            .renderMode(renderMode)
            .transparencyMode(
                if (backgroundMode == FlutterActivityLaunchConfigs.BackgroundMode.opaque) {
                    TransparencyMode.opaque
                } else {
                    TransparencyMode.transparent
                }
            )
            .shouldAttachEngineToActivity(true)
            .build()
    }
}
