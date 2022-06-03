package com.example.coinbit
import android.util.Log
import androidx.annotation.NonNull
import com.walletconnect.walletconnectv2.client.Sign
import com.walletconnect.walletconnectv2.client.SignClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import kotlin.collections.HashMap

class MainActivity: FlutterFragmentActivity() {

    private val CHANNEL = "walletconnectv2"

    private val TAG = "WalletConnectV2";

    private lateinit var channel: MethodChannel

    private val wcHandler = object : SignClient.WalletDelegate {

        override fun onConnectionStateChange(state: Sign.Model.ConnectionState) {
            Log.e(TAG, "onConnectionStateChange: ${state.isAvailable}")
            runOnUiThread {
                channel.invokeMethod("onConnectionStateChange", state.isAvailable, object : Result {
                    override fun success(result: Any?) {
                        Log.e(TAG, "SUCCESS onConnectionStateChange")
                    }
                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        Log.e(TAG, "ERROR onConnectionStateChange")
                    }
                    override fun notImplemented() {
                        Log.e(TAG, "NOT IMPLEMENTED onConnectionStateChange")
                    }
                })
            }
        }

        override fun onSessionDelete(deletedSession: Sign.Model.DeletedSession) {
            Log.e(TAG, "onSessionDelete : ${Gson().toJson(deletedSession)}")
            runOnUiThread {
                channel.invokeMethod("onSessionDelete", Gson().toJson(deletedSession), object : Result {

                    override fun success(result: Any?) {
                        Log.e(TAG, "SUCCESS onSessionDelete")
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        Log.e(TAG, "ERROR onSessionDelete")
                    }

                    override fun notImplemented() {
                        Log.e(TAG, "NOT IMPLEMENTED onSessionDelete")
                    }
                })
            }
        }

        override fun onSessionProposal(sessionProposal: Sign.Model.SessionProposal) {
            Log.e(TAG, "onSessionProposal : ${Gson().toJson(sessionProposal)}")
            runOnUiThread {
                channel.invokeMethod("onSessionProposal", Gson().toJson(sessionProposal), object : Result {

                    override fun success(result: Any?) {
                        Log.e(TAG, "SUCCESS onSessionProposal")
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        Log.e(TAG, "ERROR onSessionProposal")
                        Log.e(TAG, errorMessage.toString());
                    }

                    override fun notImplemented() {
                        Log.e(TAG, "NOT IMPLEMENTED onSessionProposal")
                    }
                })
            }
        }

