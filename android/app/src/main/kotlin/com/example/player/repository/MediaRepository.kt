package com.example.player.repository

import android.content.Context
import com.example.player.model.Album
import com.example.player.model.Song
import android.database.Cursor
import android.provider.MediaStore

class MediaRepository(private val context: Context) {

    fun getSongs(albumId: Int? = null): List<Song> {
        var where = MediaStore.Audio.Media.IS_MUSIC + "=1"
        var sort = MediaStore.Audio.Media.TITLE
        albumId?.let { it ->
            where = MediaStore.Audio.Media.ALBUM_ID + "=" +it
            sort = MediaStore.Audio.Media.TRACK
        }
        val songs = mutableListOf<Song>()
        val resolver = context.contentResolver
        val songCursor: Cursor? = resolver.query(
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, //データの種類
                null,   //取得する項目 nullは全部
                where,  //フィルター条件 nullはフィルタリング無し
                null,   //フィルター用のパラメータ
                sort    //並べ替え
        )
        try {
            while (null != songCursor && songCursor.moveToNext()) {
                val id = songCursor.getLong(songCursor.getColumnIndex(MediaStore.Audio.Media.ALBUM_ID))
                var albumArt = ""
                val albumCursor: Cursor? = resolver.query(
                        MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,  //データの種類
                        arrayOf(
                                MediaStore.Audio.Albums.ALBUM_ART
                        ), //null, //取得する項目 nullは全部
                        MediaStore.Audio.Albums._ID + "=" + id,  //フィルター条件 nullはフィルタリング無し
                        null, //フィルター用のパラメータ
                        null  //並べ替え
                )
                try {
                    if (null != albumCursor && albumCursor.moveToNext()) {
                        albumCursor.getString(0)?.let { uri -> albumArt = uri }
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                } finally {
                    albumCursor?.close()
                }
                songs.add(Song(
                        songCursor.getLong(songCursor.getColumnIndex(MediaStore.Audio.Media._ID)),
                        songCursor.getString(songCursor.getColumnIndex(MediaStore.Audio.Media.TITLE)),
                        songCursor.getString(songCursor.getColumnIndex(MediaStore.Audio.Media.ARTIST)),
                        songCursor.getString(songCursor.getColumnIndex(MediaStore.Audio.Media.ALBUM)),
                        albumArt,
                        songCursor.getInt(songCursor.getColumnIndex(MediaStore.Audio.Media.TRACK)),
                        songCursor.getLong(songCursor.getColumnIndex(MediaStore.Audio.Media.DURATION)),
                        songCursor.getString(songCursor.getColumnIndex(MediaStore.Audio.Media.DATA))
                ))
            }
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            songCursor?.close()
        }
        return songs
    }

    fun getAlbums(): List<Album> {
        val albums = mutableListOf<Album>()
        val resolver = context.contentResolver
        val albumCursor: Cursor? = resolver.query(
                MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,  //データの種類
                null,   //取得する項目 nullは全部
                null,   //フィルター条件 nullはフィルタリング無し
                null,   //フィルター用のパラメータ
                MediaStore.Audio.Albums.ALBUM    //並べ替え
        )
        try {
            while (null != albumCursor && albumCursor.moveToNext()) {
                var albumArt = albumCursor.getString(albumCursor.getColumnIndex(MediaStore.Audio.Albums.ALBUM_ART))
                if (null == albumArt)
                    albumArt = ""
                albums.add(Album(
                        albumCursor.getLong(albumCursor.getColumnIndex(MediaStore.Audio.Albums._ID)),
                        albumCursor.getString(albumCursor.getColumnIndex(MediaStore.Audio.Albums.ALBUM)),
                        albumCursor.getString(albumCursor.getColumnIndex(MediaStore.Audio.Albums.ARTIST)),
                        albumArt,
                        albumCursor.getLong(albumCursor.getColumnIndex(MediaStore.Audio.Albums.NUMBER_OF_SONGS))
                ))
            }
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            albumCursor?.close()
        }
        return albums
    }
}