package com.insurance.atpl.altruist_secure_flutter;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.SeekBar;
import android.widget.TextView;

import com.insurance.atpl.altruist_secure_flutter.R;


public class Display extends Activity implements
        View.OnClickListener, SeekBar.OnSeekBarChangeListener {
    public TextView tv_time;
    AlertDialog alertDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION, WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
        setContentView(R.layout.activity_display_test_screen);
        tv_time = (TextView) findViewById(R.id.tv_time);
        alertDialog = new AlertDialog.Builder(Display.this).create();
        mpopup();
    }


    public void mpopup() {
        alertDialog.setTitle(R.string.screen_test);
        alertDialog.setMessage("Draw on the screen to remove all the dots on the screen.");
        alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {

            }
        });
        alertDialog.show();
    }


    public void hideDialog() {
        if (alertDialog.isShowing()) {
            alertDialog.dismiss();
        } else {
        }
    }

    public void mShowTime(String time) {
        tv_time.setVisibility(View.VISIBLE);
        tv_time.setText(time);
    }

    public void mHideTime() {
        tv_time.setVisibility(View.GONE);
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
        }
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int i, boolean b) {

    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {
    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {
    }
}
