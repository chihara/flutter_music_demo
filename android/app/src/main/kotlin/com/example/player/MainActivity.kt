package com.example.player

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import com.example.player.plugin.MediaPlugin

class MainActivity: FlutterActivity() {

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    MediaPlugin.registerWith(registrarFor("com.example.player.plugin.MediaPlugin"))
  }
}
