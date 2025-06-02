package com.example.nugget_flutter_plugin

import android.content.Context
import android.app.Application
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.zomato.chatsdk.init.ChatSdk
import com.zomato.chatsdk.chatcorekit.init.ChatSdkAccessTokenData
import com.zomato.chatsdk.chatcorekit.init.ChatSdkInitConfig
import com.zomato.chatsdk.chatcorekit.network.request.BusinessContext
import com.zomato.chatsdk.init.ChatSDKInitCommunicator
import android.content.Intent
import com.zomato.chatsdk.activities.ChatSDKDeepLinkRouter
import com.zomato.sushilib.annotations.FontWeight
import android.util.Log
import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.util.concurrent.CompletableFuture
import java.util.concurrent.TimeUnit
import android.os.Handler
import android.os.Looper
import java.util.UUID
import com.zomato.chatsdk.utils.ChatFCMTokenManager
import com.zomato.chatsdk.chatcorekit.init.ChatSdkNotificationsData
import com.example.nugget_flutter_plugin.R
import kotlin.coroutines.suspendCoroutine
import kotlin.coroutines.Continuation
import kotlin.coroutines.resume
import java.util.concurrent.ConcurrentHashMap
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeout
import kotlinx.coroutines.TimeoutCancellationException

/**
 * Created by Kunal Chhabra on 18 May 2025
 * Zomato , Gurugram , India
 */
