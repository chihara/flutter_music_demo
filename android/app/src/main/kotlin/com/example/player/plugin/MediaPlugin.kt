package com.example.player.plugin

import android.app.Activity
import android.media.MediaPlayer
import android.net.Uri
import com.example.player.model.Song
import com.example.player.permission.Permission
import com.example.player.permission.PermissionManager
import com.example.player.repository.MediaRepository
import com.example.player.util.FrequencyTimer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class MediaPlugin private constructor(
        activity: Activity,
        val channel: MethodChannel
): MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    private val context = activity.applicationContext
    private var permissionManager = PermissionManager(activity)
    private val player = MediaPlayer()
    private val timer = FrequencyTimer(200)
    private var song: Song? = null
    private var currentData: String? = null
    private var isPaused: Boolean = false


    init {
        player.setOnPreparedListener { it ->
            it.start()
            channel.invokeMethod("onPlay", null)
            timer.start()
        }
        player.setOnCompletionListener { _ ->
            currentData = null
            channel.invokeMethod("onComplete", null)
            timer.stop()
        }
        timer.listener = object: FrequencyTimer.ExpiredListener {
            override fun onExpired() {
                song?.elapsed = player.currentPosition
                channel.invokeMethod("onPlaying", song?.toMap())
            }
        }
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val params = call.arguments() as Map<String, Any>?
        when (call.method) {
            "getSongs" -> {
                if (permissionManager.granted(Permission.READ_EXTERNAL_STORAGE)) {
                    getSongs(params, result)
                } else {
                    permissionManager.request(Permission.READ_EXTERNAL_STORAGE)
                }
            }
            "getAlbums" -> {
                if (permissionManager.granted(Permission.READ_EXTERNAL_STORAGE)) {
                    getAlbums(result)
                } else {
                    permissionManager.request(Permission.READ_EXTERNAL_STORAGE)
                }
            }
            "play" -> {
                song = Song.fromMap(params)
                song?.let { it ->
                    if (!it.data.isEmpty()) {
                        if (it.data != currentData) {
                            currentData = it.data
                            player.reset()
                            player.setDataSource(context, Uri.parse(it.data))
                            player.prepareAsync()
                            isPaused = false
                        } else if (player.isPlaying) {
                            if (!isPaused) {
                                player.pause()
                                isPaused = true
                                channel.invokeMethod("onPause", null)
                                timer.pause()
                            }
                        } else {
                            player.start()
                            isPaused = false
                            channel.invokeMethod("onPlay", null)
                            timer.start()
                        }
                        result.success(null)
                    } else {
                        result.error("argument", "Invalid argument, need 'uri' parameter.", null)
                    }
                }
            }
            "seek" -> {
                val position: Int? = params?.get("position").toString().toInt()
                if (null != position) {
                    player.seekTo(position)
                    timer.listener?.onExpired()
                }
                result.success(null)
            }
            else -> {
                result.error("method", "Not supported method.", null)
            }
        }
    }

    override fun onRequestPermissionsResult(
            requestCode: Int, permissions: Array<String>, grantResults: IntArray): Boolean {
        if (permissionManager.validateRequestCode(requestCode)) {
            if (permissionManager.verifyGrantResults(grantResults)) {
                channel.invokeMethod("onGranted", null)
            }
            return true
        }
        return false
    }

    private fun getSongs(param: Map<String, Any>?, result: MethodChannel.Result?) {
        val maps = mutableListOf<HashMap<String, Any>>()
        val songs = MediaRepository(context).getSongs(param?.get("albumId")?.toString()?.toInt())
        songs.forEach { maps.add(it.toMap()) }
        result?.success(maps)
    }

    private fun getAlbums(result: MethodChannel.Result?) {
        val maps = mutableListOf<HashMap<String, Any>>()
        val albums = MediaRepository(context).getAlbums()
        albums.forEach { maps.add(it.toMap()) }
        result?.success(maps)
    }



    companion object {
        @JvmStatic fun registerWith(registrar: PluginRegistry.Registrar) {
            val channel = MethodChannel(registrar.messenger(), "com.example.player/media")
            val instance = MediaPlugin(registrar.activity(), channel)
            registrar.addRequestPermissionsResultListener(instance)
            channel.setMethodCallHandler(instance)
        }
    }
}