package com.insurance.atpl.altruist_secure_flutter.ChatHaed;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;

import com.insurance.atpl.altruist_secure_flutter.MainActivity.MainActivity;
import com.insurance.atpl.altruist_secure_flutter.R;
import com.insurance.atpl.altruist_secure_flutter.Service.FloatingBubblePermissions;

import java.io.File;
import java.io.FileInputStream;

import androidx.appcompat.app.AppCompatActivity;

public class FloatingButton extends Activity {
    WifiLevelReceiver receiver;
    ImageView imageView;
    private Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.floating_button);
        //  context = this;
//        receiver = new WifiLevelReceiver();
//        registerReceiver(receiver, new IntentFilter("click_event"));
        FloatingBubblePermissions.startPermissionRequest(this);
        View startBubble = findViewById(R.id.start_bubble);
        imageView = findViewById(R.id.image);
        imageView.setVisibility(View.GONE);
        startBubble.setVisibility(View.GONE);

        if (getIntent() != null) {
            String status_ = getIntent().getStringExtra("action");
            String user_number = getIntent().getStringExtra("user_number");
            String user_id = getIntent().getStringExtra("user_id");
            String user_name = getIntent().getStringExtra("user_name");
            String user_token = getIntent().getStringExtra("user_token");
            String qr_token = getIntent().getStringExtra("qr_token");
            Log.e("status_", "" + status_);
            Log.e("user_number", " ===== " + user_number);
            Log.e("user_id", " ===== " + user_id);
            Log.e("user_name", " ===== " + user_name);
            Log.e("user_token", " ===== " + user_token);
            Log.e("qr_token", " ===== " + qr_token);
            if (status_.trim().equals("0")) {
                //// Intent for start for the start service
                Intent intent = new Intent(getApplicationContext(), SimpleService.class);
                intent.putExtra("user_number", user_number);
                intent.putExtra("user_id", user_id);
                intent.putExtra("user_name", user_name);
                intent.putExtra("user_token", user_token);
                intent.putExtra("qr_token", qr_token);
                startService(intent);


                //// Intent for dialer pad
                Intent intent1 = new Intent(Intent.ACTION_DIAL);
                startActivity(intent1);
                finish();
            } else if (status_.trim().equals("1")) {
                MainActivity.channel.invokeMethod("chathead_test", "" + true);
                finish();
            } else if (status_.trim().equals("2")) {
                MainActivity.channel.invokeMethod("chathead_test", "" + false);
                finish();
            }else if (status_.trim().equals("3")) {
                MainActivity.channel.invokeMethod("chathead_test", "" + "not_found");
                finish();
            }else if (status_.trim().equals("in_process")) {
                MainActivity.channel.invokeMethod("chathead_test", "" + "in_process");
                finish();
            }
        }

    }

    @Override
    public void onStop() {
        Log.e("FloatingButton onStop", " ======== " + "Called");
        super.onStop();
        //  unregisterReceiver(receiver);           //<-- Unregister to avoid memoryleak
    }

    @Override
    public void onPause() {
        Log.e("FloatingButton onStop", " ======== " + "onPause");
        super.onPause();
    }

    class WifiLevelReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals("click_event")) {
                String level = intent.getStringExtra("click_event_");
                Log.e("Broad Cast Click Value", " ======== " + level);
                // Show it in GraphView
                //  takeScreenshot(level);

            }
        }

    }

    private void takeScreenshot(String level) {
        Log.e("Image Inside Activity ", " ======== " + level);
        getBitmap(level);


        //
//        Date now = new Date();
//        android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss", now);
//
//        try {
//            // image naming and path  to include sd card  appending name you choose for file
//            String mPath = Environment.getExternalStorageDirectory().toString() + "/" + now + ".jpg";
//
//            // create bitmap screen capture
//            View v1 = getWindow().getDecorView().getRootView();
//            v1.setDrawingCacheEnabled(true);
//            Bitmap bitmap = Bitmap.createBitmap(v1.getDrawingCache());
//            v1.setDrawingCacheEnabled(false);
//
//            File imageFile = new File(mPath);
//            Log.e("imageFile ", " ======== " + imageFile);
//            FileOutputStream outputStream = new FileOutputStream(imageFile);
//            int quality = 100;
//            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream);
//            outputStream.flush();
//            outputStream.close();
//            unregisterReceiver(receiver);
//            //   openScreenshot(imageFile);
//        } catch (Throwable e) {
//            // Several error may come out with file handling or DOM
//            e.printStackTrace();
//        }
    }

    public Bitmap getBitmap(String path) {
        Bitmap bitmap = null;
        try {
            File f = new File(path);
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inPreferredConfig = Bitmap.Config.ARGB_8888;
            bitmap = BitmapFactory.decodeStream(new FileInputStream(f), null, options);
            imageView.setImageBitmap(bitmap);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bitmap;
    }


}
