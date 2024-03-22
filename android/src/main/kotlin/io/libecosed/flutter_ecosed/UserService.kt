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