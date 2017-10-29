package com.jianshi.tools;

import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;


public class GetAjaxRequest extends CordovaPlugin{
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("setCookie".equals(action)){
          String[] cookies = args.getString(0).split(";");
          CookieManager cookieManager = CookieManager.getInstance();
          cookieManager.setAcceptCookie(true);
          for(int i = 0; i < cookies.length; i++) {
            cookieManager.setCookie(args.getString(1), cookies[i]);
          }
          if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            cookieManager.flush();
          } else {
            CookieSyncManager.createInstance(this.cordova.getActivity());
            CookieSyncManager.getInstance().sync();
          }
          callbackContext.success();
        }
        return  false;
    }
}
