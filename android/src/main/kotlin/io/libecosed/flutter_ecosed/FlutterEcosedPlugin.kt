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
import androidx.appcompat.app.ActionBarDrawerToggle
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
    ActivityAware, LifecycleOwner, ServiceConnection, DefaultLifecycleObserver, SensorEventListener {


    /** Flutter插件方法通道 */
    private lateinit var mMethodChannel: MethodChannel

    /** 插件绑定器. */
    private var mBinding: PluginBinding? = null

    /** 插件列表. */
    private var mPluginList: ArrayList<EcosedPlugin>? = null

    private var mJSONList = arrayListOf<String>()


    /** Activity */
    private lateinit var mActivity: Activity
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

    private lateinit var mDelegate: AppCompatDelegate

    private lateinit var mSensorManager: SensorManager
    private lateinit var mDebugDialog: AlertDialog

    private val hideHandler = Handler(Looper.myLooper()!!)

    private val showPart2Runnable = Runnable {
        mDelegate.supportActionBar?.show()
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

    /** 上一次晃动的X轴坐标 */
    private var lastX = 0f

    /** 上一次晃动的Y轴坐标 */
    private var lastY = 0f

    /** 上一次晃动的Z轴坐标 */
    private var lastZ = 0f


    private val mUserServiceArgs = Shizuku.UserServiceArgs(
        ComponentName(
            AppUtils.getAppPackageName(),
            UserService().javaClass.name,
        )
    )
        .daemon(false)
        .processNameSuffix("service")
        .debuggable(mFullDebug)
        .version(AppUtils.getAppVersionCode())

    /**
     * 服务创建时执行
     */
    override fun onCreate() {
        super<Service>.onCreate()

        shizukuUnit {
            // 添加Shizuku监听
            Shizuku.addBinderReceivedListener(this@shizukuUnit)
            Shizuku.addBinderDeadListener(this@shizukuUnit)
            Shizuku.addRequestPermissionResultListener(this@shizukuUnit)
        }




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

    /**
     * 开始服务时执行
     */
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

    /**
     * 解除绑定时执行
     */
    override fun onUnbind(intent: Intent?): Boolean {
        return super.onUnbind(intent)
    }

    /**
     * 服务销毁时执行
     */
    override fun onDestroy() {
        super<Service>.onDestroy()

        shizukuUnit {
            // 移除Shizuku监听
            Shizuku.removeBinderDeadListener(this@shizukuUnit)
            Shizuku.removeBinderReceivedListener(this@shizukuUnit)
            Shizuku.removeRequestPermissionResultListener(this@shizukuUnit)
        }


        // 解绑Shizuku服务
        Shizuku.unbindUserService(mUserServiceArgs, this@FlutterEcosedPlugin, true)
    }

    /**
     * 将插件添加到引擎
     */
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) = frameworkUnit {
        // 初始化方法通道
        mMethodChannel = MethodChannel(binding.binaryMessenger, flutterChannelName)
        // 设置方法通道回调程序
        mMethodChannel.setMethodCallHandler(this@FlutterEcosedPlugin)
        // 初始化引擎
        onCreateEngine(context = binding.applicationContext)
    }

    /**
     * 将插件从引擎移除
     */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = frameworkUnit {
        // 清空回调程序释放内存
        mMethodChannel.setMethodCallHandler(null)
        // 销毁引擎释放资源
        onDestroyEngine()
    }

    /**
     * 调用方法
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = frameworkUnit {
        // 调用插件方法
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
        onCreateActivity(activity = binding.activity)
        // 获取生命周期
        onCreateLifecycle(lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding))
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this@FlutterEcosedPlugin.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this@FlutterEcosedPlugin.onAttachedToActivity(binding = binding)
    }

    /**
     * 从活动分离
     */
    override fun onDetachedFromActivity() = frameworkUnit {
        onDestroyActivity()
        onDestroyLifecycle()
    }

    override fun getLifecycle(): Lifecycle {
        return mLifecycle
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
                        clientUnit {
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
                clientUnit {
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
     ***********************************************************************************************
     * Activity生命周期函数，需要使用Activity上下文
     ***********************************************************************************************
     */

    /**
     * 活动创建时执行
     */
    override fun onCreate(owner: LifecycleOwner): Unit = activityUnit {
        super<DefaultLifecycleObserver>.onCreate(owner)
        // 初始化Delegate
        mDelegate = if (this@activityUnit is AppCompatActivity) delegate else {
            appCompatUnit {
                return@appCompatUnit AppCompatDelegate.create(
                    this@activityUnit,
                    this@appCompatUnit
                )
            }
        }
        // 附加Delegate基本上下文
        serviceUnit {
            if (this@activityUnit !is AppCompatActivity) {
                attachDelegateBaseContext()
            }
        }
        // 初始化工具栏状态
        isVisible = true
        // 判断Activity是否为AppCompatActivity
        // 为了保证接下来的Delegate调用，如果不是需要设置AppCompat主题
        if (this@activityUnit !is AppCompatActivity) {
            val attributes: TypedArray = obtainStyledAttributes(
                androidx.appcompat.R.styleable.AppCompatTheme
            )
            if (!attributes.hasValue(androidx.appcompat.R.styleable.AppCompatTheme_windowActionBar)) {
                attributes.recycle()
                setTheme(androidx.appcompat.R.style.Theme_AppCompat_DayNight_NoActionBar)
            }
        }

        // 调用Delegate onCreate函数
        if (this@activityUnit !is AppCompatActivity) {
            mDelegate.onCreate(Bundle())
        }

        // 初始化工具栏
        val toolbar = Toolbar(this@activityUnit).apply {
            navigationIcon = ContextCompat.getDrawable(
                this@activityUnit,
                R.drawable.baseline_keyboard_command_key_24,
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
        // 如果Activity是AppCompatActivity则不设置主题
        val builder = if (this@activityUnit !is AppCompatActivity) AlertDialog.Builder(
            this@activityUnit,
            androidx.appcompat.R.style.Theme_AppCompat_DayNight_Dialog_Alert
        ) else AlertDialog.Builder(this@activityUnit)

        // 设置对话框
        builder.apply {
            setTitle("Debug Menu (Native)")
            setItems(arrayOf("item1", "item2", "item3")) { dialog, which ->
                Toast.makeText(
                    this@activityUnit,
                    which.toString(),
                    Toast.LENGTH_SHORT
                ).show()
            }
            setView(toolbar)
            setNegativeButton("NO") { dialog, which -> }
            setPositiveButton("OK") { dialog, which -> }
            mDebugDialog = create()
        }

        // 设置操作栏
        mDelegate.setSupportActionBar(toolbar)





        findRootView(this@activityUnit)?.setOnTouchListener(delayHideTouchListener)


        findFlutterView(window.decorView).apply {

        }

        //toggle()

        // 执行Delegate函数
        if (this@activityUnit !is AppCompatActivity) {
            mDelegate.onPostCreate(Bundle())
        }
    }

    /**
     * 活动启动时执行
     */
    override fun onStart(owner: LifecycleOwner): Unit = activityUnit {
        super<DefaultLifecycleObserver>.onStart(owner)
        // 执行Delegate onStart函数
        if (this@activityUnit !is AppCompatActivity) {
            mDelegate.onStart()
        }
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

        // 执行Delegate onPostResume函数
        if (this@activityUnit !is AppCompatActivity) {
            mDelegate.onPostResume()
        }
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
        if (this@activityUnit !is AppCompatActivity) {
            mDelegate.onStop()
        }
    }

    /**
     * 活动销毁时执行
     */
    override fun onDestroy(owner: LifecycleOwner): Unit = activityUnit {
        super<DefaultLifecycleObserver>.onDestroy(owner)
        if (this@activityUnit !is AppCompatActivity) {
            mDelegate.onDestroy()
        }
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
                    if ((nowSpeed >= mSpeed) and mFullDebug and !mDebugDialog.isShowing) {
                        VibrateUtils.vibrate(100)
                        mDebugDialog.show()
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

    /**
     ***********************************************************************************************
     * 分类: 内部基本接口方法
     ***********************************************************************************************
     */

    /**
     * Flutter插件代理
     */
    private interface FlutterPluginProxy {

        /** 注册Activity引用 */
        fun onCreateActivity(activity: Activity)

        /** 注销Activity引用 */
        fun onDestroyActivity()

        /** 注册生命周期监听器 */
        fun onCreateLifecycle(lifecycle: Lifecycle)

        /** 注销生命周期监听器释放资源避免内存泄露 */
        fun onDestroyLifecycle()

        /** 引擎初始化 */
        fun onCreateEngine(context: Context)

        /** 引擎销毁 */
        fun onDestroyEngine()

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
        fun error(
            errorCodeProxy: String,
            errorMessageProxy: String?,
            errorDetailsProxy: Any?
        )

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
    private interface ClientWrapper {

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
     * Shizuku包装器
     * 具有Shizuku监听器方法
     */
    private interface ShizukuWrapper: Shizuku.OnBinderReceivedListener,
        Shizuku.OnBinderDeadListener,
        Shizuku.OnRequestPermissionResultListener

    /**
     * AppCompat包装器
     * 方法回调和操作栏抽屉状态切换
     */
    private interface AppCompatWrapper: AppCompatCallback,
        ActionBarDrawerToggle.DelegateProvider

    /**
     * 服务插件包装器
     */
    private interface ServiceWrapper: ShizukuWrapper, AppCompatWrapper {

        /**
         * 获取Binder
         */
        fun getBinder(intent: Intent): IBinder

        fun attachDelegateBaseContext()
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

        override fun onCreateActivity(activity: Activity): Unit = engineUnit {
            return@engineUnit onCreateActivity(activity = activity)
        }

        override fun onDestroyActivity(): Unit = engineUnit {
            return@engineUnit onDestroyActivity()
        }

        override fun onCreateLifecycle(lifecycle: Lifecycle): Unit = engineUnit {
            return@engineUnit onCreateLifecycle(lifecycle = lifecycle)
        }

        override fun onDestroyLifecycle(): Unit = engineUnit {
            return@engineUnit onDestroyLifecycle()
        }

        override fun onCreateEngine(context: Context): Unit = engineUnit {
            return@engineUnit onCreateEngine(context = context)
        }

        override fun onDestroyEngine(): Unit = engineUnit {
            return@engineUnit onDestroyEngine()
        }

        override fun onMethodCall(call: MethodCallProxy, result: ResultProxy): Unit = engineUnit {
            return@engineUnit onMethodCall(call = call, result = result)
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

        override fun onCreateActivity(activity: Activity) {
            mActivity = activity
        }

        override fun onDestroyActivity() {
           // mActivity = null
        }

        override fun onCreateLifecycle(lifecycle: Lifecycle) {
            mLifecycle = lifecycle
            lifecycle.addObserver(this@FlutterEcosedPlugin)
        }

        override fun onDestroyLifecycle() {
            lifecycle.removeObserver(this@FlutterEcosedPlugin)
        }

        /**
         * 引擎初始化时执行
         */
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

        /**
         * 引擎初始化.
         * @param context 上下文 - 此上下文来自FlutterPlugin的ApplicationContext
         */
        override fun onCreateEngine(context: Context) {
            when {
                (mPluginList == null) or (mBinding == null) -> pluginUnit(
                    context = context,
                    debug = mBaseDebug
                ) { plugin, binding ->
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
                            mPluginList?.add(element = item)
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

                else -> if (mBaseDebug) {
                    Log.e(pluginTag, "请勿重复执行attach!")
                }
            }
        }

        /**
         * 销毁引擎释放资源.
         */
        override fun onDestroyEngine() {

        }

        /**
         * 方法调用
         * 此方法通过Flutter插件代理类[FlutterPluginProxy]实现
         * 此方法等价与MethodCallHandler的onMethodCall方法
         * 但参数传递是依赖Bundle进行的
         */
        override fun onMethodCall(call: MethodCallProxy, result: ResultProxy) {
            try {
                // 执行代码并获取执行后的返回值
                mExecResult = execMethodCall<Any>(
                    channel = call.bundleProxy.getString("channel", engineChannelName),
                    method = call.methodProxy,
                    bundle = call.bundleProxy
                )
                // 判断是否为空并提交数据
                if (mExecResult != null) {
                    result.success(
                        resultProxy = mExecResult
                    )
                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
                // 抛出异常
                result.error(
                    errorCodeProxy = pluginTag,
                    errorMessageProxy = "engine: onMethodCall",
                    errorDetailsProxy = Log.getStackTraceString(e)
                )
            }
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
    private val mClient = object : EcosedPlugin(), ClientWrapper {

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
            mEcosedServicesIntent.action = EcosedManifest.action


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

    private lateinit var mDelegateBaseContext: Context

    /** 服务相当于整个服务类部分无法在大类中实现的方法在此实现并调用 */
    private val mService = object : EcosedPlugin(), ServiceWrapper {

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

        override fun attachBaseContext(base: Context?) {
            super.attachBaseContext(base)
            base?.let { context ->
                mDelegateBaseContext = context
            }
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

        override fun attachDelegateBaseContext() {
            mDelegate.attachBaseContext2(mDelegateBaseContext)
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

        override fun getDrawerToggleDelegate(): ActionBarDrawerToggle.Delegate? {
            return mDelegate.drawerToggleDelegate
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

        /**
         * ShizukuAPI内置方法
         */
        override fun destroy() = exitProcess(
            status = 0
        )

        /**
         * ShizukuAPI内置方法
         */
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
     * @param context 上下文
     * @param content 插件列表单元, 插件绑定器
     * @return content 返回值
     */
    private inline fun <R> pluginUnit(
        context: Context,
        debug: Boolean,
        content: (ArrayList<EcosedPlugin>, PluginBinding) -> R
    ): R = content.invoke(
        arrayListOf(mFramework, mEngine, mClient, mService, mNative),
        PluginBinding(context = context, debug = debug)
    )

    /**
     * 客户端回调调用单元
     * 绑定解绑调用客户端回调
     * @param content 客户端回调单元
     * @return content 返回值
     */
    private inline fun <R> clientUnit(
        content: ClientWrapper.() -> R,
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
     * Shizuku方法调用单元
     * 添加与移除Shizuku监听
     * @param content Shizuku
     * @return content 返回值
     */
    private inline fun <R> shizukuUnit(
        content: ShizukuWrapper.() -> R,
    ): R = content.invoke(mService)

    /**
     * AppCompat方法调用单元
     * 调用AppCompat包装器方法
     * @param content AppCompat
     * @return content 返回值
     */
    private inline fun <R> appCompatUnit(
        content: AppCompatWrapper.() -> R,
    ): R = content.invoke(mService)

    /**
     * Activity上下文调用单元
     * Activity生命周期观察者通过此调用单元执行基于Activity上下文的代码
     * @param content 内容
     * @return content 返回值
     */
    private inline fun <R> activityUnit(
        content: Activity.() -> R,
    ): R = content.invoke(mActivity ?: error(""))

    /**
     * 原生代码调用单元
     * 调用底层原生代码
     * @param content C++
     * @return content 返回值
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

    /**
     * 检查Shizuku权限
     */
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

    /**
     * 判断Shizuku是否已安装
     */
    private fun isShizukuInstalled(): Boolean {
        return if (AppUtils.isAppInstalled(EcosedManifest.ShizukuPackage)) {
            !Shizuku.isPreV11()
        } else false
    }

    /**
     * 判断是否支持谷歌基础服务
     */
    private fun isSupportGMS(): Boolean {
        val code = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(mActivity!!)
        return if (code == ConnectionResult.SUCCESS) true else {
            AppUtils.isAppInstalled(EcosedManifest.GmsPackage)
        }
    }

    /**
     * 请求权限
     */
    private fun requestPermissions() {
        try {
            Shizuku.requestPermission(0)
            PermissionUtils.permission(EcosedManifest.fakePackageSignature).request()
        } catch (e: IllegalStateException) {

        }

    }

    /**
     * 获取根视图
     */
    private fun findRootView(activity: Activity): View? {
        return when (activity) {
            is FlutterActivity -> findFlutterView(
                view = activity.window.decorView
            )

            else -> activity.window.decorView
        }
    }

    /**
     * 获取FlutterView
     */
    private fun findFlutterView(view: View?): FlutterView? {
        when (view) {
            is FlutterView -> return view
            is ViewGroup -> for (index in 0 until view.childCount) {
                return findFlutterView(view.getChildAt(index))
            }
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
                    clientUnit {
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
                    clientUnit {
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

    /**
     * 切换工具栏显示状态
     */
    private fun toggle() {
        if (isVisible) {
            hide()
        } else {
            show()
        }
    }

    /**
     * 隐藏工具栏
     */
    private fun hide() {
        mDelegate.supportActionBar?.hide()
        isVisible = false
        hideHandler.removeCallbacks(showPart2Runnable)
    }

    /**
     * 显示工具栏
     */
    private fun show() {
        isVisible = true
        hideHandler.postDelayed(showPart2Runnable, uiAnimatorDelay.toLong())
    }

    /**
     * 延时隐藏
     */
    private fun delayedHide() {
        hideHandler.removeCallbacks(hideRunnable)
        hideHandler.postDelayed(hideRunnable, autoHideDelayMillis.toLong())
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
                    clientUnit {
                        onEcosedUnbind()
                    }
                    null
                }
            } else {
                clientUnit {
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
        /** 服务Action */
        const val action: String = "io.ecosed.kit.action"

        /** Shizuku包名 */
        const val ShizukuPackage: String = "moe.shizuku.privileged.api"

        /** 谷歌基础服务包名 */
        const val GmsPackage: String = "com.google.android.gms"

        /** 签名伪装权限 */
        const val fakePackageSignature: String = "android.permission.FAKE_PACKAGE_SIGNATURE"
    }

    private companion object {

        init {
            // 加载C++代码
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


        const val mMethodDebug: String = "is_binding"
        const val mMethodIsBinding: String = "is_debug"
        const val mMethodStartService: String = "start_service"
        const val mMethodBindService: String = "bind_service"
        const val mMethodUnbindService: String = "unbind_service"
        const val mMethodShizukuVersion: String = "shizuku_version"


    }


}