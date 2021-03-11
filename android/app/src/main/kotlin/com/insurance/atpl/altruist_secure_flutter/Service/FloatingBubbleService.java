package com.insurance.atpl.altruist_secure_flutter.Service;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.PixelFormat;
import android.graphics.Point;
import android.os.Build;
import android.os.CountDownTimer;
import android.os.Environment;
import android.os.Handler;
import android.os.IBinder;
import android.text.format.DateFormat;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;


import com.insurance.atpl.altruist_secure_flutter.ChatHaed.FloatingButton;
import com.insurance.atpl.altruist_secure_flutter.R;
import com.insurance.atpl.altruist_secure_flutter.RetroFitApi.APIService;
import com.insurance.atpl.altruist_secure_flutter.RetroFitApi.ApiUtils;
import com.insurance.atpl.altruist_secure_flutter.RetroFitApi.DamageScreenStatus;

import java.util.Date;
import java.util.concurrent.TimeUnit;

import androidx.annotation.NonNull;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;


public class FloatingBubbleService extends Service {

    protected static final String TAG = FloatingBubbleService.class.getSimpleName();

    // Constructor Variable
    protected FloatingBubbleLogger logger;

    // The Window Manager View
    protected WindowManager windowManager;

    // The layout inflater
    protected LayoutInflater inflater;

    // Window Dimensions
    protected Point windowSize = new Point();

    // The Views
    protected View bubbleView;
    protected View removeBubbleView;
    protected View expandableView;

    protected WindowManager.LayoutParams bubbleParams;
    protected WindowManager.LayoutParams removeBubbleParams;
    protected WindowManager.LayoutParams expandableParams;

    private FloatingBubbleConfig config;
    private FloatingBubblePhysics physics;
    private FloatingBubbleTouch touch;
    long secondsinmillis;
    CountDownTimer countDownTimer;
    private APIService mAPIService;
    String DamageScreenUrl;
    Handler mHandler = new Handler();

    @Override
    public void onCreate() {
        super.onCreate();
        logger = new FloatingBubbleLogger().setDebugEnabled(true).setTag(TAG);
        mAPIService = ApiUtils.getAPIService();

    }

    @Override
    public void onStart(Intent intent, int startId) {
        super.onStart(intent, startId);
        Log.e(FloatingBubbleService.class.getName(), " onStart() ======== " + " Called ");
        int counter = 30;
        secondsinmillis = TimeUnit.SECONDS.toMillis(counter);
        Log.e(FloatingBubbleService.class.getName(), "secondsinmillis in first time == " + secondsinmillis);
        countDownTimer = new CountDownTimer(secondsinmillis, 1000) {
            public void onFinish() {
                Log.e(FloatingBubbleService.class.getName(), "onFinish() ===" + "Called");
            }

            public void onTick(long millisUntilFinished) {
                secondsinmillis = TimeUnit.MILLISECONDS.toSeconds(millisUntilFinished);
                Log.e(FloatingBubbleService.class.getName(), "millisUntilFinished in onTick == " + millisUntilFinished);
                Log.e(FloatingBubbleService.class.getName(), "seconds == " + secondsinmillis);
                if (secondsinmillis == 20 || secondsinmillis == 10 || secondsinmillis == 0) {
                    Log.e(FloatingBubbleService.class.getName(), " Inside Condition Seconds ======== " + secondsinmillis);
                    if (secondsinmillis == 0) {
                        countDownTimer.cancel();
                    }

                    String ScreenUrl = "https://api1.altruistsecure.com/api/statusinfo/v1/damagedscreenstatus/";
                    DamageScreenUrl = ScreenUrl +
                            config.getUserID() +
                            "/source/" +
                            "1/" + "qrcodetoken/" + config.getQrCodeToken() +
                            "?jwtToken=" +
                            config.getToken();
                    Log.e(FloatingBubbleService.class.getName(), "DamageScreenUrl====" + DamageScreenUrl);
                    sendPost(DamageScreenUrl);
                }
            }
        }.start();


    }

