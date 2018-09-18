package com.example.player.model

import java.io.Serializable
import java.util.HashMap

class Song(
        val id: Long,
        val title: String,
        val artist: String = "",
        val album: String = "",
        val albumArt: String = "",
        val track: Int = 0,
        val duration: Long = 0,
        val data: String
): Serializable {

    var elapsed: Int = 0

    fun toMap(): HashMap<String, Any> {
        val map = HashMap<String, Any>()
        map["id"] = id as Any
        map["title"] = title as Any
        map["artist"] = artist as Any
        map["album"] = album as Any
        map["albumArt"] = albumArt as Any
        map["track"] = track as Any
        map["duration"] = duration as Any
        map["data"] = data as Any
        map["elapsed"] = elapsed as Any
        return map
    }

    companion object {
        fun fromMap(map: Map<String, Any>?): Song {
            return Song(
                    id = map?.get("id").toString().toLong(),
                    title = map?.get("title").toString(),
                    artist = map?.get("artist").toString(),
                    album = map?.get("album").toString(),
                    albumArt = map?.get("albumArt").toString(),
                    track = map?.get("track").toString().toInt(),
                    duration = map?.get("duration").toString().toLong(),
                    data = map?.get("data").toString()
            )
        }
    }
}