package com.insurance.atpl.altruist_secure_flutter.MainActivity

import android.annotation.TargetApi
import android.bluetooth.BluetoothAdapter
import android.content.*
import android.net.wifi.WifiManager
import android.os.*
import android.telephony.TelephonyManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.net.ConnectivityManager
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.provider.Settings
import android.speech.tts.TextToSpeech
import android.widget.Toast
import com.insurance.atpl.altruist_secure_flutter.ChatHaed.FloatingButton
import com.insurance.atpl.altruist_secure_flutter.ChatHaed.SimpleService
import com.insurance.atpl.altruist_secure_flutter.DisplayTestScreenActivity
import com.insurance.atpl.altruist_secure_flutter.Service.FloatingBubblePermissions
import java.util.*


class MainActivity : FlutterActivity(), SensorEventListener, TextToSpeech.OnInitListener {
    lateinit var wifiManager: WifiManager
    var lightsensmgr: SensorManager? = null
    var accsensor: Sensor? = null
    var lightSensorValue: Boolean = false
    var ProximityValue: Boolean = false
    var sensorManager: SensorManager? = null
    lateinit var sensorvalues: FloatArray
    var mGravitysensorFlag: Boolean = false
    var mGravityFlagResult: Boolean = false
    lateinit var sensorvalues_megnatic: FloatArray
    var mMagneticFlag: Boolean = false
    var mMagneticResultFlag: Boolean = false
    var mResult: Boolean = false
    lateinit var mTts: TextToSpeech
    lateinit var myReceiver: MusicIntentReceiver
    lateinit var mResult_: MethodChannel.Result

    private val HELLOS = arrayOf(
            "Click 1",
            "Click 2",
            "Click 3",
            "Click 4",
            "Click 5",
            "Click 6",
            "Click 7",
            "Click 8"
    )

    var valRandomNumer: Int? = null

    companion object {
        private val CHANNEL = "samples.flutter.dev/battery/vibration_test"
        lateinit var channel: MethodChannel
        var mStatus = false
    }
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        myReceiver = MusicIntentReceiver()
//        super.onCreate(savedInstanceState)
//
//    }


    override fun onResume() {
        Log.e("Main Activity ", " onResume==== " + " Called ")
        lightsensmgr!!.registerListener(this, accsensor, SensorManager.SENSOR_DELAY_NORMAL)
        sensorManager!!.registerListener(this, sensorManager!!.getDefaultSensor(Sensor.TYPE_PROXIMITY),
                SensorManager.SENSOR_DELAY_NORMAL);
        val filter = IntentFilter(Intent.ACTION_HEADSET_PLUG)
        //  this.registerReceiver(myReceiver, filter)
        super.onResume()
    }