    public void sendPost(String url) {
        mAPIService.damageScreenApi(url).enqueue(new Callback<DamageScreenStatus>() {
            @Override
            public void onResponse(Call<DamageScreenStatus> call, Response<DamageScreenStatus> response) {
                Log.e("Response in the api", "" + response.body().toString());
                Log.e("Response  getErrorCode", "" + response.body().getStatusDescription().getErrorCode());
                Log.e("Response  getStatus", "" + response.body().getDeviceDetailsUploads().getStatus());

                if (response.body().getStatusDescription().getErrorCode() == 200) {
                    Log.e("Response  200", "getStatus() == " + response.body().getDeviceDetailsUploads().getStatus());
                    if (response.body().getDeviceDetailsUploads().getStatus() != null && response.body().getDeviceDetailsUploads().getStatus().equals("1")) {
                        Log.e(FloatingBubbleService.class.getName(), " Status inside 1" + response.body().toString());
                        countDownTimer.cancel();
                        bubbleView.setVisibility(View.GONE);
                        removeBubbleView.setVisibility(View.GONE);
                        Intent dialogIntent = new Intent(FloatingBubbleService.this, FloatingButton.class);
                        dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        dialogIntent.putExtra("action", "1");
                        startActivity(dialogIntent);
                    } else if (response.body().getDeviceDetailsUploads().getStatus().equals("2")) {
                        Log.e(FloatingBubbleService.class.getName(), " Status inside 2" + response.body().toString());
                        countDownTimer.cancel();
                        bubbleView.setVisibility(View.GONE);
                        removeBubbleView.setVisibility(View.GONE);
                        Intent dialogIntent = new Intent(FloatingBubbleService.this, FloatingButton.class);
                        dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        dialogIntent.putExtra("action", "2");
                        startActivity(dialogIntent);

                    } else if (response.body().getDeviceDetailsUploads().getStatus().equals("0")) {
                        Log.e(FloatingBubbleService.class.getName(), " Status inside 0" + response.body().toString());
                        if (secondsinmillis == 0) {
                            Log.e(FloatingBubbleService.class.getName(), " Status inside 0 counterForApiCalled" + response.body().toString());
                            countDownTimer.cancel();
                            bubbleView.setVisibility(View.GONE);
                            removeBubbleView.setVisibility(View.GONE);
                            Intent dialogIntent = new Intent(FloatingBubbleService.this, FloatingButton.class);
                            dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                            dialogIntent.putExtra("action", "in_process");
                            startActivity(dialogIntent);
                        }
                        //countDownTimer.start();
                    }
                } else {
                    Log.e(FloatingBubbleService.class.getName(), " Status 201 inside" + response.body().toString());
                    if (secondsinmillis == 0) {
                        Log.e(FloatingBubbleService.class.getName(), " Status inside 201 counterForApiCalled" + response.body().toString());
                        countDownTimer.onFinish();
                        bubbleView.setVisibility(View.GONE);
                        removeBubbleView.setVisibility(View.GONE);
                        Intent dialogIntent = new Intent(FloatingBubbleService.this, FloatingButton.class);
                        dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        dialogIntent.putExtra("action", "3");
                        startActivity(dialogIntent);
                    }

                }

            }

            @Override
            public void onFailure(Call<DamageScreenStatus> call, Throwable t) {
                Log.e(TAG, "Unable to submit post to API.");
            }
        });
    }

    public void mTimer() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                // TODO Auto-generated method stub
                while (true) {
                    try {
                        Thread.sleep(10000);
                        mHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                // Write your code here to update the UI.
                                Log.e(FloatingBubbleService.class.getName(), " =====   " + "MEthod Called");
                                String ScreenUrl =
                                        "https://api1.altruistsecure.com/api/statusinfo/v1/damagedscreenstatus/";

                                DamageScreenUrl = ScreenUrl +
                                        config.getUserID() +
                                        "/source/" +
                                        "1" +
                                        "?jwtToken=" +
                                        config.getToken();
                                Log.e(FloatingBubbleService.class.getName(), "DamageScreenUrl====" + DamageScreenUrl);
                                sendPost(DamageScreenUrl);
                            }
                        });
                    } catch (Exception e) {
                        // TODO: handle exception
                    }
                }
            }
        }).start();

    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent == null || !onGetIntent(intent)) {
            return Service.START_NOT_STICKY;
        }
        logger.log("Start with START_STICKY");

        // Remove existing views
        removeAllViews();

        // Load the Window Managers
        setupWindowManager();
        setupViews();
        setTouchListener();

        Log.e(FloatingBubbleService.class.getName(), "onStartCommand == " + "Called");

        return super.onStartCommand(intent, flags, Service.START_STICKY);

    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {

        Log.e("onTaskRemoved()", "" + "Method Called");
        super.onTaskRemoved(rootIntent);
    }


    //    @Override
