package com.example.player.util

import java.util.TimerTask
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit

/** 指定周期でリスナーを呼ぶタイマー */
class FrequencyTimer(private val frequency: Long, var listener: ExpiredListener?) {

    constructor(frequency: Long): this(frequency, null)

    private var scheduler: ScheduledExecutorService? = null
    private var future: ScheduledFuture<*>? = null
    private var task: UpdateTask? = null

    interface ExpiredListener {
        fun onExpired()
    }

    fun start() {
        scheduler?.let { it ->
            while (it.isShutdown) {
                try {
                    Thread.sleep(100)
                } catch (e: InterruptedException) {
                }
            }
        }
        task?.cancel()
        task = UpdateTask()
        scheduler?.shutdown()
        scheduler = Executors.newSingleThreadScheduledExecutor()
        future = scheduler?.scheduleAtFixedRate(task, 0, frequency, TimeUnit.MILLISECONDS)
        listener?.onExpired()
    }

    fun pause() {
        listener?.onExpired()
        future?.cancel(true)
    }

    fun stop() {
        task?.cancel()
        task = null
        scheduler?.shutdown()
        scheduler = null
    }

    private inner class UpdateTask : TimerTask() {
        override fun run() {
            listener?.onExpired()
        }
    }
}
