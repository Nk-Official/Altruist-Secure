package com.insurance.atpl.altruist_secure_flutter.ChatHaed;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;

import com.insurance.atpl.altruist_secure_flutter.R;
import com.insurance.atpl.altruist_secure_flutter.Service.FloatingBubbleConfig;
import com.insurance.atpl.altruist_secure_flutter.Service.FloatingBubbleService;

import androidx.core.content.ContextCompat;

import android.content.Context;
import android.graphics.Color;
import android.view.Gravity;


public class SimpleService extends FloatingBubbleService {
    String user_infoInS,user_number,user_id,user_name,user_token,qr_token;
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {


        user_number = intent.getStringExtra("user_number");
        user_id = intent.getStringExtra("user_id");
        user_name = intent.getStringExtra("user_name");
        user_token = intent.getStringExtra("user_token");
        qr_token = intent.getStringExtra("qr_token");

        Log.e("user_number", " In Native ==== user_number" + user_number);
        Log.e("user_id", "  In Native ==== user_id" + user_id);
        Log.e("user_name", "  In Native ==== user_name" + user_name);
        Log.e("user_token", "  In Native ==== user_token" + user_token);
        Log.e("qr_token", "  In Native ==== qr_token" + qr_token);

        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        Log.e("SimpleService", " onDestroy " + "Called");
        super.onDestroy();
    }


    @Override
    public boolean onUnbind(Intent intent) {
        Log.e("SimpleService", " onUnbind " + "Called");
        return super.onUnbind(intent);


    }

    @Override
    protected FloatingBubbleConfig getConfig() {
        final Context context = getApplicationContext();
        return new FloatingBubbleConfig.Builder()
                .removeBubbleIcon(ContextCompat.getDrawable(context, R.drawable.close_default_icon))
                .bubbleIconDp(100)
                .expandableView(getInflater().inflate(R.layout.sample_view_1, null))
                .paddingDp(2)
                .borderRadiusDp(0)
                .physicsEnabled(true)
                .expandableColor(Color.WHITE)
                .triangleColor(0xFF215A64)
                .gravity(Gravity.LEFT)
                .bubbleUsername(user_name)
                .bubbleUserID(user_id)
                .bubbleUserToken(user_token)
                .bubbleUserNumber(user_number)
                .qrCodeToken(qr_token)
                .build();

    }

//                    .removeBubbleIconDp(400)
//        .bubbleIcon(ContextCompat.getDrawable(context, R.drawable.bubble_image))

}
