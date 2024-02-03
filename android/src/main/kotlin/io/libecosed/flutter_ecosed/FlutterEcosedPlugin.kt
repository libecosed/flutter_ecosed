/**
 * Copyright flutter_ecosed
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.libecosed.flutter_ecosed

import android.app.Activity
import android.app.Service
import android.app.UiModeManager
import android.content.ComponentName
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.content.res.TypedArray
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatCallback
import androidx.appcompat.app.AppCompatDelegate
import androidx.appcompat.view.ActionMode
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.blankj.utilcode.util.AppUtils
import com.blankj.utilcode.util.PermissionUtils
import com.blankj.utilcode.util.VibrateUtils
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import rikka.shizuku.Shizuku
import kotlin.math.pow
import kotlin.math.sqrt
import kotlin.system.exitProcess


/**
 * 作者: wyq0918dev
 * 仓库: https://github.com/libecosed/flutter_ecosed
 * 时间: 2024/01/28
 * 描述: flutter_ecosed
 * 文档: https://github.com/libecosed/flutter_ecosed/blob/master/README.md
 */
class FlutterEcosedPlugin : Service(), FlutterPlugin, MethodChannel.MethodCallHandler,
    ActivityAware, ServiceConnection, LifecycleOwner, DefaultLifecycleObserver,
    SensorEventListener {


    /** Flutter插件方法通道 */
    private lateinit var mMethodChannel: MethodChannel

    /** 插件绑定器. */
    private var mBinding: PluginBinding? = null

    /** 插件列表. */
    private var mPluginList: ArrayList<EcosedPlugin>? = null

    private var mJSONList = arrayListOf<String>()


    /** Activity */
    private lateinit var mActivity: Activity

    /** 生命周期 */
    private lateinit var mLifecycle: Lifecycle

    private val mBaseDebug: Boolean = AppUtils.isAppDebug()

    private var mFullDebug: Boolean = false

    private var mExecResult: Any? = null

    private lateinit var mEcosedServicesIntent: Intent

    /** 服务AIDL接口 */
    private var mAIDL: FlutterEcosed? = null
    private var mIUserService: IUserService? = null

    /** 服务绑定状态 */
    private var mIsBind: Boolean = false


    private lateinit var poem: ArrayList<String>

    private var mDelegate: AppCompatDelegate? = null

    private lateinit var mSensorManager: SensorManager
    private lateinit var mDebugDialog: AlertDialog

    /** 上一次晃动的X轴坐标 */
    private var lastX = 0f

    /** 上一次晃动的Y轴坐标 */
    private var lastY = 0f

    /** 上一次晃动的Z轴坐标 */
    private var lastZ = 0f


    private val mUserServiceArgs = Shizuku.UserServiceArgs(
        ComponentName(AppUtils.getAppPackageName(), UserService().javaClass.name)
    ).daemon(false).processNameSuffix("service").debuggable(mFullDebug)
        .version(AppUtils.getAppVersionCode())


    private fun checkShizukuPermission(): Boolean {
        return try {
            when {
                Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED -> true
                Shizuku.shouldShowRequestPermissionRationale() -> false
                else -> false
            }
        } catch (e: IllegalStateException) {
            false
        }


//        return if (Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED) {
//            // Granted
//            true
//        } else if (Shizuku.shouldShowRequestPermissionRationale()) {
//            // Users choose "Deny and don't ask again"
//            false
//        } else false
    }

    private fun isShizukuInstalled(): Boolean {
        return if (AppUtils.isAppInstalled(EcosedManifest.ShizukuPackage)) {
            !Shizuku.isPreV11()
        } else false
    }

    private fun isSupportGMS(): Boolean {
        val code = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(mActivity)
        return if (code == ConnectionResult.SUCCESS) true else {
            AppUtils.isAppInstalled(EcosedManifest.GmsPackage)
        }
    }

    private fun requestPermissions() {
        try {
            Shizuku.requestPermission(0)
            PermissionUtils.permission(EcosedManifest.fakePackageSignature).request()
        } catch (e: IllegalStateException) {

        }

    }

    /**
     * 服务创建时执行
     */
    override fun onCreate() {
        super<Service>.onCreate()

        // 添加Shizuku监听
        Shizuku.addBinderReceivedListener(mService)
        Shizuku.addBinderDeadListener(mService)
        Shizuku.addRequestPermissionResultListener(mService)


        // 申请Shizuku权限

        //checkPermission(0)


//        if (AppUtils.isAppInstalled(EcosedManifest.ShizukuPackage)) {
//
//        } else {
//
//        }
//        try {
//            if (Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED){
//                Shizuku.requestPermission(0)
//            } else {
//                // 有权限
//            }
//        } catch (e: Exception) {
//            if (e.javaClass == IllegalStateException().javaClass) {
//                // 没激活
//            }
//        }


        // 申请签名欺骗权限
        val fake = PermissionUtils.permission(EcosedManifest.fakePackageSignature)
        fake.callback { isAllGranted, granted, deniedForever, denied -> }
        fake.request()


        // 检查GMS


        // 绑定Shizuku服务
        //Shizuku.bindUserService(mUserServiceArgs, this@EcosedKitPlugin)

        poem = arrayListOf()
        poem.add("不向焦虑与抑郁投降，这个世界终会有我们存在的地方。")
        poem.add("把喜欢的一切留在身边，这便是努力的意义。")
        poem.add("治愈、温暖，这就是我们最终幸福的结局。")
        poem.add("我有一个梦，也许有一天，灿烂的阳光能照进黑暗森林。")
        poem.add("如果必须要失去，那么不如一开始就不曾拥有。")
        poem.add("我们的终点就是与幸福同在。")
        poem.add("孤独的人不会伤害别人，只会不断地伤害自己罢了。")
        poem.add("如果你能记住我的名字，如果你们都能记住我的名字，也许我或者我们，终有一天能自由地生存着。")
        poem.add("对于所有生命来说，不会死亡的绝望，是最可怕的审判。")
        poem.add("我不曾活着，又何必害怕死亡。")


    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return super.onStartCommand(intent, flags, startId)
    }

    /**
     * 服务绑定时执行
     */
    override fun onBind(intent: Intent): IBinder {
        // 通过服务调用单元调用服务内部类进行绑定
        return serviceUnit {
            return@serviceUnit getBinder(
                intent = intent
            )
        }
    }

    /**
     * 重新绑定时执行
     */
    override fun onRebind(intent: Intent?) {
        super.onRebind(intent)
    }

    override fun onUnbind(intent: Intent?): Boolean {
        return super.onUnbind(intent)
    }

    /**
     * 服务销毁时执行
     */
    override fun onDestroy() {
        super<Service>.onDestroy()
        // 移除Shizuku监听
        Shizuku.removeBinderDeadListener(mService)
        Shizuku.removeBinderReceivedListener(mService)
        Shizuku.removeRequestPermissionResultListener(mService)

        // 解绑Shizuku服务
        Shizuku.unbindUserService(mUserServiceArgs, this@FlutterEcosedPlugin, true)
    }

    /**
     * 将插件添加到引擎
     */
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // 初始化方法通道
        mMethodChannel = MethodChannel(binding.binaryMessenger, flutterChannelName)
        // 设置方法通道回调程序
        mMethodChannel.setMethodCallHandler(this@FlutterEcosedPlugin)
    }

    /**
     * 将插件从引擎移除
     */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // 清空回调程序释放内存
        mMethodChannel.setMethodCallHandler(null)
    }

    /**
     * 调用方法
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = frameworkUnit {
        onMethodCall(
            call = object : MethodCallProxy {

                override val methodProxy: String
                    get() = call.method

                override val bundleProxy: Bundle
                    get() = Bundle().apply {
                        putString("channel", call.argument<String>("channel"))
                    }
            },
            result = object : ResultProxy {

                override fun success(
                    resultProxy: Any?,
                ) = result.success(
                    resultProxy
                )

                override fun error(
                    errorCodeProxy: String,
                    errorMessageProxy: String?,
                    errorDetailsProxy: Any?,
                ) = result.error(
                    errorCodeProxy,
                    errorMessageProxy,
                    errorDetailsProxy,
                )

                override fun notImplemented() = result.notImplemented()
            },
        )
    }

    /**
     * 附加到活动
     */
    override fun onAttachedToActivity(
        binding: ActivityPluginBinding,
    ) = frameworkUnit {
        // 获取活动
        getActivity(activity = binding.activity)
        // 获取生命周期
        getLifecycle(lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding))
        // 初始化引擎
        attach()
    }

    override fun onDetachedFromActivityForConfigChanges() = frameworkUnit {
        detach()
    }

    override fun onReattachedToActivityForConfigChanges(
        binding: ActivityPluginBinding,
    ) = frameworkUnit {
        // 获取活动
        getActivity(activity = binding.activity)
        // 获取生命周期
        getLifecycle(lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding))
    }

    /**
     * 从活动分离
     */
    override fun onDetachedFromActivity() = frameworkUnit {
        detach()
    }

    override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
        when (name?.className) {
            UserService().javaClass.name -> {
                if ((service != null) and (service?.pingBinder() == true)) {
                    mIUserService = IUserService.Stub.asInterface(service)
                }
                when {
                    mIUserService != null -> {
                        Toast.makeText(this, "mIUserService", Toast.LENGTH_SHORT).show()
                    }

                    else -> if (mFullDebug) Log.e(
                        pluginTag, "UserService接口获取失败 - onServiceConnected"
                    )
                }
                when {
                    mFullDebug -> Log.i(
                        pluginTag, "服务已连接 - onServiceConnected"
                    )
                }
            }

            this@FlutterEcosedPlugin.javaClass.name -> {
                if ((service != null) and (service?.pingBinder() == true)) {
                    mAIDL = FlutterEcosed.Stub.asInterface(service)
                }
                when {
                    mAIDL != null -> {
                        mIsBind = true
                        callBackUnit {
                            onEcosedConnected()
                        }
                    }

                    else -> if (mFullDebug) Log.e(
                        pluginTag, "AIDL接口获取失败 - onServiceConnected"
                    )
                }
                when {
                    mFullDebug -> Log.i(
                        pluginTag, "服务已连接 - onServiceConnected"
                    )
                }
            }

            else -> {

            }
        }
    }

    override fun onServiceDisconnected(name: ComponentName?) {
        when (name?.className) {
            UserService().javaClass.name -> {

            }

            this@FlutterEcosedPlugin.javaClass.name -> {
                mIsBind = false
                mAIDL = null
                unbindService(this)
                callBackUnit {
                    onEcosedDisconnected()
                }
                if (mFullDebug) {
                    Log.i(pluginTag, "服务意外断开连接 - onServiceDisconnected")
                }
            }

            else -> {

            }
        }

    }

    override fun onBindingDied(name: ComponentName?) {
        super.onBindingDied(name)
        when (name?.className) {
            UserService().javaClass.name -> {

            }

            this@FlutterEcosedPlugin.javaClass.name -> {

            }

            else -> {

            }
        }
    }

    override fun onNullBinding(name: ComponentName?) {
        super.onNullBinding(name)
        when (name?.className) {
            UserService().javaClass.name -> {

            }

            this@FlutterEcosedPlugin.javaClass.name -> {
                if (mFullDebug) {
                    Log.e(pluginTag, "Binder为空 - onNullBinding")
                }
            }

            else -> {

            }
        }
    }

    /**
     * 获取生命周期
     */
    override fun getLifecycle(): Lifecycle {
        return mLifecycle
    }

    /**
     ***********************************************************************************************
     * Activity生命周期函数，需要使用Activity上下文
     ***********************************************************************************************
     */

    /**
     * 活动创建时执行
     */
    override fun onCreate(owner: LifecycleOwner): Unit = activityUnit {
        super<DefaultLifecycleObserver>.onCreate(owner)
        isVisible = true

        // 判断是否使用AppCompat的主题并设置主题
        val attributes: TypedArray = obtainStyledAttributes(
            androidx.appcompat.R.styleable.AppCompatTheme
        )
        if (!attributes.hasValue(androidx.appcompat.R.styleable.AppCompatTheme_windowActionBar)) {
            attributes.recycle()
            setTheme(androidx.appcompat.R.style.Theme_AppCompat_DayNight_NoActionBar)
        }

        if (!isAppCompat()) getDelegate().onCreate(null)




        val toolbar = Toolbar(this).apply {
            subtitle = "flutter_ecosed"
            navigationIcon = ContextCompat.getDrawable(
                this@activityUnit, R.drawable.baseline_keyboard_command_key_24
            )
            setNavigationOnClickListener { view ->

            }
            setOnMenuItemClickListener { item ->
                when (item.itemId) {

                }
                true
            }
        }

        // 从系统服务中获取传感管理器对象
        mSensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        // 创建调试对话框
        AlertDialog.Builder(
            this@activityUnit, androidx.appcompat.R.style.Theme_AppCompat_DayNight_Dialog_Alert
        ).apply {
            setTitle("Debug Menu (Native)")
            setItems(
                arrayOf(
                    "item1",
                    "item2",
                    "item3",
                )
            ) { dialog, which ->
//                when (which) {
//
//                }
                Toast.makeText(this@activityUnit, which.toString(), Toast.LENGTH_SHORT).show()
            }

            setView(toolbar)



            setNegativeButton("NO") { dialog, which ->

            }
            setPositiveButton("OK") { dialog, which ->

            }
            mDebugDialog = create()
        }



        if (!isAppCompat()) getDelegate().setSupportActionBar(toolbar)

        if (!isAppCompat()) getDelegate().onPostCreate(null)


        findRootView(this@activityUnit)?.setOnTouchListener(delayHideTouchListener)


        //toggle()
    }

    /**
     * 活动启动时执行
     */
    override fun onStart(owner: LifecycleOwner): Unit = activityUnit {
        super<DefaultLifecycleObserver>.onStart(owner)
        if (!isAppCompat()) getDelegate().onStart()
    }

    /**
     * 活动恢复时执行
     */
    override fun onResume(owner: LifecycleOwner): Unit = activityUnit {
        super.onResume(owner)

        // 注册监听
        mSensorManager.registerListener(
            this@FlutterEcosedPlugin,
            mSensorManager.getDefaultSensor(
                Sensor.TYPE_ACCELEROMETER
            ),
            SensorManager.SENSOR_DELAY_UI,
        )
        if (!isAppCompat()) getDelegate().onPostResume()


    }

    /**
     * 活动暂停时执行
     */
    override fun onPause(owner: LifecycleOwner): Unit = activityUnit {
        super.onPause(owner)
        // 注销监听
        mSensorManager.unregisterListener(this@FlutterEcosedPlugin)
    }

    /**
     * 活动停止时执行
     */
    override fun onStop(owner: LifecycleOwner): Unit = activityUnit {
        super.onStop(owner)
        if (!isAppCompat()) getDelegate().onStop()
    }

    /**
     * 活动销毁时执行
     */
    override fun onDestroy(owner: LifecycleOwner): Unit = activityUnit {
        super<DefaultLifecycleObserver>.onDestroy(owner)
        if (!isAppCompat()) getDelegate().onDestroy()
    }

    /**
     * 当有新的传感器事件时调用.
     */
    override fun onSensorChanged(event: SensorEvent?) {
        event?.let { sensorEvent ->
            when (sensorEvent.sensor.type) {
                Sensor.TYPE_ACCELEROMETER -> {

                    // 加速度阈值
                    val mSpeed = 3000

                    //时间间隔
                    val mInterval = 150

                    //获取x,y,z
                    val nowX: Float = sensorEvent.values[0]
                    val nowY: Float = sensorEvent.values[1]
                    val nowZ: Float = sensorEvent.values[2]
                    //计算x,y,z变化量
                    val deltaX: Float = nowX - lastX
                    val deltaY: Float = nowY - lastY
                    val deltaZ: Float = nowZ - lastZ
                    //赋值
                    lastX = nowX
                    lastY = nowY
                    lastZ = nowZ



                    //计算
                    val nowSpeed: Double = sqrt(
                        x = (deltaX.pow(n = 2) + deltaY.pow(n = 2) + deltaZ.pow(n = 2)).toDouble()
                    ) / mInterval * 10000


                    //判断
                    if (nowSpeed >= mSpeed) {
                        if (mFullDebug and !mDebugDialog.isShowing) {
                            VibrateUtils.vibrate(100)
                            mDebugDialog.show()
                        }
                    }
                }
            }
        }
    }

    /**
     * 当注册的传感器的精度发生变化时调用.
     */
    override fun onAccuracyChanged(
        sensor: Sensor?, accuracy: Int
    ) = Unit







    private val hideHandler = Handler(Looper.myLooper()!!)

    private val showPart2Runnable = Runnable {
        getDelegate().supportActionBar?.show()
    }

    private var isVisible: Boolean = false

    private val hideRunnable = Runnable {
        hide()
    }

    private val delayHideTouchListener = View.OnTouchListener { view, motionEvent ->
        when (motionEvent.action) {
            MotionEvent.ACTION_DOWN -> if (autoHide) delayedHide()
            MotionEvent.ACTION_UP -> view.performClick()
            else -> {}
        }
        false
    }

    private fun toggle() {
        if (isVisible) {
            hide()
        } else {
            show()
        }
    }

    private fun hide() {
        getDelegate().supportActionBar?.hide()
        isVisible = false
        hideHandler.removeCallbacks(showPart2Runnable)
    }

    private fun show() {
        isVisible = true
        hideHandler.postDelayed(showPart2Runnable, uiAnimatorDelay.toLong())
    }

    private fun delayedHide() {
        hideHandler.removeCallbacks(hideRunnable)
        hideHandler.postDelayed(hideRunnable, autoHideDelayMillis.toLong())
    }











    /**
     ***********************************************************************************************
     * 分类: 内部基本接口方法
     ***********************************************************************************************
     */

    /**
     * Flutter插件代理
     */
    private interface FlutterPluginProxy {

        /** Activity */
        fun getActivity(activity: Activity)

        /** Lifecycle */
        fun getLifecycle(lifecycle: Lifecycle)

        /** 引擎初始化 */
        fun attach()

        /** 引擎销毁 */
        fun detach()

        /** 方法调用 */
        fun onMethodCall(call: MethodCallProxy, result: ResultProxy)
    }

    /**
     * 方法调用代理
     */
    private interface MethodCallProxy {

        /** 方法名代理 */
        val methodProxy: String

        /** 传入参数代理 */
        val bundleProxy: Bundle
    }

    /**
     * 返回内容代理
     */
    private interface ResultProxy {

        /**
         * 处理成功结果.
         * @param resultProxy 处理成功结果,注意可能为空.
         */
        fun success(resultProxy: Any?)

        /**
         * 处理错误结果.
         * @param errorCodeProxy 错误代码.
         * @param errorMessageProxy 错误消息,注意可能为空.
         * @param errorDetailsProxy 详细信息,注意可能为空.
         */
        fun error(errorCodeProxy: String, errorMessageProxy: String?, errorDetailsProxy: Any?)

        /**
         * 处理对未实现方法的调用.
         */
        fun notImplemented()
    }

    /**
     * 用于调用方法的接口.
     */
    private interface EcosedMethodCall {

        /**
         * 要调用的方法名.
         */
        val method: String?

        /**
         * 要传入的参数.
         */
        val bundle: Bundle?
    }

    /**
     * 方法调用结果回调.
     */
    private interface EcosedResult {

        /**
         * 处理成功结果.
         * @param result 处理成功结果,注意可能为空.
         */
        fun success(result: Any?)

        /**
         * 处理错误结果.
         * @param errorCode 错误代码.
         * @param errorMessage 错误消息,注意可能为空.
         * @param errorDetails 详细信息,注意可能为空.
         */
        fun error(
            errorCode: String,
            errorMessage: String?,
            errorDetails: Any?,
        ): Nothing

        /**
         * 处理对未实现方法的调用.
         */
        fun notImplemented()
    }

    /**
     * 引擎包装器
     */
    private interface EngineWrapper : FlutterPluginProxy {

        /**
         * 执行方法
         * @param channel 插件通道
         * @param method 插件方法
         * @param bundle 传值
         * @return 执行插件方法返回值
         */
        fun <T> execMethodCall(
            channel: String,
            method: String,
            bundle: Bundle?,
        ): T?
    }

    /**
     * 回调
     */
    private interface EcosedCallBack {

        /** 在服务绑定成功时回调 */
        fun onEcosedConnected()

        /** 在服务解绑或意外断开链接时回调 */
        fun onEcosedDisconnected()

        /** 在服务端服务未启动时绑定服务时回调 */
        fun onEcosedDead()

        /** 在未绑定服务状态下调用API时回调 */
        fun onEcosedUnbind()
    }

    /**
     * 服务插件包装器
     */
    private interface ServiceWrapper {

        /**
         * 获取Binder
         */
        fun getBinder(intent: Intent): IBinder
    }

    /**
     * 原生插件包装器
     */
    private interface NativeWrapper {

        /** 调用原生代码 */
        fun main()
    }

    /**
     * 基本插件
     */
    private abstract class EcosedPlugin : ContextWrapper(null) {

        /** 插件通道 */
        private lateinit var mPluginChannel: PluginChannel

        /** 是否调试模式 */
        private var mDebug: Boolean = false

        /**
         * 附加基本上下文
         */
        override fun attachBaseContext(base: Context?) {
            super.attachBaseContext(base)
        }

        /**
         * 插件添加时执行
         */
        open fun onEcosedAdded(binding: PluginBinding) {
            // 初始化插件通道
            mPluginChannel = PluginChannel(
                binding = binding, channel = channel
            )
            // 插件附加基本上下文
            attachBaseContext(
                base = mPluginChannel.getContext()
            )
            // 获取是否调试模式
            mDebug = mPluginChannel.isDebug()
            // 设置调用
            mPluginChannel.setMethodCallHandler(
                handler = this@EcosedPlugin
            )
        }

        /** 获取插件通道 */
        val getPluginChannel: PluginChannel
            get() = mPluginChannel

        /** 需要子类重写的插件标题 */
        abstract val title: String

        /** 需要子类重写的通道名称 */
        abstract val channel: String

        /** 需要子类重写的插件作者 */
        abstract val author: String

        /** 需要子类重写的插件描述 */
        abstract val description: String

        /** 供子类使用的判断调试模式的接口 */
        protected val isDebug: Boolean
            get() = mDebug

        /**
         * 插件调用方法
         */
        open fun onEcosedMethodCall(call: EcosedMethodCall, result: EcosedResult) = Unit
    }

    /**
     * 插件绑定器
     */
    private class PluginBinding(
        context: Context,
        debug: Boolean,
    ) {

        /** 应用程序全局上下文. */
        private val mContext: Context = context

        /** 是否调试模式. */
        private val mDebug: Boolean = debug

        /**
         * 获取上下文.
         * @return Context.
         */
        fun getContext(): Context {
            return mContext
        }

        /**
         * 是否调试模式.
         * @return Boolean.
         */
        fun isDebug(): Boolean {
            return mDebug
        }
    }

    /**
     * 插件通信通道
     */
    private class PluginChannel(binding: PluginBinding, channel: String) {

        /** 插件绑定器. */
        private var mBinding: PluginBinding = binding

        /** 插件通道. */
        private var mChannel: String = channel

        /** 方法调用处理接口. */
        private var mPlugin: EcosedPlugin? = null

        /** 方法名. */
        private var mMethod: String? = null

        /** 参数Bundle. */
        private var mBundle: Bundle? = null

        /** 返回结果. */
        private var mResult: Any? = null

        /**
         * 设置方法调用.
         * @param handler 执行方法时调用EcosedMethodCallHandler.
         */
        fun setMethodCallHandler(handler: EcosedPlugin) {
            mPlugin = handler
        }

        /**
         * 获取上下文.
         * @return Context.
         */
        fun getContext(): Context {
            return mBinding.getContext()
        }

        /**
         * 是否调试模式.
         * @return Boolean.
         */
        fun isDebug(): Boolean {
            return mBinding.isDebug()
        }

        /**
         * 获取通道.
         * @return 通道名称.
         */
        fun getChannel(): String {
            return mChannel
        }

        /**
         * 执行方法回调.
         * @param name 通道名称.
         * @param method 方法名称.
         * @return 方法执行后的返回值.
         */
        @Suppress("UNCHECKED_CAST")
        fun <T> execMethodCall(name: String, method: String?, bundle: Bundle?): T? {
            mMethod = method
            mBundle = bundle
            if (name == mChannel) {
                mPlugin?.onEcosedMethodCall(
                    call = call, result = result
                )
            }
            return mResult as T?
        }

        /** 用于调用方法的接口. */
        private val call: EcosedMethodCall = object : EcosedMethodCall {

            /**
             * 要调用的方法名.
             */
            override val method: String?
                get() = mMethod

            /**
             * 要传入的参数.
             */
            override val bundle: Bundle?
                get() = mBundle
        }

        /** 方法调用结果回调. */
        private val result: EcosedResult = object : EcosedResult {

            /**
             * 处理成功结果.
             */
            override fun success(result: Any?) {
                mResult = result
            }

            /**
             * 处理错误结果.
             */
            override fun error(
                errorCode: String, errorMessage: String?, errorDetails: Any?
            ): Nothing = error(
                message = "错误代码:$errorCode\n错误消息:$errorMessage\n详细信息:$errorDetails"
            )

            /**
             * 处理对未实现方法的调用.
             */
            override fun notImplemented() {
                mResult = null
            }
        }

    }

    /**
     ***********************************************************************************************
     * 分类: 关键内部类实现
     ***********************************************************************************************
     */

    /** 负责引擎和Flutter通信的框架 */
    private val mFramework = object : EcosedPlugin(), FlutterPluginProxy {

        /** 插件标题 */
        override val title: String
            get() = getString(R.string.framework_title)

        /** 插件通道 */
        override val channel: String
            get() = frameworkChannelName

        /** 插件作者 */
        override val author: String
            get() = getString(R.string.default_author)

        /** 插件描述 */
        override val description: String
            get() = getString(R.string.framework_description)

        override fun getActivity(activity: Activity) = engineUnit {
            return@engineUnit getActivity(activity = activity)
        }

        override fun getLifecycle(lifecycle: Lifecycle) = engineUnit {
            return@engineUnit getLifecycle(lifecycle = lifecycle)
        }

        override fun onMethodCall(call: MethodCallProxy, result: ResultProxy) = engineUnit {
            return@engineUnit onMethodCall(call = call, result = result)
        }

        override fun attach() = engineUnit {
            return@engineUnit attach()
        }

        override fun detach() = engineUnit {
            return@engineUnit detach()
        }
    }

    /** 引擎 */
    private val mEngine = object : EcosedPlugin(), EngineWrapper {

        /** 插件标题 */
        override val title: String
            get() = getString(R.string.engine_title)

        /** 插件通道 */
        override val channel: String
            get() = engineChannelName

        /** 插件作者 */
        override val author: String
            get() = getString(R.string.default_author)

        /** 插件描述 */
        override val description: String
            get() = getString(R.string.engine_description)

        override fun getActivity(activity: Activity) {
            mActivity = activity
        }

        override fun getLifecycle(lifecycle: Lifecycle) {
            mLifecycle = lifecycle
        }

        override fun onEcosedAdded(binding: PluginBinding) {
            super.onEcosedAdded(binding)
            // 设置来自插件的全局调试布尔值
            mFullDebug = isDebug


        }

        override fun onEcosedMethodCall(call: EcosedMethodCall, result: EcosedResult) {
            super.onEcosedMethodCall(call, result)
            when (call.method) {
                "getPlugins" -> result.success(mJSONList)
                else -> result.notImplemented()
            }
        }

        override fun onMethodCall(call: MethodCallProxy, result: ResultProxy) {
            try {
                mExecResult = execMethodCall<Any>(
                    channel = call.bundleProxy.getString("channel", engineChannelName),
                    method = call.methodProxy,
                    bundle = call.bundleProxy
                )
                if (mExecResult != null) {
                    result.success(mExecResult)
                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
                result.error(pluginTag, "engine: onMethodCall", Log.getStackTraceString(e))
            }
        }

        /**
         * 引擎初始化.
         */
        override fun attach() {
            when {
                (mPluginList == null) or (mBinding == null) -> pluginUnit { plugin, binding ->
                    // 初始化插件列表.
                    mPluginList = arrayListOf()
                    // 添加所有插件.
                    plugin.forEach { item ->
                        item.apply {
                            try {
                                onEcosedAdded(binding = binding)
                                if (mBaseDebug) {
                                    Log.d(pluginTag, "插件${item.javaClass.name}已加载")
                                }
                            } catch (e: Exception) {
                                if (mBaseDebug) {
                                    Log.e(pluginTag, "插件添加失败!", e)
                                }
                            }
                        }.run {
                            mPluginList?.add(
                                element = item
                            )
                            mJSONList.add(
                                element = JSONObject().run {
                                    put("channel", channel)
                                    put("title", title)
                                    put("description", description)
                                    put("author", author)
                                }.toString()
                            )
                            if (mBaseDebug) {
                                Log.d(pluginTag, "插件${item.javaClass.name}已添加到插件列表")
                            }
                        }
                    }
                }

                else -> if (mBaseDebug) Log.e(pluginTag, "请勿重复执行attach!")
            }
        }

        /**
         * 销毁引擎释放资源.
         */
        override fun detach() {

        }

        /**
         * 调用插件代码的方法.
         * @param channel 要调用的插件的通道.
         * @param method 要调用的插件中的方法.
         * @param bundle 通过Bundle传递参数.
         * @return 返回方法执行后的返回值,类型为Any?.
         */
        override fun <T> execMethodCall(
            channel: String,
            method: String,
            bundle: Bundle?,
        ): T? {
            var result: T? = null
            try {
                mPluginList?.forEach { plugin ->
                    plugin.getPluginChannel.let { pluginChannel ->
                        when (pluginChannel.getChannel()) {
                            channel -> {
                                result = pluginChannel.execMethodCall<T>(
                                    name = channel, method = method, bundle = bundle
                                )
                                if (mBaseDebug) {
                                    Log.d(
                                        pluginTag,
                                        "插件代码调用成功!\n通道名称:${channel}.\n方法名称:${method}.\n返回结果:${result}."
                                    )
                                }
                            }
                        }
                    }
                }
            } catch (e: Exception) {
                if (mBaseDebug) {
                    Log.e(pluginTag, "插件代码调用失败!", e)
                }
            }
            return result
        }
    }

    /** 负责与服务通信的客户端 */
    private val mClient = object : EcosedPlugin(), EcosedCallBack {

        /** 插件标题 */
        override val title: String
            get() = getString(R.string.client_title)

        /** 插件通道 */
        override val channel: String
            get() = clientChannelName

        /** 插件作者 */
        override val author: String
            get() = getString(R.string.default_author)

        /** 插件描述 */
        override val description: String
            get() = getString(R.string.client_description)

        /**
         * 插件添加时执行
         */
        override fun onEcosedAdded(binding: PluginBinding) = run {
            super.onEcosedAdded(binding)
            mEcosedServicesIntent = Intent(this@run, this@FlutterEcosedPlugin.javaClass)
            mEcosedServicesIntent.action = action


            startService(mEcosedServicesIntent)
            bindEcosed(this@run)

            Toast.makeText(this@run, "client", Toast.LENGTH_SHORT).show()



        }

        /**
         * 插件方法调用
         */
        override fun onEcosedMethodCall(call: EcosedMethodCall, result: EcosedResult) {
            super.onEcosedMethodCall(call, result)
            when (call.method) {
                mMethodDebug -> result.success(isDebug)
                mMethodIsBinding -> result.success(mIsBind)
                mMethodStartService -> startService(mEcosedServicesIntent)
                mMethodBindService -> bindEcosed(this)
                mMethodUnbindService -> unbindEcosed(this)

                "getPlatformVersion" -> result.success("Android API ${Build.VERSION.SDK_INT}")

                "shizuku" -> mIUserService?.poem()

                mMethodShizukuVersion -> result.success(getShizukuVersion())
                else -> result.notImplemented()
            }
        }

        /**
         * 在服务绑定成功时回调
         */
        override fun onEcosedConnected() {
            Toast.makeText(this, "onEcosedConnected", Toast.LENGTH_SHORT).show()
        }

        /**
         * 在服务解绑或意外断开链接时回调
         */
        override fun onEcosedDisconnected() {
            Toast.makeText(this, "onEcosedDisconnected", Toast.LENGTH_SHORT).show()
        }

        /**
         * 在服务端服务未启动时绑定服务时回调
         */
        override fun onEcosedDead() {
            Toast.makeText(this, "onEcosedDead", Toast.LENGTH_SHORT).show()
        }

        /**
         * 在未绑定服务状态下调用API时回调
         */
        override fun onEcosedUnbind() {
            Toast.makeText(this, "onEcosedUnbind", Toast.LENGTH_SHORT).show()
        }
    }

    /** 服务相当于整个服务类部分无法在大类中实现的方法在此实现并调用 */
    private val mService = object : EcosedPlugin(), ServiceWrapper, Shizuku.OnBinderReceivedListener,
            Shizuku.OnBinderDeadListener, Shizuku.OnRequestPermissionResultListener,
            AppCompatCallback {

            /** 插件标题 */
            override val title: String
                get() = getString(R.string.service_title)

            /** 插件通道 */
            override val channel: String
                get() = serviceChannelName

            /** 插件作者 */
            override val author: String
                get() = getString(R.string.default_author)

            /** 插件描述 */
            override val description: String
                get() = getString(R.string.service_description)

            override fun onEcosedAdded(binding: PluginBinding) {
                super.onEcosedAdded(binding)
                // 添加生命周期观察者
                lifecycle.addObserver(this@FlutterEcosedPlugin)
            }


            override fun onEcosedMethodCall(call: EcosedMethodCall, result: EcosedResult) {
                super.onEcosedMethodCall(call, result)
                when (call.method) {
                    "isShizukuInstalled" -> result.success(isShizukuInstalled())
                    "installShizuku" -> {}
                    "isMicroGInstalled" -> result.success(isSupportGMS())
                    "installMicroG" -> {}
                    "isShizukuGranted" -> result.success(checkShizukuPermission())
                    "requestPermissions" -> requestPermissions()


                }
            }

            /**
             * 获取Binder
             * @param intent 意图
             * @return IBinder
             */
            override fun getBinder(intent: Intent): IBinder {
                return object : FlutterEcosed.Stub() {
                    override fun getFrameworkVersion(): String = frameworkVersion()
                    override fun getShizukuVersion(): String = shizukuVersion()
                    override fun getChineseCale(): String = chineseCale()
                    override fun getOnePoem(): String = onePoem()
                    override fun isWatch(): Boolean = watch()
                    override fun isUseDynamicColors(): Boolean = dynamicColors()
                    override fun openDesktopSettings() = taskbarSettings()
                    override fun openEcosedSettings() = ecosedSettings()
                }
            }

            override fun onBinderReceived() {
                Toast.makeText(this, "onBinderReceived", Toast.LENGTH_SHORT).show()
            }

            override fun onBinderDead() {
                Toast.makeText(this, "onBinderDead", Toast.LENGTH_SHORT).show()
            }

            override fun onRequestPermissionResult(requestCode: Int, grantResult: Int) {
                Toast.makeText(this, "onRequestPermissionResult", Toast.LENGTH_SHORT).show()
            }

            override fun onSupportActionModeStarted(mode: ActionMode?) {

            }

            override fun onSupportActionModeFinished(mode: ActionMode?) {

            }

            override fun onWindowStartingSupportActionMode(callback: ActionMode.Callback?): ActionMode? {
                return null
            }
        }

    /** 原生方法调用 */
    private val mNative = object : EcosedPlugin(), NativeWrapper {

        /** 插件标题 */
        override val title: String
            get() = getString(R.string.native_title)

        /** 插件通道 */
        override val channel: String
            get() = nativeChannelName

        /** 插件作者 */
        override val author: String
            get() = getString(R.string.default_author)

        /** 插件描述 */
        override val description: String
            get() = getString(R.string.native_description)

        override fun onEcosedMethodCall(call: EcosedMethodCall, result: EcosedResult) {
            super.onEcosedMethodCall(call, result)
            when (call.method) {
                "main" -> main()
                else -> result.notImplemented()
            }
        }

        override fun main() {
            main(arrayOf(""))


        }
    }

    /**
     * Shizuku调用类
     */
    class UserService : IUserService.Stub() {

        override fun destroy() = exitProcess(
            status = 0
        )

        override fun exit() = exitProcess(
            status = 0
        )

        override fun poem() {
            Log.d("", "Shizuku - poem")
        }
    }

    /**
     ***********************************************************************************************
     * 分类: 调用单元
     ***********************************************************************************************
     */

    /**
     * 框架调用单元
     * Flutter插件调用框架
     * @param content Flutter插件代理单元
     * @return content 返回值
     */
    private inline fun <R> frameworkUnit(
        content: FlutterPluginProxy.() -> R,
    ): R = content.invoke(mFramework)

    /**
     * 引擎调用单元
     * 框架调用引擎
     * @param content 引擎包装器单元
     * @return content 返回值
     */
    private inline fun <R> engineUnit(
        content: EngineWrapper.() -> R,
    ): R = content.invoke(mEngine)

    /**
     * 插件调用单元
     * 插件初始化
     * @param content 插件列表单元, 插件绑定器
     * @return content 返回值
     */
    private inline fun <R> pluginUnit(
        content: (ArrayList<EcosedPlugin>, PluginBinding) -> R
    ): R = content.invoke(
        arrayListOf(mFramework, mEngine, mClient, mService, mNative),
        PluginBinding(context = mActivity, debug = mBaseDebug)
    )

    /**
     * 客户端回调调用单元
     * 绑定解绑调用客户端回调
     * @param content 客户端回调单元
     * @return content 返回值
     */
    private inline fun <R> callBackUnit(
        content: EcosedCallBack.() -> R,
    ): R = content.invoke(mClient)

    /**
     * 服务调用单元
     * 服务与服务嗲用
     * @param content 服务
     * @return content 返回值
     */
    private inline fun <R> serviceUnit(
        content: ServiceWrapper.() -> R,
    ): R = content.invoke(mService)

    /**
     * Activity上下文调用单元
     * Activity生命周期观察者通过此调用单元执行基于Activity上下文的代码
     * @param content 内容
     * @return content 返回值
     */
    private inline fun <R> activityUnit(
        content: Activity.() -> R,
    ): R = content.invoke(mActivity)

    /**
     *
     */
    private inline fun <R> nativeUnit(
        content: NativeWrapper.() -> R,
    ): R = content.invoke(mNative)

    /**
     ***********************************************************************************************
     * 分类: 原生调用
     ***********************************************************************************************
     */

    /**
     * 原生代码执行入口
     */
    private external fun main(args: Array<String>)

    /**
     ***********************************************************************************************
     * 分类: 私有函数
     ***********************************************************************************************
     */

    private fun findRootView(activity: Activity): View? {
        return when (activity) {
            is FlutterActivity -> findFlutterView(activity.window.decorView)
            is AppCompatActivity -> activity.window.decorView
            else -> null
        }
    }

    private fun findFlutterView(view: View?): FlutterView? {
        when (view) {
            is FlutterView -> return view
            is ViewGroup -> for (i in 0 until view.childCount) {
                findFlutterView(view.getChildAt(i))?.let {
                    return it
                }
            }

            else -> return null
        }
        return null
    }

    /**
     * 绑定服务
     * @param context 上下文
     */
    private fun bindEcosed(context: Context) {
        try {
            if (!mIsBind) {
                context.bindService(
                    mEcosedServicesIntent, this@FlutterEcosedPlugin, Context.BIND_AUTO_CREATE
                ).let { bind ->
                    callBackUnit {
                        if (!bind) onEcosedDead()
                    }
                }
            }
        } catch (e: Exception) {
            if (mFullDebug) {
                Log.e(pluginTag, "bindEcosed", e)
            }
        }
    }

    /**
     * 解绑服务
     * @param context 上下文
     */
    private fun unbindEcosed(context: Context) {
        try {
            if (mIsBind) {
                context.unbindService(
                    this@FlutterEcosedPlugin
                ).run {
                    mIsBind = false
                    mAIDL = null
                    callBackUnit {
                        onEcosedDisconnected()
                    }
                    if (mFullDebug) {
                        Log.i(pluginTag, "服务已断开连接 - onServiceDisconnected")
                    }
                }
            }
        } catch (e: Exception) {
            if (mFullDebug) {
                Log.e(pluginTag, "unbindEcosed", e)
            }
        }
    }

    private fun isAppCompat(): Boolean = activityUnit {
        return@activityUnit this@activityUnit is AppCompatActivity
    }

    private fun getDelegate(): AppCompatDelegate = activityUnit {
        if (mDelegate == null) {
            mDelegate = AppCompatDelegate.create(
                this@activityUnit, mService
            )
        }
        return mDelegate!!
    }

    private fun frameworkVersion(): String {
        return AppUtils.getAppVersionName()
    }

    private fun shizukuVersion(): String {
        return try {
            "Shizuku ${Shizuku.getVersion()}"
        } catch (e: Exception) {
            Log.getStackTraceString(e)
        }
    }

    private fun chineseCale(): String {
        return ""
    }

    private fun onePoem(): String {
        return poem[(poem.indices).random()]
    }

    private fun watch(): Boolean {
        return getSystemService(
            UiModeManager::class.java
        ).currentModeType == Configuration.UI_MODE_TYPE_WATCH
    }

    private fun dynamicColors(): Boolean {
        return true
    }

    private fun taskbarSettings() {
        CoroutineScope(
            context = Dispatchers.Main
        ).launch {

        }
    }

    private fun ecosedSettings() {
        CoroutineScope(
            context = Dispatchers.Main
        ).launch {

        }
    }


    private fun getShizukuVersion(): String? {
        return try {
            if (mIsBind) {
                if (mAIDL != null) {
                    mAIDL!!.shizukuVersion
                } else {
                    callBackUnit {
                        onEcosedUnbind()
                    }
                    null
                }
            } else {
                callBackUnit {
                    onEcosedUnbind()
                }
                null
            }
        } catch (e: Exception) {
            if (mFullDebug) {
                Log.e(pluginTag, "getShizukuVersion", e)
            }
            null
        }
    }

    private object EcosedManifest {
        const val ShizukuPackage: String = "moe.shizuku.privileged.api"
        const val GmsPackage: String = "com.google.android.gms"

        const val fakePackageSignature: String = "android.permission.FAKE_PACKAGE_SIGNATURE"
    }

    private companion object {

        init {
            System.loadLibrary("flutter_ecosed")
        }

        /** 操作栏是否应该在[autoHideDelayMillis]毫秒后自动隐藏。*/
        const val autoHide = false

        /** 如果设置了[autoHide]，则在用户交互后隐藏操作栏之前等待的毫秒数。*/
        const val autoHideDelayMillis = 3000

        /** 一些较老的设备需要在小部件更新和状态和导航栏更改之间有一个小的延迟。*/
        const val uiAnimatorDelay = 300

        // 打印日志的标签
        const val pluginTag: String = "FlutterEcosedPlugin"

        // Flutter插件通道名称
        const val flutterChannelName = "flutter_ecosed"

        // Ecosed插件通道名称
        const val frameworkChannelName: String = "ecosed_framework"
        const val engineChannelName: String = "ecosed_engine"
        const val clientChannelName: String = "ecosed_client"
        const val serviceChannelName: String = "ecosed_service"
        const val nativeChannelName: String = "ecosed_native"

        //const val defaultAuthor: String = "wyq0918dev"

        const val action: String = "io.ecosed.kit.action"


        const val mMethodDebug: String = "is_binding"
        const val mMethodIsBinding: String = "is_debug"
        const val mMethodStartService: String = "start_service"
        const val mMethodBindService: String = "bind_service"
        const val mMethodUnbindService: String = "unbind_service"
        const val mMethodShizukuVersion: String = "shizuku_version"


    }


}