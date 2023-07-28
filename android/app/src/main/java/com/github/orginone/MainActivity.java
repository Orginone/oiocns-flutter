package com.github.orginone;

import android.os.Bundle;

import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    WalletDelegate walletDelegate;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        walletDelegate = new WalletDelegate(getFlutterEngine().getDartExecutor());
    }

    @Override
    protected void onDestroy() {
        walletDelegate.onDestroy();
        walletDelegate = null;
        super.onDestroy();
    }
}
