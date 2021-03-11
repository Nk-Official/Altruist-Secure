package com.insurance.atpl.altruist_secure_flutter;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PathDashPathEffect;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.os.CountDownTimer;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.insurance.atpl.altruist_secure_flutter.MainActivity.MainActivity;

public class DrawingView extends View {
    private static final float TOUCH_TOLERANCE = 4;
    private Bitmap bitmap;
    private Canvas canvas;
    private Path path;
    private Paint bitmapPaint;
    private Paint paint;
    private boolean drawMode;
    private float x, y;
    private float xx, yy;
    private float penSize = 20;
    private float eraserSize = 80;
    private Bitmap bitmapSateSave;
    private Bitmap bitmapData;
    private Context context;
    AlertDialog alertDialog;
    MotionEvent event;

    public DrawingView(Context c) {
        this(c, null);
    }

    public DrawingView(Context c, AttributeSet attrs) {
        this(c, attrs, 0);
    }

    public DrawingView(Context c, AttributeSet attrs, int defStyle) {
        super(c, attrs, defStyle);
        context = c;
        init();
    }

    private void init() {
        path = new Path();
        bitmapPaint = new Paint(Paint.DITHER_FLAG);
        paint = new Paint();
        this.setDrawingCacheEnabled(true);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        System.out.println("onSizeChanged");
        if (bitmap == null) {
            bitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
            bitmapSateSave = bitmap;
        }
        canvas = new Canvas(bitmap);
        canvas.drawColor(Color.TRANSPARENT);
        Init();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        System.out.println("onDraw");
        canvas.drawBitmap(bitmap, 0, 0, bitmapPaint);
        canvas.drawPath(path, paint);
        bitmapData = this.getDrawingCache(true);

    }

    private void touchStart(float x, float y) {

        path.reset();
        path.moveTo(x, y);
        this.x = x;
        this.y = y;
        this.xx = x;
        this.yy = y;
        mTimer("Start");
        canvas.drawPath(path, paint);

    }


    boolean CheckPixelColor() {
        if (bitmapData.sameAs(bitmapSateSave)) {
            System.out.println("Same");
            mTimer("Same");
        } else {
            System.out.println("Different");
            mTimer("touchUp");
        }
        return false;

    }