    override fun onPause() {
        Log.e("Main Activity ", " onPause=== " + " Called ")
        lightsensmgr!!.unregisterListener(this)
        sensorManager!!.unregisterListener(this);
        var myService: Intent = Intent(this, SimpleService::class.java);
        stopService(myService);
        //   this.unregisterReceiver(myReceiver)
        super.onPause()
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        lightsensmgr = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accsensor = sensorManager!!.getDefaultSensor(Sensor.TYPE_GRAVITY)
        myReceiver = MusicIntentReceiver()
        mTts = TextToSpeech(this, this)

        var proximitySensor: Sensor = sensorManager!!.getDefaultSensor(Sensor.TYPE_PROXIMITY)

        if (proximitySensor == null) {
            ProximityValue = false
            Log.e("ProximityValue", " IF === " + ProximityValue)
        } else {
            ProximityValue = true
            Log.e("ProximityValue", " Else === " + ProximityValue)
        }

        if (lightsensmgr!!.getDefaultSensor(Sensor.TYPE_LIGHT) != null) {
            Log.e("Sensor.TYPE_LIGHT", " IF === " + Sensor.TYPE_LIGHT);
            mLightResultSuccess()
        } else {
            Log.e("Sensor.TYPE_LIGHT", " ELSE=== " + Sensor.TYPE_LIGHT);
            // Failure! No magnetometer.
            mLightResultFail();
        }

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            mResult_ = result
            Log.e("call.method ", "  ==== " + call.method)
            if (call.method == "vibration_test") {
                val vibrationStatus = mVibrationMethod()
                if (vibrationStatus != null && vibrationStatus == true) {
                    result.success(vibrationStatus)
                } else {
                    result.error("UNAVAILABLE", "vibration_test", null)
                }
            } else if (call.method == "display_test") {
                startActivity(Intent(this@MainActivity, DisplayTestScreenActivity::class.java))
            } else if (call.method == "overlay_setting") {
//                var REQUEST_CODE = 101;
//                var myIntent: Intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
//                myIntent.setData(Uri.parse("package:" + getPackageName()));
//                startActivityForResult(myIntent, REQUEST_CODE);
                FloatingBubblePermissions.startPermissionRequest(this)
            } else if (call.method == "chathead_test") {

                var user_number = call.argument<String>("user_number")
                var user_id = call.argument<String>("user_id")
                var user_name = call.argument<String>("user_name")
                var user_token = call.argument<String>("user_token")
                var qr_token = call.argument<String>("qr_token")
                Log.e("user_number in Android ", " ==== " + user_number)
                Log.e("user_id in Android ", " ==== " + user_id)
                Log.e("user_name in Android ", " ==== " + user_name)
                Log.e("user_token in Android ", " ==== " + user_token)
                Log.e("qr_token in Android ", " ==== " + qr_token)


                var intent_: Intent = Intent(this@MainActivity, FloatingButton::class.java)
                intent_.putExtra("action", "0")
                intent_.putExtra("user_number", user_number)
                intent_.putExtra("user_id", user_id)
                intent_.putExtra("user_name", user_name)
                intent_.putExtra("user_token", user_token)
                intent_.putExtra("qr_token", qr_token)
                startActivity(intent_)
                // finish()
                //tartActivity(Intent(this@MainActivity, FloatingButton::class.java))
            } else if (call.method == "sim_test") {
                val simStatus = mSimRequired()
                if (simStatus != null) {
                    result.success(simStatus)
                } else {
                    result.success(simStatus)
                    result.error("UNAVAILABLE", "sim_test", null)
                }
            } else if (call.method == "headphone_test") {
                Log.e("headphone_test", "  === " + "Called")
                myReceiver = MusicIntentReceiver()
                val filter = IntentFilter(Intent.ACTION_HEADSET_PLUG)
                this.registerReceiver(myReceiver, filter)
                var intent: Intent = Intent("com.atpl.secure.MainActivity.MainActivity$myReceiver")
                this.sendBroadcast(intent);
            } else if (call.method == "wifi_test") {
                var wifiStatus = getWifi()
                Log.e("wifiStatus", "===== " + wifiStatus)
                Handler().postDelayed({
                    if (wifiStatus != null && wifiStatus == true) {
                        result.success(true)
                    } else {
                        result.success(true)
                        result.error("UNAVAILABLE", "wifiStatus", null)
                    }    //doSomethingHere()

                }, 1000)

            } else if (call.method == "lightsensor_test") {
                if (lightSensorValue != null && lightSensorValue == true) {
                    Log.e("lightsensor_test", " === " + lightSensorValue);
                    result.success(lightSensorValue)
                } else {
                    result.success(false)
                    Log.e("lightsensor_test", " === " + false);
                }
            } else if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else if (call.method == "proximity_test") {
                Log.e("ProximityValue", " ==== " + ProximityValue)
                if (ProximityValue != null && ProximityValue == true) {
                    result.success(ProximityValue)
                } else {
                    result.success(ProximityValue)
                }
            } else if (call.method == "bluetooth_test") {
                var bluetoothStatus = statusblue()
                if (bluetoothStatus != null && bluetoothStatus == true) {
                    result.success(bluetoothStatus)
                } else {
                    result.success(bluetoothStatus)
                    result.error("UNAVAILABLE", "blutooth_test", null)
                }
            } else if (call.method == "gravity_test") {
                if (mGravityFlagResult != null && mGravityFlagResult == true) {
                    result.success(mGravityFlagResult)
                } else {
                    result.success(mGravityFlagResult)
                    result.error("UNAVAILABLE", "gravity_test", null)
                }
            } else if (call.method == "magnetic_test") {
                if (mMagneticResultFlag != null && mMagneticResultFlag == true) {
                    result.success(mMagneticResultFlag)
                } else {
                    result.success(mMagneticResultFlag)
//                    result.error("UNAVAILABLE", "magnetic_test", null)
                }
            } else if (call.method == "speaker_test") {
                //     startActivity(Intent(this@MainActivity, SpeakerFragment::class.java))
                valRandomNumer = call.argument<Int>("text")
                var speakVal_ = sayHello()
                Log.e("valRandomNumer", " ==== " + valRandomNumer)
                Log.e("speakVal_", " ==== " + speakVal_)

                if (speakVal_ != null && speakVal_ == true) {
                    result.success(speakVal_)
                } else {
                    result.success(speakVal_)
//                    result.error("UNAVAILABLE", "magnetic_test", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }


    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        Log.e("batteryLevel", " === " + batteryLevel)
        return batteryLevel
    }


    protected fun mVibrationMethod(): Boolean {
        val v = (this.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator?)!!
        Log.e("Can Vibrate", "YES")
        v!!.vibrate(400)
        mStatus = true
        return mStatus
    }


    protected fun mSimRequired(): Int {
        val telMgr = context!!.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager?
        val simState = telMgr!!.simState
        Log.e("simState", "  === " + simState)
        return simState
    }

    fun getWifi(): Boolean {
        var wifiStatus = false
        wifiManager = context!!.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val wifi = activity!!.getApplicationContext().getSystemService(Context.WIFI_SERVICE) as WifiManager
        if (wifi.isWifiEnabled) {
            Log.e("wifi.isWifiEnabled ", " ==== " + wifi.isWifiEnabled)
        }
        wifiManager.setWifiEnabled(true)
        wifiStatus = true
        if (wifiManager.isWifiEnabled()) {
            wifiStatus = true
        } else {
            wifiManager.setWifiEnabled(true)
            Handler().postDelayed({
                //doSomethingHere()
                if (wifiManager.isWifiEnabled()) {
                    wifiStatus = true
                } else {
                    wifiStatus = true
                }
            }, 1000)

        }

        return wifiStatus
    }

    var bluetoothTest = false

    @TargetApi(Build.VERSION_CODES.ECLAIR)
    fun statusblue(): Boolean {
        var adapter = BluetoothAdapter.getDefaultAdapter()
        if (adapter.isEnabled()) {
            bluetoothTest = true
        } else {
//            adapter.enable()
            if (adapter.enable()) {
                bluetoothTest = true
            } else {
                bluetoothTest = false
            }
        }
        return bluetoothTest
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {

    }

    override fun onSensorChanged(event: SensorEvent?) {
        /////////////////// Gravity Sensor////////////
        sensorvalues = event!!.values
        val x = sensorvalues[0]
        if (x != null && mGravitysensorFlag == false) {
            mEventsGravitySuccess()

        } else {
            // AppPrefrences(mContext!!).setGravitySensor(false)
        }
        mGravitysensorFlag = true
        sensorvalues_megnatic = event.values
        val x_megnatic = sensorvalues_megnatic[0]
        if (x_megnatic != null && mMagneticFlag == false) {
            Log.e("x_megnatic", " " + x_megnatic)
            mSucessMegnatic()
        }
        mMagneticFlag = true
        if (mResult == false) {
            mSucessMegnatic()

        }
        mResult = true

    }

    private fun mSucessMegnatic() {
        mMagneticResultFlag = true
        Log.e("lightSensorValue", " === Success" + lightSensorValue)
    }

    private fun mLightResultSuccess() {
        lightSensorValue = true
        Log.e("lightSensorValue", " === Success" + lightSensorValue)
    }

    private fun mLightResultFail() {
        lightSensorValue = false
        Log.e("mProximityResult", " === Fail" + lightSensorValue)
    }

    fun mEventsGravitySuccess() {
        mGravityFlagResult = true
    }


    // Implements TextToSpeech.OnInitListener.
    override fun onInit(status: Int) {
        // status can be either TextToSpeech.SUCCESS or TextToSpeech.ERROR.
        if (status == TextToSpeech.SUCCESS) {
            val result = mTts!!.setLanguage(Locale.US)
            if (status == TextToSpeech.ERROR) {
                Toast.makeText(this, "Something Wrong Occues", Toast.LENGTH_SHORT).show()
            } else {
                if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                    Log.e("MainActivity", "Language is not available.")
                } else {
                }
            }
        } else {
            // Initialization failed.
            Log.e("MainActivity", "Could not initialize TextToSpeech.")

        }
    }


    private fun sayHello(): Boolean {
        mTts!!.speak("Click " + valRandomNumer, TextToSpeech.QUEUE_FLUSH, null)
        return true
    }


    inner public class MusicIntentReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            Log.e("HeadPhone Receiver ", "" + "Called")
            if (intent.action == Intent.ACTION_HEADSET_PLUG) {
                val state = intent.getIntExtra("state", -1)
                Log.e("state", "" + state)
//                when (state) {
//                    0 -> testresult.setText("Headset is unplugged")
//                    1 -> testresult.setText("Headset is plugged")
//                    else -> testresult.setText("Plugin the headset")

                if (state == 0) {
                    //MainActivity.channel.invokeMethod("headphone_test", false)
                } else if (state == 1) {
                    MainActivity.channel.invokeMethod("headphone_test", true)
                }
//                else {
//                    MainActivity.channel.invokeMethod("headphone_test", false)
//                    //texthead.setText("Plugin the headset")
//                }

            }
        }
    }

//    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
////        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
//        Log.e("requestCode","====="  + requestCode )
//
//    }
}