//    public void onTaskRemoved(Intent rootIntent) {
//        super.onTaskRemoved(rootIntent);
//        countDownTimer.cancel();
//    }


//    @Override
//    public boolean onUnbind(Intent intent) {
//
//        Log.e("onUnbind()", ""  +"Method Called");
//        return super.onUnbind(intent);
//
//    }

//    @Override
//    public void onDestroy() {
//        super.onDestroy();
//        Log.e("onDestroy()", ""  +"Method Called");
//        logger.log("onDestroy");
//        countDownTimer.cancel();
//        removeAllViews();
//    }


    private void removeAllViews() {
        if (windowManager == null) {
            return;
        }

        if (bubbleView != null) {
            windowManager.removeView(bubbleView);
            bubbleView = null;
        }

        if (removeBubbleView != null) {
            windowManager.removeView(removeBubbleView);
            removeBubbleView = null;
        }

        if (expandableView != null) {
            windowManager.removeView(expandableView);
            expandableView = null;
        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);

    }

    private void setupWindowManager() {
        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        setLayoutInflater();
        windowManager.getDefaultDisplay().getSize(windowSize);
    }

    protected LayoutInflater setLayoutInflater() {
        inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
        return inflater;
    }

    /**
     * Creates the views
     */
    protected void setupViews() {
        config = getConfig();

        Log.e(FloatingBubbleService.class.getName(), " Method === " + "Called");
        Log.e(FloatingBubbleService.class.getName(), " config === " + config.toString());

        int padding = dpToPixels(config.getPaddingDp());
        int iconSize = dpToPixels(config.getBubbleIconDp());
        int bottomMargin = getExpandableViewBottomMargin();
        // config.getUserName();
        // Setting up view

        bubbleView = inflater.inflate(R.layout.user_layout, null);
        //  ImageView imageView = (ImageView) bubbleView.findViewById(R.id.IV_layout);
        TextView userName = (TextView) bubbleView.findViewById(R.id.tv_userName);
        TextView userNumber = (TextView) bubbleView.findViewById(R.id.tv_userNumber);
        userName.setText(config.getUserID());
        Log.e("config.getUserName()", " ===" + config.getUserID());

        // imageView.setBackground(getDrawable(R.drawable.ic_download));
        removeBubbleView = inflater.inflate(R.layout.floating_remove_bubble_view, null);
        expandableView = inflater.inflate(R.layout.floating_expandable_view, null);

        // Setting up the Remove Bubble View setup
        removeBubbleParams = getDefaultWindowParams();
        removeBubbleParams.gravity = Gravity.TOP | Gravity.START;
        removeBubbleParams.width = dpToPixels(config.getRemoveBubbleIconDp());
        removeBubbleParams.height = dpToPixels(config.getRemoveBubbleIconDp());
        removeBubbleParams.x = (windowSize.x - removeBubbleParams.width) / 2;
        removeBubbleParams.y = windowSize.y - removeBubbleParams.height - bottomMargin;
        removeBubbleView.setVisibility(View.GONE);
        removeBubbleView.setAlpha(config.getRemoveBubbleAlpha());
        windowManager.addView(removeBubbleView, removeBubbleParams);

        // Setting up the Expandable View setup
        expandableParams = getDefaultWindowParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT);
        expandableParams.height = windowSize.y - iconSize - bottomMargin;
        expandableParams.gravity = Gravity.TOP | Gravity.START;
        expandableView.setVisibility(View.GONE);
        ((LinearLayout) expandableView).setGravity(config.getGravity());
        expandableView.setPadding(padding, padding, padding, padding);
        windowManager.addView(expandableView, expandableParams);

        // Setting up the Floating Bubble View
        bubbleParams = getDefaultWindowParams(WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT);
        bubbleParams.gravity = Gravity.TOP | Gravity.START;
        // bubbleParams.width = iconSize;
        bubbleParams.height = iconSize;
        windowManager.addView(bubbleView, bubbleParams);

        // Setting the configuration
        if (config.getRemoveBubbleIcon() != null) {
            ((ImageView) removeBubbleView).setImageDrawable(config.getRemoveBubbleIcon());
        }
        if (config.getBubbleIcon() != null) {
            ((ImageView) bubbleView).setImageDrawable(config.getBubbleIcon());
        }

        //    CardView card = (CardView) expandableView.findViewById(R.id.expandableViewCard);
        // card.setRadius(dpToPixels(config.getBorderRadiusDp()));