class NuggetFlutterPlugin : FlutterPlugin, MethodCallHandler , ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var application: Application
    private var isInitialized = false
    private var activity: Activity? = null
    private var fontMapping : Map<String , String> = mutableMapOf()

    private val pendingRequests = ConcurrentHashMap<String, Continuation<ChatSdkAccessTokenData>>()

    companion object {
        const val CHANNEL_NAME = "nugget_flutter_plugin"
        const val METHOD_INITIALIZE = "initialize"
        const val METHOD_ACCESS_TOKEN_RESPONSE = "accessTokenResponse"
        const val METHOD_OPEN_CHAT = "openChatWithCustomDeeplink"
        const val METHOD_SYNC_FCM_TOKEN = "syncFCMToken"
        const val METHOD_FETCH_ACCESS_TOKEN_FROM_CLIENT = "fetchAccessTokenFromClient"

        const val TIMEOUT_DURATION = 15000L // milliseconds
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        context = flutterPluginBinding.applicationContext
        application = context as Application
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            METHOD_INITIALIZE -> {

                val fontData = call.argument<String>("fontData") as? Map<*, *>
                val fontWeightMapping = fontData?.get("fontWeightMapping") as? Map<*, *>

                fontMapping = fontWeightMapping?.mapNotNull { (key, value) ->
                    val weightName = key as? String
                    val styleName = value as? String

                    if (weightName != null && styleName != null) {
                        weightName to styleName
                    } else null
                }?.toMap() ?: mutableMapOf()


                val businessContext = call.argument<String>("businessContext") as? Map<* , *>

                val channelHandle = businessContext?.get("channelHandle") as? String
                val ticketGroupingId = businessContext?.get("ticketGroupingId") as? String
                val ticketProperties = businessContext?.get("ticketProperties") as? HashMap<String , ArrayList<String>>
                val botProperties = businessContext?.get("botProperties") as? HashMap<String , ArrayList<String>>

                try {
                    ChatSdk.initialize(
                        application,
                        initInterface = object : ChatSDKInitCommunicator {
                            override suspend fun getAccessTokenData(): ChatSdkAccessTokenData {
                                return getAccessTokenDataFromClient()
                            }

                            override fun getBusinessContext(): BusinessContext {
                                return BusinessContext(
                                    channelHandle = channelHandle,
                                    ticketGroupingId = ticketGroupingId,
                                    botProperties = botProperties,
                                    ticketProperties = ticketProperties
                                )
                            }

                            override suspend fun getRefreshToken(): String {
                                return getAccessTokenDataFromClient().accessToken ?: ""
                            }

                            override fun getTextAppearance(fontWeight: Int): Int? {

                                val styleName = when(fontWeight){
                                    100 -> fontMapping["thin"]
                                    200 -> fontMapping["extralight"]
                                    300 -> fontMapping["light"]
                                    400 -> fontMapping["regular"]
                                    500 -> fontMapping["medium"]
                                    600 -> fontMapping["semibold"]
                                    700 -> fontMapping["bold"]
                                    800 -> fontMapping["extrabold"]
                                    else -> null
                                }

                                val resolvedStyle = getStyleResourceId(activity , styleName?.replace(Regex("[^A-Za-z0-9]"), ""))
                                return resolvedStyle
                            }
                        },
                        initConfig = ChatSdkInitConfig(
                            namespace =  call.argument<String>("namespace") ?: ""
                        ))

                    isInitialized = true
                    result.success(true)
                } catch (e: Exception) {
                    result.error(
                        "INITIALIZATION_FAILED",
                        "Failed to initialize the SDK: ${e.message}",
                        null
                    )
                }
            }

            METHOD_ACCESS_TOKEN_RESPONSE -> {
                val token = call.argument<String>("token") ?: ""
                val statusCode = call.argument<Int>("httpCode") ?: -1
                val requestId = call.argument<String>("requestId")

                val continuation = pendingRequests.remove(requestId)

                if (continuation != null) {
                    continuation.resume(ChatSdkAccessTokenData(token, statusCode))
                }

                result.success(true)
            }

            METHOD_OPEN_CHAT -> {
                if (!isInitialized) {
                    result.error(
                        "NOT_INITIALIZED",
                        "SDK not initialized. Call initialize() first",
                        null
                    )
                    return
                }

                try {

                    val deeplink = call.argument<String>("customDeeplink") ?: ""

                    val intent = Intent(context, ChatSDKDeepLinkRouter::class.java)
                    intent.putExtra(
                        "uri",
                        deeplink
                    )

                    activity?.startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("CHAT_START_FAILED", "Failed to start chat: ${e.message}", null)
                }
            }

            METHOD_SYNC_FCM_TOKEN -> {

                val fcmToken = call.argument<String>("fcmToken") ?: ""
                val notifsEnabled = call.argument<Boolean>("notifsEnabled") ?: false

                ChatFCMTokenManager.syncFCMTokenWithServer(
                    notificationData = ChatSdkNotificationsData(
                        token = fcmToken,
                        notificationEnabled = (notifsEnabled == true)
                    )
                )
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private suspend fun getAccessTokenDataFromClient(): ChatSdkAccessTokenData {
        return try {
            withTimeout(TIMEOUT_DURATION) {
                suspendCancellableCoroutine { continuation ->

                    val requestId = UUID.randomUUID().toString()

                    // Store continuation to resume later
                    pendingRequests[requestId] = continuation

                    // Remove continuation if coroutine is cancelled (timeout or manual cancellation)
                    continuation.invokeOnCancellation {
                        pendingRequests.remove(requestId)
                    }

                    // Call Dart side method channel on main thread
                    Handler(Looper.getMainLooper()).post {
                        channel.invokeMethod(
                            METHOD_FETCH_ACCESS_TOKEN_FROM_CLIENT,
                            mapOf("requestId" to requestId)
                        )
                    }
                }
            }
        } catch (e: TimeoutCancellationException) {
            // Timeout happened, return fallback or error object
            ChatSdkAccessTokenData("", -1)
        } catch (e: Exception) {
            // Any other exception fallback
            ChatSdkAccessTokenData("", -1)
        }
    }

    private fun getStyleResourceId(context: Context?, styleName: String?): Int? {
        if (context == null || styleName == null) return null
        return context.resources.getIdentifier(styleName, "style", context.packageName)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }
}
