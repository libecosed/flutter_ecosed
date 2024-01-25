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
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.Toast
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.blankj.utilcode.util.AppUtils
import com.blankj.utilcode.util.PermissionUtils
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import rikka.shizuku.Shizuku
import kotlin.system.exitProcess

class FlutterEcosedPlugin : Service(), FlutterPlugin, MethodChannel.MethodCallHandler,
    ActivityAware,
    ServiceConnection, LifecycleOwner, DefaultLifecycleObserver {


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
    private var mAIDL: EcosedKit? = null
    private var mIUserService: IUserService? = null

    /** 服务绑定状态 */
    private var mIsBind: Boolean = false


    private lateinit var poem: ArrayList<String>


    private val mUserServiceArgs = Shizuku.UserServiceArgs(
        ComponentName(AppUtils.getAppPackageName(), UserService().javaClass.name)
    )
        .daemon(false)
        .processNameSuffix("service")
        .debuggable(mFullDebug)
        .version(AppUtils.getAppVersionCode())


    private fun checkPermission(code: Int): Boolean {
        if (Shizuku.isPreV11()) {
            // Pre-v11 is unsupported
            return false
        }
        return if (Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED) {
            // Granted
            true
        } else if (Shizuku.shouldShowRequestPermissionRationale()) {
            // Users choose "Deny and don't ask again"
            false
        } else {
            // Request the permission
            Shizuku.requestPermission(code)
            false
        }
    }

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

//        val code = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(this@EcosedKitPlugin)
//        if (code == ConnectionResult.SUCCESS) {
//            // 有gms
//        } else {
//            GoogleApiAvailability.getInstance().makeGooglePlayServicesAvailable(mActivity)
//
//            if (GoogleApiAvailability.getInstance().isUserResolvableError(code)){
//                GoogleApiAvailability.getInstance().getErrorDialog(mActivity, code, 200)?.show()
//            }
//        }


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

    override fun onBind(intent: Intent): IBinder {
        return serviceUnit {
            return@serviceUnit getBinder(
                intent = intent
            )
        }
    }

    override fun onRebind(intent: Intent?) {
        super.onRebind(intent)
    }

    override fun onUnbind(intent: Intent?): Boolean {
        return super.onUnbind(intent)
    }

    override fun getLifecycle(): Lifecycle {
        return mLifecycle
    }

    override fun onDestroy() {
        super<Service>.onDestroy()
        // 移除Shizuku监听
        Shizuku.removeBinderDeadListener(mService)
        Shizuku.removeBinderReceivedListener(mService)
        Shizuku.removeRequestPermissionResultListener(mService)

        // 解绑Shizuku服务
        Shizuku.unbindUserService(mUserServiceArgs, this@FlutterEcosedPlugin, true)
    }

    // 插件附加到引擎
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        mMethodChannel = MethodChannel(binding.binaryMessenger, flutterChannelName)
        mMethodChannel.setMethodCallHandler(this@FlutterEcosedPlugin)

        binding.platformViewRegistry.registerViewFactory(
            viewTypeId, object : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

                override fun create(
                    context: Context?, viewId: Int, args: Any?
                ): PlatformView = object : PlatformView {

                    override fun getView(): View = frameworkUnit {
                        return@frameworkUnit getView(
                            context = context, viewId = viewId, args = args
                        )
                    }

                    override fun dispose() = frameworkUnit {
                        dispose()
                    }
                }
            }
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        mMethodChannel.setMethodCallHandler(null)
    }

    // 调用方法
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = frameworkUnit {
        onMethodCall(
            call = object : MethodCallProxy {

                override val methodProxy: String
                    get() = call.method

                override val bundleProxy: Bundle
                    get() = Bundle().apply {
                        putString(
                            "channel", call.argument<String>("channel")
                        )
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
                    errorDetailsProxy
                )

                override fun notImplemented() = result.notImplemented()
            }
        )
    }

    override fun onAttachedToActivity(
        binding: ActivityPluginBinding,
    ) = frameworkUnit {
        getActivity(activity = binding.activity)
        getLifecycle(lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding))
        attach()
    }

    override fun onDetachedFromActivityForConfigChanges() = Unit

    override fun onReattachedToActivityForConfigChanges(
        binding: ActivityPluginBinding,
    ) = frameworkUnit {
        getActivity(activity = binding.activity)
        getLifecycle(lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding))
    }

    override fun onDetachedFromActivity() = Unit