//
//        ImageView triangle = (ImageView) expandableView.findViewById(R.id.expandableViewTriangle);
//        LinearLayout container = (LinearLayout) expandableView.findViewById(R.id.expandableViewContainer);
//        if (config.getExpandableView() != null) {
//            triangle.setColorFilter(config.getTriangleColor());
//            ViewGroup.MarginLayoutParams params =
//                    (ViewGroup.MarginLayoutParams) triangle.getLayoutParams();
//            params.leftMargin = dpToPixels((config.getBubbleIconDp() - 16) / 2);
//            params.rightMargin = dpToPixels((config.getBubbleIconDp() - 16) / 2);
//
//            triangle.setVisibility(View.VISIBLE);
//            container.setVisibility(View.VISIBLE);
//          //  card.setVisibility(View.VISIBLE);
//
//            container.setBackgroundColor(config.getExpandableColor());
//            container.removeAllViews();
//            container.addView(config.getExpandableView());
//        } else {
//            triangle.setVisibility(View.GONE);
//            container.setVisibility(View.GONE);
//           // card.setVisibility(View.GONE);
//        }
    }

    /**
     * Get the Bubble config
     *
     * @return the config
     */
    protected FloatingBubbleConfig getConfig() {
        return FloatingBubbleConfig.getDefault(getContext());
    }

    /**
     * Sets the touch listener
     */
    protected void setTouchListener() {
        physics = new FloatingBubblePhysics.Builder()
                .sizeX(windowSize.x)
                .sizeY(windowSize.y)
                .bubbleView(bubbleView)
                .config(config)
                .windowManager(windowManager)
                .build();

        touch = new FloatingBubbleTouch.Builder()
                .sizeX(windowSize.x)
                .sizeY(windowSize.y)
                .listener(getTouchListener())
                .physics(physics)
                .bubbleView(bubbleView)
                .removeBubbleSize(dpToPixels(config.getRemoveBubbleIconDp()))
                .windowManager(windowManager)
                .expandableView(expandableView)
                .removeBubbleView(removeBubbleView)
                .config(config)
                .marginBottom(getExpandableViewBottomMargin())
                .padding(dpToPixels(config.getPaddingDp()))
                .build();

        bubbleView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                System.out.println("Click");
                bubbleView.setVisibility(View.GONE);
                removeBubbleView.setVisibility(View.GONE);

                //   Bitmap bitmap_hiddenview = ScreenShott.getInstance().takeScreenShotOfJustView(v);
                // logger.log("Bitmap Image "+bitmap_hiddenview.toString());
                //takeScreenshot();

            }
        });
        // bubbleView.setOnTouchListener(touch);

    }

    private void takeScreenshot() {
        Date now = new Date();
        DateFormat.format("yyyy-MM-dd_hh:mm:ss", now);

        try {
            // image naming and path  to include sd card  appending name you choose for file
            String mPath = Environment.getExternalStorageDirectory().toString() + "/" + now + ".jpg";

            // create bitmap screen capture
//            View v1 = windowManagergetWindow().getDecorView().getRootView() ;
//            v1.setDrawingCacheEnabled(true);
//            Bitmap bitmap = Bitmap.createBitmap(v1.getDrawingCache());
//            v1.setDrawingCacheEnabled(false);
//            File imageFile = new File(mPath);
//
//            FileOutputStream outputStream = new FileOutputStream(imageFile);
//            int quality = 100;
//            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream);
//            outputStream.flush();
//            outputStream.close();

//            Intent sendLevel = new Intent();
//            sendLevel.setAction("click_event");
//            sendLevel.putExtra("click_event_", "");
//            sendBroadcast(sendLevel);
//            startActivity(sendLevel);

            // myIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

//            Intent dialogIntent = new Intent(getApplicationContext(), FloatingButton.class);
//            dialogIntent.putExtra("action","1");
//            dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            startActivity(dialogIntent);
//
//            Intent dialogIntent = new Intent(this, FloatingButton.class);
//            dialogIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            dialogIntent.putExtra("action", "1");
//            startActivity(dialogIntent);

        } catch (Throwable e) {
            // Several error may come out with file handling or DOM
            e.printStackTrace();
        }
    }