    void Init() {
        initializePen();
        DisplayMetrics displayMetrics = new DisplayMetrics();
        ((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        int Padding = 70;
        int height = displayMetrics.heightPixels - Padding;
        int width = displayMetrics.widthPixels - Padding;
        System.out.println("height: " + height);
        System.out.println("width: " + width);
        path.reset();
        path.moveTo(Padding, Padding);
        path.lineTo(Padding, height);
        path.lineTo(width, height);
        path.lineTo(width, Padding);
        path.lineTo(Padding, Padding);
        path.lineTo(width, height);
        path.moveTo(width, Padding);
        path.lineTo(Padding, height);
        canvas.drawPath(path, paint);

        if (drawMode) {
            initializeEraser();
        }

        alertDialog = new AlertDialog.Builder(context).create();
        alertDialog.setCancelable(false);
        // invalidate();
        mpopup();


        // mTimer("touchUp");
    }



    @Override
    public boolean onTouchEvent(MotionEvent event) {
        this.event = event;
        if (event != null) {
            // changeConnectedPixel((int) x, (int) y);
            float x = event.getX();
            float y = event.getY();
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    System.out.println("touch ACTION_DOWN");
                    touchStart(x, y);
                    invalidate();
                    break;
                case MotionEvent.ACTION_MOVE:
                    System.out.println("touch move");
                    changeConnectedPixel((int) x, (int) y);
                    invalidate();
                    break;
                case MotionEvent.ACTION_UP:
                    System.out.println("touch ACTION_UP");
                    CheckPixelColor();
                    break;
                default:
                    break;
            }
        }

        return true;
    }



    public void initializePen() {
        drawMode = true;
       // initializeEraser();
        paint.setAntiAlias(true);
        paint.setDither(true);
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeJoin(Paint.Join.ROUND);
        paint.setStrokeCap(Paint.Cap.ROUND);
        paint.setStrokeWidth(penSize);

        Path pathShape = new Path();
        pathShape.addCircle(0, 0, 30, Path.Direction.CCW);

        float advance = 120.0f;
        float phase = 0.0f;
        PathDashPathEffect.Style style = PathDashPathEffect.Style.ROTATE;
        PathDashPathEffect pathDashPathEffect = new PathDashPathEffect(pathShape, advance, phase, style);
        paint.setPathEffect(pathDashPathEffect);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SCREEN));

    }


    public void initializeEraser() {
        drawMode = false;
        paint.reset();
        paint.setColor(Color.parseColor("#00FFFFFF"));
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(eraserSize);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
        invalidate();
    }

    @Override
    public void setBackgroundColor(int color) {
        if (canvas == null) {
            canvas = new Canvas();
        }
        canvas.drawColor(color);
        super.setBackgroundColor(color);
    }

    int i = 0;

    void changeConnectedPixel(final int x, final int y) {
        changeConnectedPixelClass mchangeConnectedPixelClass = new changeConnectedPixelClass(x, y);
        synchronized (mchangeConnectedPixelClass) {
            mchangeConnectedPixelClass.convert();
            i++;
        }
    }

    class changeConnectedPixelClass {
        int x, y;

        changeConnectedPixelClass(int x, int y) {
            this.x = x;
            this.y = y;
        }

        void convert() {
            if (y >= 0 && y < bitmap.getHeight()) {
                if (x >= 0 && x < bitmap.getHeight()) {
                    int pixel = bitmap.getPixel(x, y);
                    if (pixel != Color.TRANSPARENT) {
                        //  System.out.println("Black");
                        bitmap.setPixel(x, y, Color.TRANSPARENT);
                        invalidate();
                        changeConnectedPixel(x - 1, y - 1);
                        changeConnectedPixel(x, y - 1);
                        changeConnectedPixel(x + 1, y - 1);
                        changeConnectedPixel(x - 1, y);
                        changeConnectedPixel(x + 1, y);
                        changeConnectedPixel(x - 1, y + 1);
                        changeConnectedPixel(x, y + 1);
                        changeConnectedPixel(x + 1, y + 1);
                    }
                }
            }

        }

    }

    public void mpopup() {


        alertDialog.setTitle(R.string.screen_test);
        alertDialog.setMessage("Draw on the screen to remove all the dots on the screen.");

        alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mTimer("touchUp");
            }
        });
        alertDialog.show();
    }

    CountDownTimer cdt = null;

    public void mTimer(String type) {
        Log.e("type", "  === " + type);
        if (type.trim().equalsIgnoreCase("touchUP")) {
            Log.e("Method", " Called === ");
            touchStart(x, y);
            invalidate();
        //    paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
            cdt = new CountDownTimer(10000, 1000) {
                public void onTick(long millisUntilFinished) {
                    Integer maxTime = (int) (millisUntilFinished / 1000);
                    //  timer.setText(String.valueOf(maxTime));
                    Log.e("onTick", "  === " + "millisUntilFinished");
                    Log.e("maxTime", "  === " + maxTime);
                    ((DisplayTestScreenActivity) context).mShowTime(maxTime.toString());
                }

                public void onFinish() {
                    Activity activity = (Activity) context;
                    MainActivity.channel.invokeMethod("display_test", "" + false);
                    activity.finish();

                }
            }.start(); //start the countdowntimer
        } else if (type.trim().equalsIgnoreCase("Same")) {
            Activity activity = (Activity) context;
            MainActivity.channel.invokeMethod("display_test", "" + true);
            activity.finish();
        } else {
            if (cdt != null)
                cdt.cancel();
            ((DisplayTestScreenActivity) context).mHideTime();
        }
    }

    private void touchMove(float x, float y) {
        float dx = Math.abs(x - this.x);
        float dy = Math.abs(y - this.y);
        if (dx >= TOUCH_TOLERANCE || dy >= TOUCH_TOLERANCE) {
            path.quadTo(this.x, this.y, (x + this.x) / 2, (y + this.y) / 2);
            this.x = x;
            this.y = y;
        }
        canvas.drawPath(path, paint);

    }

    private void touchUp() {
      //  path.lineTo(x, y);
      //  canvas.drawPath(path, paint);
      //  path.reset();
//    if (drawMode) {
//      paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SCREEN));
//    } else {
//      paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
//    }
//        mTimer("touchUp");
//        CheckPixelColor();
    }






}