        override fun onSessionRequest(sessionRequest: Sign.Model.SessionRequest) {
            Log.e(TAG, "onSessionRequest : ${Gson().toJson(sessionRequest)}")
            runOnUiThread {
                channel.invokeMethod("onSessionRequest", Gson().toJson(sessionRequest), object : Result {
                    override fun success(result: Any?) {
                        Log.e(TAG, "SUCCESS onSessionSettleResponse")
                    }
                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        Log.e(TAG, "ERROR onSessionSettleResponse")
                    }
                    override fun notImplemented() {
                        Log.e(TAG, "NOT IMPLEMENTED onSessionSettleResponse")
                    }
                })
            }
        }

        override fun onSessionSettleResponse(settleSessionResponse: Sign.Model.SettledSessionResponse) {
            Log.e(TAG, "onSessionSettleResponse : ${Gson().toJson(settleSessionResponse)}")
            runOnUiThread {
                channel.invokeMethod("onSessionSettleResponse", Gson().toJson(settleSessionResponse), object : Result {

                    override fun success(result: Any?) {
                        Log.e(TAG, "SUCCESS onSessionSettleResponse")
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        Log.e(TAG, "ERROR onSessionSettleResponse")
                    }

                    override fun notImplemented() {
                        Log.e(TAG, "NOT IMPLEMENTED onSessionSettleResponse")
                    }
                })
            }
        }

        override fun onSessionUpdateResponse(sessionUpdateResponse: Sign.Model.SessionUpdateResponse) {
            Log.e(TAG, "onSessionUpdateResponse : ${Gson().toJson(sessionUpdateResponse)}")
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler {
                call, result ->
            try {
                when (call.method) {
                    "init" -> {
                        onInit(call, result)
                    }
                    "pair" -> {
                        onPair(call, result)
                    }
                    "sessionApproval" -> {
                        sessionApproval(call, result)
                    }
                    "sessionDisconnect" -> {
                        sessionDisconnect(call, result)
                    }
                    "sessionRejection" -> {
                        sessionRejection(call, result)
                    }
                    "sessionList" -> {
                        sessionList(call, result)
                    }
                    "connectWebsocket" -> {
                        connectWebsocket(call, result)
                    }
                    "sessionRequestApprove" -> {
                        sessionRequestApprove(call, result)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            } catch (e: Exception) {
                runOnUiThread {
                    result.error(e.toString(), null, null)
                }
            }
        }
    }

    private fun onPair(call: MethodCall, result: Result) {
        val uri = call.arguments as String
        SignClient.pair(
            Sign.Params.Pair(uri)
        ) { error ->
            Log.e(TAG, error.throwable.stackTraceToString())
            runOnUiThread {
                result.error("03929", error.throwable.message, null);
            }
        }
    }

    private fun sessionApproval(call: MethodCall, result: Result) {

        val arguments = call.arguments as HashMap<String, Objects>

        val proposerPublicKey: String = arguments.getValue("proposerPublicKey") as String
        val sessionNamespaces: Map<String, Sign.Model.Namespace.Session> = (arguments.getValue("sessionNamespaces") as Map<String, Objects>)
            .mapValues {
                val namespace = it.value as Map<String, Objects>
                Sign.Model.Namespace.Session(
                    accounts = namespace.getValue("accounts") as List<String>,
                    methods = namespace.getValue("methods") as List<String>,
                    events = namespace.getValue("events") as List<String>,
                    null
                )
            }

        val approveParams: Sign.Params.Approve = Sign.Params.Approve(proposerPublicKey, sessionNamespaces)

        SignClient.approveSession(approveParams) { error ->
            Log.e(TAG, error.throwable.stackTraceToString())
            runOnUiThread {
                result.error("4039", error.throwable.message, null);
            }
        }
    }

    private fun sessionDisconnect(call: MethodCall, result: Result) {
        val arguments = call.arguments as HashMap<String, Objects>

        val disconnectionReason: String = arguments.getValue("reason") as String
        val disconnectionCode: Int = arguments.getValue("code") as Int
        val sessionTopic: String = arguments.getValue("topic") as String
        val disconnectParams = Sign.Params.Disconnect(sessionTopic, disconnectionReason, disconnectionCode)

        SignClient.disconnect(disconnectParams) { error ->
            runOnUiThread {
                result.error("4039", error.throwable.message, null);
            }
        }
    }

    private fun sessionRejection(call: MethodCall, result: Result) {
        val arguments = call.arguments as HashMap<String, Objects>

        val proposerPublicKey: String = arguments.getValue("publicKey") as String
        val rejectionReason: String = arguments.getValue("rejectionReason") as String
        val rejectionCode: Int = arguments.getValue("rejectionCode") as Int

        val rejectParams: Sign.Params.Reject = Sign.Params.Reject(proposerPublicKey, rejectionReason, rejectionCode)
        SignClient.rejectSession(rejectParams) { error ->
            runOnUiThread {
                result.error("4039", error.throwable.message, null);
            }
        }
    }

    private fun sessionList(call: MethodCall, result: Result) {
        val lists: List<Sign.Model.Session> = SignClient.getListOfSettledSessions()
        result.success(Gson().toJson(lists));
    }

    private fun sessionDelete(call: MethodCall, result: Result) {
    }

    private fun connectWebsocket(call: MethodCall, result: Result) {
        SignClient.WebSocket.open { error ->
            Log.e(TAG, error)
            result.error("4039", error, null);
        }
        Log.e(TAG, "connectWebsocket")
        result.success(true);
    }

    private fun sessionRequestApprove(call: MethodCall, result: Result) {
        Log.e(TAG, "sessionRequestApprove")
        val arguments = call.arguments as HashMap<String, Object>
        val result2 = Sign.Params.Response(
            sessionTopic = arguments.getValue("sessionTopic") as String,
            jsonRpcResponse = Sign.Model.JsonRpcResponse.JsonRpcResult(
                arguments.getValue("requestId") as Long,
                arguments.getValue("signed") as String,
            )
        )

        SignClient.respond(result2) { error ->
            Log.e(TAG, error.throwable.stackTraceToString())
            result.error("4039", error.throwable.message, null);
        }
    }
    private fun onInit(call: MethodCall, result: Result) {

        val arguments = call.arguments as HashMap<String, Object>
        val metadata = arguments.getValue("metadata") as HashMap<String, Object>;

        val appMetaData = Sign.Model.AppMetaData(
            url = metadata.getValue("url") as String,
            description = metadata.getValue("description") as String,
            name = metadata.getValue("name") as String,
            icons = metadata.getValue("icons") as List<String>
        )

        val init = Sign.Params.Init(
            application,
            useTls = true,
            hostName = arguments.getValue("relayHost") as String,
            projectId = arguments.getValue("projectId") as String,
            metadata = appMetaData,
            connectionType = Sign.ConnectionType.MANUAL
        )

        SignClient.initialize(init) { error ->
            Log.e(TAG, error.throwable.stackTraceToString())
            result.error("4039", error.throwable.message, null);
        }

        SignClient.WebSocket.close { error ->
            result.error("4039", error, null);
        }

        SignClient.WebSocket.open { error ->
            result.error("4039", error, null);
        }

        SignClient.setWalletDelegate(wcHandler)

        Log.e(TAG, "onInit: done $init")
    }
}