//    private void takeScreenshot() {
//        Date now = new Date();
//        android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss", now);
//        String mPath = Environment.getExternalStorageDirectory().toString() + "/" + now + ".jpg";
//      // create bitmap screen capture
//        Bitmap bitmap;
//        View v1 = mCurrentUrlMask.getRootView();
//        v1.setDrawingCacheEnabled(true);
//        bitmap = Bitmap.createBitmap(v1.getDrawingCache());
//        v1.setDrawingCacheEnabled(false);
//
//        OutputStream fout = null;
//       File imageFile = new File(mPath);
//
//        try {
//            fout = new FileOutputStream(imageFile);
//            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, fout);
//            fout.flush();
//            fout.close();
//
//
//        } catch (FileNotFoundException e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        } catch (IOException e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
//
////        try {
////            // image naming and path  to include sd card  appending name you choose for file
////            String mPath = Environment.getExternalStorageDirectory().toString() + "/" + now + ".jpg";
////            // create bitmap screen capture
////
////            File file = new File(mPath);
////            Log.e("imageFile ", " ======== " + mPath);
////            Intent sendLevel = new Intent();
////            sendLevel.setAction("click_event");
////            sendLevel.putExtra("click_event_", file);
////            sendBroadcast(sendLevel);
////
////            //   openScreenshot(imageFile);
////        } catch (Throwable e) {
////            // Several error may come out with file handling or DOM
////            e.printStackTrace();
////        }
//    }

    /**
     * Gets the touch listener for the bubble
     *
     * @return the touch listener
     */
    public FloatingBubbleTouchListener getTouchListener() {
        return new DefaultFloatingBubbleTouchListener() {
            @Override
            public void onRemove() {
                stopSelf();
            }
        };
    }


    /**
     * Get the default window layout params
     *
     * @return the layout param
     */
    protected WindowManager.LayoutParams getDefaultWindowParams() {
        return getDefaultWindowParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT);
    }

    /**
     * Get the default window layout params
     *
     * @return the layout param
     */
    protected WindowManager.LayoutParams getDefaultWindowParams(int width, int height) {
        return new WindowManager.LayoutParams(
                width,
                height,
                Build.VERSION.SDK_INT >= 26
                        ? WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                        : WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                        | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
                        | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                PixelFormat.TRANSLUCENT);
    }

    /**
     * Handles the intent for the service (only if it is not null)
     *
     * @param intent the intent
     */
    protected boolean onGetIntent(@NonNull Intent intent) {
        return true;
    }

    /**
     * Get the layout inflater for view inflation
     *
     * @return the layout inflater
     */
    protected LayoutInflater getInflater() {
        return inflater == null ? setLayoutInflater() : inflater;
    }

    /**
     * Get the context for the service
     *
     * @return the context
     */
    protected Context getContext() {
        return getApplicationContext();
    }

    /**
     * Sets the state of the expanded view
     *
     * @param expanded the expanded view state
     */
    protected void setState(boolean expanded) {
        touch.setState(expanded);
    }

    /**
     * Get the expandable view's bottom margin
     *
     * @return margin
     */
    private int getExpandableViewBottomMargin() {
        Resources resources = getContext().getResources();
        int resourceId = resources.getIdentifier("navigation_bar_height", "dimen", "android");
        int navBarHeight = 0;
        if (resourceId > 0) {
            navBarHeight = resources.getDimensionPixelSize(resourceId);
        }

        return navBarHeight;
    }

    /**
     * Converts DPs to Pixel values
     *
     * @return the pixel value
     */
    private int dpToPixels(int dpSize) {
        DisplayMetrics displayMetrics = getResources().getDisplayMetrics();
        return Math.round(dpSize * (displayMetrics.densityDpi / DisplayMetrics.DENSITY_DEFAULT));
    }


}