//    override val lifecycle: Lifecycle
//        get() = mLifecycle

    override fun onCreate(owner: LifecycleOwner) {
        super<DefaultLifecycleObserver>.onCreate(owner)
    }

    override fun onStart(owner: LifecycleOwner) {
        super<DefaultLifecycleObserver>.onStart(owner)
    }

    override fun onResume(owner: LifecycleOwner) {
        super<DefaultLifecycleObserver>.onResume(owner)
    }

    override fun onPause(owner: LifecycleOwner) {
        super<DefaultLifecycleObserver>.onPause(owner)
    }

    override fun onStop(owner: LifecycleOwner) {
        super<DefaultLifecycleObserver>.onStop(owner)
    }

    override fun onDestroy(owner: LifecycleOwner) {
        super<DefaultLifecycleObserver>.onDestroy(owner)
    }

    override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
        when (name?.className) {
            UserService().javaClass.name -> {
                if ((service != null) and (service?.pingBinder() == true)) {
                    mIUserService = IUserService.Stub.asInterface(service)
                }
                when {
                    mIUserService != null -> {
                        Toast.makeText(this, "mIUserService", Toast.LENGTH_SHORT)
                            .show()
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
                    mAIDL = EcosedKit.Stub.asInterface(service)
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
     ***********************************************************************************************
     * 分类: 内部基本接口方法
     ***********************************************************************************************
     */

    private interface FlutterPluginProxy {
        fun getActivity(activity: Activity)
        fun getLifecycle(lifecycle: Lifecycle)
        fun attach()
        fun onMethodCall(call: MethodCallProxy, result: ResultProxy)
        fun getView(context: Context?, viewId: Int, args: Any?): View
        fun dispose()
    }

    private interface MethodCallProxy {
        val methodProxy: String
        val bundleProxy: Bundle
    }

    private interface ResultProxy {
        fun success(resultProxy: Any?)
        fun error(errorCodeProxy: String, errorMessageProxy: String?, errorDetailsProxy: Any?)
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
            errorDetails: Any?
        ): Nothing

        /**
         * 处理对未实现方法的调用.
         */
        fun notImplemented()
    }

    private interface EngineWrapper : FlutterPluginProxy {
        fun <T> execMethodCall(channel: String, method: String, bundle: Bundle?): T?
    }

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

    private interface ServiceWrapper {
        fun getBinder(intent: Intent): IBinder
    }

    private interface NativeWrapper {
        fun main()
    }

    /**
     * 作者: wyq0918dev
     * 仓库: https://github.com/ecosed/EcosedDroid
     * 时间: 2023/10/01
     * 描述: 基本插件
     * 文档: https://github.com/ecosed/EcosedDroid/blob/master/README.md
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

        /** 需要子类重写的通道名称 */
        abstract val channel: String
        abstract val title: String
        abstract val description: String
        abstract val author: String
        abstract val version: String

        /** 供子类使用的判断调试模式的接口 */
        protected val isDebug: Boolean = mDebug

        /**
         * 插件调用方法
         */
        open fun onEcosedMethodCall(call: EcosedMethodCall, result: EcosedResult) = Unit
    }

    /**
     * 作者: wyq0918dev
     * 仓库: https://github.com/ecosed/plugin
     * 时间: 2023/09/02
     * 描述: 插件绑定器
     * 文档: https://github.com/ecosed/plugin/blob/master/README.md
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
     * 作者: wyq0918dev
     * 仓库: https://github.com/ecosed/plugin
     * 时间: 2023/09/02
     * 描述: 插件通信通道
     * 文档: https://github.com/ecosed/plugin/blob/master/README.md
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
                    call = call,
                    result = result
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
                errorCode: String,
                errorMessage: String?,
                errorDetails: Any?
            ): Nothing = error(
                message = "错误代码:$errorCode\n" +
                        "错误消息:$errorMessage\n" +
                        "详细信息:$errorDetails"
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
     * 分类: 关键内部类
     ***********************************************************************************************
     */

    private val mFramework = object : EcosedPlugin(), FlutterPluginProxy {

        override val channel: String
            get() = frameworkChannelName
        override val title: String
            get() = "Framework"
        override val description: String
            get() = "Ecosed Framework"
        override val author: String
            get() = defaultAuthor
        override val version: String
            get() = "1"

        override fun onEcosedAdded(binding: PluginBinding) {
            super.onEcosedAdded(binding)
        }

        override fun onEcosedMethodCall(call: EcosedMethodCall, result: EcosedResult) {
            super.onEcosedMethodCall(call, result)
        }

        override fun getActivity(activity: Activity) = engineUnit {
            getActivity(activity = activity)
        }

        override fun getLifecycle(lifecycle: Lifecycle) = engineUnit {
            getLifecycle(lifecycle = lifecycle)
        }

        override fun onMethodCall(call: MethodCallProxy, result: ResultProxy) = engineUnit {
            onMethodCall(call = call, result = result)
        }

        override fun getView(context: Context?, viewId: Int, args: Any?): View = engineUnit {
            return@engineUnit getView(context = context, viewId = viewId, args = args)
        }

        override fun dispose() = engineUnit {
            dispose()
        }

        override fun attach() = engineUnit {
            attach()
        }
    }


    private val mEngine = object : EcosedPlugin(), EngineWrapper {

        override val channel: String
            get() = engineChannelName
        override val title: String
            get() = "Engine"
        override val description: String
            get() = "Ecosed Engine"
        override val author: String
            get() = "wyq0918dev"
        override val version: String
            get() = "1"

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
            // 添加生命周期观察者
            lifecycle.addObserver(this@FlutterEcosedPlugin)
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
                result.error(pluginTag, "", Log.getStackTraceString(e))
            }
        }

        override fun getView(context: Context?, viewId: Int, args: Any?): View {
            return Button(context).apply {
                layoutParams = ViewGroup.LayoutParams(100, 100)
                text = "Button"
                setOnClickListener {
                    Toast.makeText(mActivity, "Button", Toast.LENGTH_SHORT).show()
                }
            }
        }

        override fun dispose() {
        }

        /**
         * 将引擎附加到应用.
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
                                    put("version", version)
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

    private val mClient = object : EcosedPlugin(), EcosedCallBack {

        override val channel: String
            get() = clientChannelName
        override val title: String
            get() = "Client"
        override val description: String
            get() = "Ecosed Client"
        override val author: String
            get() = "wyq0918dev"
        override val version: String
            get() = "1"

        override fun onEcosedAdded(binding: PluginBinding) = run {
            super.onEcosedAdded(binding)
            mEcosedServicesIntent = Intent(this@run, this@FlutterEcosedPlugin.javaClass)
            mEcosedServicesIntent.action = action


            startService(mEcosedServicesIntent)
            bindEcosed(this@run)

            Toast.makeText(this@run, "client", Toast.LENGTH_SHORT).show()


        }

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

        override fun onEcosedConnected() {
            Toast.makeText(this, "onEcosedConnected", Toast.LENGTH_SHORT).show()
        }

        override fun onEcosedDisconnected() {
            Toast.makeText(this, "onEcosedDisconnected", Toast.LENGTH_SHORT).show()
        }

        override fun onEcosedDead() {
            Toast.makeText(this, "onEcosedDead", Toast.LENGTH_SHORT).show()
        }

        override fun onEcosedUnbind() {
            Toast.makeText(this, "onEcosedUnbind", Toast.LENGTH_SHORT).show()
        }
    }

    private val mService = object : EcosedPlugin(), ServiceWrapper,
        Shizuku.OnBinderReceivedListener,
        Shizuku.OnBinderDeadListener,
        Shizuku.OnRequestPermissionResultListener {

        override val channel: String
            get() = serviceChannelName
        override val title: String
            get() = "Service"
        override val description: String
            get() = "Ecosed Service"
        override val author: String
            get() = "wyq0918dev"
        override val version: String
            get() = "1"

        override fun getBinder(intent: Intent): IBinder {
            return object : EcosedKit.Stub() {
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
            Toast.makeText(this, "onRequestPermissionResult", Toast.LENGTH_SHORT)
                .show()
        }
    }

    private val mNative = object : EcosedPlugin(), NativeWrapper {

        override val channel: String
            get() = nativeChannelName
        override val title: String
            get() = "Native"
        override val description: String
            get() = "Ecosed Native"
        override val author: String
            get() = "wyq0918dev"
        override val version: String
            get() = "1"

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


        override fun destroy() {
            exitProcess(status = 0)
        }

        override fun exit() {
            exitProcess(status = 0)
        }

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
    private fun <R> frameworkUnit(
        content: FlutterPluginProxy.() -> R,
    ): R = content.invoke(mFramework)

    /**
     * 引擎调用单元
     * 框架调用引擎
     * @param content 引擎包装器单元
     * @return content 返回值
     */
    private fun <R> engineUnit(
        content: EngineWrapper.() -> R,
    ): R = content.invoke(mEngine)

    /**
     * 插件调用单元
     * 插件初始化
     * @param content 插件列表单元, 插件绑定器
     * @return content 返回值
     */
    private fun <R> pluginUnit(
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
    private fun <R> callBackUnit(
        content: EcosedCallBack.() -> R,
    ): R = content.invoke(mClient)


    private fun <R> serviceUnit(
        content: ServiceWrapper.() -> R,
    ): R = content.invoke(mService)

    private fun <R> nativeUnit(
        content: NativeWrapper.() -> R,
    ): R = content.invoke(mNative)

    /**
     ***********************************************************************************************
     * 分类: 原生调用
     ***********************************************************************************************
     */

    private external fun main(args: Array<String>)

    /**
     ***********************************************************************************************
     * 分类: 私有函数
     ***********************************************************************************************
     */

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
                    mEcosedServicesIntent,
                    this@FlutterEcosedPlugin,
                    Context.BIND_AUTO_CREATE
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

        // 打印日志的标签
        const val pluginTag: String = "FlutterEcosedPlugin"

        const val viewTypeId: String = "ecosed_view"

        // Flutter插件通道名称
        const val flutterChannelName = "flutter_ecosed"

        // Ecosed插件通道名称
        const val frameworkChannelName: String = "ecosed_framework"
        const val engineChannelName: String = "ecosed_engine"
        const val clientChannelName: String = "ecosed_client"
        const val serviceChannelName: String = "ecosed_service"
        const val nativeChannelName: String = "ecosed_native"

        const val defaultAuthor: String = "wyq0918dev"

        const val action: String = "io.ecosed.kit.action"


        const val mMethodDebug: String = "is_binding"
        const val mMethodIsBinding: String = "is_debug"
        const val mMethodStartService: String = "start_service"
        const val mMethodBindService: String = "bind_service"
        const val mMethodUnbindService: String = "unbind_service"
        const val mMethodShizukuVersion: String = "shizuku_version"


    }
}