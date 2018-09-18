package com.example.player.permission

import android.Manifest

/**
 * Created by chihara on 2016/08/15.
 */
enum class Permission(val declaration: String) {
    // CALENDAR group
    READ_CALENDAR(Manifest.permission.READ_CALENDAR),
    WRITE_CALENDAR(Manifest.permission.WRITE_CALENDAR),
    // CAMERA group
    CAMERA(Manifest.permission.CAMERA),
    // CONTACTS group
    READ_CONTACTS(Manifest.permission.READ_CONTACTS),
    WRITE_CONTACTS(Manifest.permission.WRITE_CONTACTS),
    GET_ACCOUNTS(Manifest.permission.GET_ACCOUNTS),
    // LOCATION group
    ACCESS_FINE_LOCATION(Manifest.permission.ACCESS_FINE_LOCATION),
    ACCESS_COARSE_LOCATION(Manifest.permission.ACCESS_COARSE_LOCATION),
    // MICROPHONE group
    RECORD_AUDIO(Manifest.permission.RECORD_AUDIO),
    // PHONE group
    READ_PHONE_STATE(Manifest.permission.READ_PHONE_STATE),
    CALL_PHONE(Manifest.permission.CALL_PHONE),
    READ_CALL_LOG(Manifest.permission.READ_CALL_LOG),
    WRITE_CALL_LOG(Manifest.permission.WRITE_CALL_LOG),
    ADD_VOICEMAIL(Manifest.permission.ADD_VOICEMAIL),
    USE_SIP(Manifest.permission.USE_SIP),
    PROCESS_OUTGOING_CALLS(Manifest.permission.PROCESS_OUTGOING_CALLS),
    // SENSORS group
    BODY_SENSORS(Manifest.permission.BODY_SENSORS),
    // SMS group
    SEND_SMS(Manifest.permission.SEND_SMS),
    RECEIVE_SMS(Manifest.permission.RECEIVE_SMS),
    READ_SMS(Manifest.permission.READ_SMS),
    RECEIVE_WAP_PUSH(Manifest.permission.RECEIVE_WAP_PUSH),
    RECEIVE_MMS(Manifest.permission.RECEIVE_MMS),
    // STORAGE group
    READ_EXTERNAL_STORAGE(Manifest.permission.READ_EXTERNAL_STORAGE),
    WRITE_EXTERNAL_STORAGE(Manifest.permission.WRITE_EXTERNAL_STORAGE),
    ;

    companion object {
        fun get(declarations: Array<out String>): Array<Permission> {
            val permissions = mutableListOf<Permission>()
            declarations.forEach { it ->
                val permission = get(it)
                permission?.let { permissions.add(permission) }
            }
            return permissions.toTypedArray()
        }

        fun get(declaration: String): Permission? {
            values().forEach { if (it.declaration == declaration) return it }
            return null
        }
    }
}