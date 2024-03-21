package io.libecosed.flutter_ecosed

import android.util.Log
import kotlin.system.exitProcess

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

    /**
     * 原生代码执行入口
     * @param args 要传入的附加参数
     */
    private external fun main(args: Array<String>)

    companion object {
        init {
            // 加载C++代码
            System.loadLibrary("flutter_ecosed")
        }
    }
}