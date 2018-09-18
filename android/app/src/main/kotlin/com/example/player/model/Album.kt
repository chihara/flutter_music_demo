package com.example.player.model

import java.util.HashMap

class Album(
        private val id: Long,
        private val title: String,
        private val artist: String = "",
        private val albumArt: String = "",
        private val numOfTracks: Long
) {

    fun toMap(): HashMap<String, Any> {
        val map = HashMap<String, Any>()
        map["id"] = id as Any
        map["title"] = title as Any
        map["artist"] = artist as Any
        map["albumArt"] = albumArt as Any
        map["numOfTracks"] = numOfTracks as Any
        return map
    }
}