package com.example.player.permission

import android.app.Activity
import android.app.Fragment
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.support.v4.content.PermissionChecker

/**
 * Created by chihara on 2016/08/15.
 */
@Suppress(names = ["unused"])
class PermissionManager(private val activity: Activity) {

    private val context: Context = activity.applicationContext
    private var requestedCode: Int = 0

    constructor(fragment: Fragment): this(fragment.activity as Activity)

    /** 権限の付加状態を確認 */
    fun granted(permission: Permission): Boolean {
        return when (PermissionChecker.checkSelfPermission(context, permission.declaration)) {
            PermissionChecker.PERMISSION_GRANTED -> true
            else -> false
        }
    }

    /** 複数の権限の付加状態を確認 */
    fun granted(permissions: Array<Permission>): Boolean {
        var granted = true
        permissions.forEach { granted = granted.and(granted(it)) }
        return granted
    }


    /** 権限の要求 */
    fun request(permission: Permission, requestCode: Int = PERMISSION_REQUEST_CODE) {
        if (Build.VERSION_CODES.M > Build.VERSION.SDK_INT)
            return
        requestedCode = requestCode
        activity.requestPermissions(arrayOf(permission.declaration), requestCode)
    }

    /** 複数の権限の要求 */
    fun request(permissions: Array<Permission>, requestCode: Int = PERMISSION_REQUEST_CODE) {
        if (Build.VERSION_CODES.M > Build.VERSION.SDK_INT)
            return
        val notGrantedPermissions = mutableListOf<String>()
        permissions.forEach { if (!granted(it)) notGrantedPermissions.add(it.declaration) }
        requestedCode = requestCode
        activity.requestPermissions(notGrantedPermissions.toTypedArray(), requestCode)
    }


    /** 権限要求を「これ以上表示しない」設定にされているか確認 */
    fun showRationale(permission: Permission): Boolean {
        if (Build.VERSION_CODES.M > Build.VERSION.SDK_INT)
            return true
        return activity.shouldShowRequestPermissionRationale(permission.declaration)
    }

    /** 複数の権限要求を「これ以上表示しない」設定にされているか確認 */
    fun showRationale(permissions: Array<Permission>): Boolean {
        if (Build.VERSION_CODES.M > Build.VERSION.SDK_INT)
            return true
        var rationale = true
        permissions.forEach { rationale = rationale.and(showRationale(it)) }
        return rationale
    }


    /** 権限要求結果の確認 */
    fun verifyGrantResults(results: IntArray): Boolean {
        if (results.isEmpty()) return false
        results.forEach { if (PermissionChecker.PERMISSION_GRANTED != it) return false }
        return true
    }

    /** 権限要求結果から付与されていない権限を抽出 */
    fun extractNotGrantedResults(permissions: Array<String>, results: IntArray): Array<Permission> {
        return results
                .zip(permissions)
                .filter { (result, _) -> PermissionChecker.PERMISSION_GRANTED != result }
                .mapNotNull { it -> Permission.get(it.second) }
                .toTypedArray()
    }


    /** リクエストコードの検証 */
    fun validateRequestCode(requestCode: Int): Boolean {
        return requestedCode == requestCode
    }


    /** アプリの設定画面を開く */
    fun openSettingActivity() {
        val uri = "package:${activity.packageName}"
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse(uri))
        activity.startActivity(intent)
    }


    companion object {
        private const val PERMISSION_REQUEST_CODE: Int = 101
    }
}