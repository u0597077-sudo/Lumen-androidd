#!/usr/bin/env bash
set -e
mkdir -p "."
cat > "settings.gradle" << 'LUMEN_EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = 'LumenAgent'
include ':app'
LUMEN_EOF
mkdir -p "."
cat > "build.gradle" << 'LUMEN_EOF'
plugins {
    id 'com.android.application' version '8.5.2' apply false
}
LUMEN_EOF
mkdir -p "."
cat > "gradle.properties" << 'LUMEN_EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.nonTransitiveRClass=true
LUMEN_EOF
mkdir -p "."
cat > ".gitignore" << 'LUMEN_EOF'
.gradle/
build/
local.properties
.idea/
*.iml
LUMEN_EOF
mkdir -p "app"
cat > "app/build.gradle" << 'LUMEN_EOF'
plugins {
    id 'com.android.application'
}

android {
    namespace 'uz.lumen.agent'
    compileSdk 34

    defaultConfig {
        applicationId 'uz.lumen.agent'
        minSdk 24
        targetSdk 34
        versionCode 1
        versionName '1.0'
    }

    buildTypes {
        release {
            minifyEnabled false
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
LUMEN_EOF
mkdir -p "app/src/main"
cat > "app/src/main/AndroidManifest.xml" << 'LUMEN_EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:theme="@android:style/Theme.Material.NoActionBar">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
LUMEN_EOF
mkdir -p "app/src/main/java/uz/lumen/agent"
cat > "app/src/main/java/uz/lumen/agent/MainActivity.java" << 'LUMEN_EOF'
package uz.lumen.agent;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {

    private WebView web;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setStatusBarColor(Color.parseColor("#050A22"));
        getWindow().setNavigationBarColor(Color.parseColor("#050A22"));

        web = new WebView(this);
        web.setBackgroundColor(Color.parseColor("#050A22"));
        setContentView(web);

        WebSettings s = web.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        s.setMediaPlaybackRequiresUserGesture(false);

        web.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                Uri u = request.getUrl();
                if ("file".equals(u.getScheme())) {
                    return false;
                }
                startActivity(new Intent(Intent.ACTION_VIEW, u));
                return true;
            }
        });

        web.loadUrl("file:///android_asset/index.html");
    }

    @Override
    public void onBackPressed() {
        web.evaluateJavascript("window.lumenBack ? window.lumenBack() : false", value -> {
            if (!"true".equals(value)) {
                MainActivity.super.onBackPressed();
            }
        });
    }
}
LUMEN_EOF
mkdir -p "app/src/main/res/values"
cat > "app/src/main/res/values/strings.xml" << 'LUMEN_EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Agent Lumen</string>
</resources>
LUMEN_EOF
mkdir -p "app/src/main/res/drawable"
cat > "app/src/main/res/drawable/ic_launcher.xml" << 'LUMEN_EOF'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#0B1550"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#2DE2FF"
        android:pathData="M30,18m-4,0a4,4 0,1 1,8 0a4,4 0,1 1,-8 0" />
    <path
        android:fillColor="#2DE2FF"
        android:pathData="M78,18m-4,0a4,4 0,1 1,8 0a4,4 0,1 1,-8 0" />
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M30,34H78A16,16 0 0 1 94,50V68A16,16 0 0 1 78,84H30A16,16 0 0 1 14,68V50A16,16 0 0 1 30,34Z" />
    <path
        android:fillColor="#0A1230"
        android:pathData="M32,46H76A10,10 0 0 1 86,56V64A10,10 0 0 1 76,74H32A10,10 0 0 1 22,64V56A10,10 0 0 1 32,46Z" />
    <path
        android:fillColor="#14142E"
        android:pathData="M34,36L38,24Q54,20 70,24L74,36Z" />
    <path
        android:fillColor="#2DE2FF"
        android:pathData="M38,52H44A3,3 0 0 1 47,55V61A3,3 0 0 1 44,64H38A3,3 0 0 1 35,61V55A3,3 0 0 1 38,52Z" />
    <path
        android:fillColor="#2DE2FF"
        android:pathData="M64,52H70A3,3 0 0 1 73,55V61A3,3 0 0 1 70,64H64A3,3 0 0 1 61,61V55A3,3 0 0 1 64,52Z" />
</vector>
LUMEN_EOF
mkdir -p "app/src/main/assets"
cat > "app/src/main/assets/config.js" << 'LUMEN_EOF'
window.LUMEN_CONFIG = {
  apiKey: '__GEMINI_API_KEY__',
  model: 'gemini-flash-latest'
};
LUMEN_EOF
mkdir -p "app/src/main/assets"
cat > "app/src/main/assets/index.html" << 'LUMEN_EOF'
<!doctype html>
<html lang="uz">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover,user-scalable=no">
<title>Agent Lumen</title>
<style>
:root{--bg:#050a22;--bg2:#0b1550;--cy:#2de2ff;--vi:#8c6bff;--bl:#4d8dff;--mu:#9fb0ff}
*{box-sizing:border-box;-webkit-tap-highlight-color:transparent}
html,body{margin:0;height:100%;background:var(--bg);color:#fff;font-family:Inter,'Helvetica Neue',Helvetica,Arial,sans-serif;overflow:hidden}
#app{height:100vh;height:100dvh;display:flex;flex-direction:column;background:radial-gradient(ellipse at 50% 0%,#17308f 0%,var(--bg2) 38%,var(--bg) 80%)}
.scr{flex:1;display:flex;flex-direction:column;padding:calc(env(safe-area-inset-top) + 28px) 24px calc(env(safe-area-inset-bottom) + 24px);overflow-y:auto;animation:fin .35s ease both}
@keyframes fin{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:none}}
h1{font-size:32px;line-height:1.1;margin:18px 0 8px;letter-spacing:-1px}
p.sub{color:var(--mu);font-size:17px;line-height:1.4;margin:0 0 20px}
label.l{display:block;color:var(--mu);font-size:14px;font-weight:700;letter-spacing:2px;margin:18px 0 8px}
input,textarea,select{width:100%;background:rgba(255,255,255,.08);border:2px solid rgba(255,255,255,.15);border-radius:18px;color:#fff;font-size:18px;padding:15px 18px;outline:none;font-family:inherit}
input:focus,textarea:focus{border-color:var(--cy)}
input.bad{border-color:#ff5a5f;animation:shk .3s}
@keyframes shk{25%{transform:translateX(-8px)}75%{transform:translateX(8px)}}
.chips{display:flex;flex-wrap:wrap;gap:10px;margin:14px 0}
.chip{padding:11px 17px;border-radius:999px;border:2px solid rgba(255,255,255,.18);background:rgba(255,255,255,.06);color:#fff;font-size:16px;font-weight:600;font-family:inherit}
.chip.on{background:var(--cy);color:#07102e;border-color:var(--cy)}
.btn{margin-top:auto;padding:17px;border:0;border-radius:20px;font-size:19px;font-weight:800;color:#07102e;background:linear-gradient(135deg,var(--cy),#7fb0ff);font-family:inherit;width:100%}
.btn.ghost{background:transparent;color:var(--mu);border:2px solid rgba(255,255,255,.18);margin-top:12px}
.btn.red{background:rgba(255,90,95,.18);color:#ff8a8e;border:2px solid #ff5a5f;margin-top:12px}
.sp{flex:1;min-height:16px}
.dots{display:flex;gap:8px;margin-bottom:6px}.dot{height:6px;flex:1;border-radius:3px;background:rgba(255,255,255,.15)}.dot.on{background:var(--cy)}
.robot{animation:bob 3s ease-in-out infinite}@keyframes bob{50%{transform:translateY(-8px)}}
.eye{animation:blink 5s infinite;transform-origin:center;transform-box:fill-box}
@keyframes blink{0%,94%,100%{transform:scaleY(1)}97%{transform:scaleY(.1)}}
.hdr{display:flex;align-items:center;gap:12px;padding:calc(env(safe-area-inset-top) + 10px) 16px 10px;background:rgba(5,10,34,.75);border-bottom:1px solid rgba(255,255,255,.08)}
.hdr .t{flex:1}.hdr .t b{font-size:19px}.hdr .t span{display:block;font-size:13px;color:var(--mu)}
.hdr .t span:before{content:'';display:inline-block;width:8px;height:8px;border-radius:50%;background:#7dffb3;margin-right:6px}
.gear{width:44px;height:44px;border-radius:50%;border:0;background:rgba(255,255,255,.08);color:#fff;font-size:22px}
#msgs{flex:1;overflow-y:auto;padding:12px 16px}
.m{max-width:86%;padding:12px 16px;border-radius:22px;margin:8px 0;line-height:1.42;font-size:17px;word-wrap:break-word;animation:fin .25s ease both}
.m p{margin:0 0 6px}.m p:last-child{margin:0}.m ul,.m ol{margin:4px 0 6px;padding-left:22px}.m code{background:rgba(0,0,0,.3);padding:1px 6px;border-radius:6px}
.m.u{margin-left:auto;background:rgba(255,255,255,.15);border-bottom-right-radius:6px}
.m.a{background:linear-gradient(135deg,#6b57e8,#4d8dff);border-bottom-left-radius:6px}
.m.err{background:rgba(255,90,95,.2);border:1px solid #ff5a5f}
.typing span{display:inline-block;width:8px;height:8px;border-radius:50%;background:#fff;margin:0 2px;animation:tp 1s infinite}
.typing span:nth-child(2){animation-delay:.15s}.typing span:nth-child(3){animation-delay:.3s}
@keyframes tp{0%,60%,100%{transform:translateY(0);opacity:.5}30%{transform:translateY(-6px);opacity:1}}
#quick{display:flex;gap:8px;overflow-x:auto;padding:6px 16px 8px;scrollbar-width:none}
#quick .chip{white-space:nowrap;font-size:15px;padding:9px 14px}
.bar{display:flex;gap:10px;align-items:flex-end;padding:8px 12px calc(env(safe-area-inset-bottom) + 12px);background:rgba(5,10,34,.85)}
.bar textarea{flex:1;max-height:120px;border-radius:24px;padding:13px 18px;resize:none;font-size:17px}
.send{width:52px;height:52px;border-radius:50%;border:0;background:linear-gradient(135deg,var(--cy),#7fb0ff);color:#07102e;font-size:24px;font-weight:900}
.send:disabled{opacity:.4}
.banner{margin:8px 16px;padding:12px 16px;border-radius:16px;background:rgba(255,207,90,.15);border:1px solid #ffcf5a;font-size:15px}
a{color:var(--cy)}
.hdr .t span.nd:before{content:none}
.body{flex:1;overflow-y:auto;padding:14px 16px calc(env(safe-area-inset-bottom) + 28px)}
h3{font-size:14px;letter-spacing:2px;color:var(--mu);margin:22px 0 10px;font-weight:800;text-transform:uppercase}
.mu{color:var(--mu);font-size:15px;line-height:1.4}.small{font-size:13px;opacity:.85}
.sgrid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:14px}
.sc{text-align:left;background:linear-gradient(160deg,rgba(255,255,255,.1),rgba(255,255,255,.04));border:1.5px solid rgba(255,255,255,.12);border-top:3px solid var(--ac);border-radius:22px;padding:14px;color:#fff;font-family:inherit;min-height:132px;display:flex;flex-direction:column}
.sc.wide{grid-column:1/3;min-height:96px}
.sc .ic{font-size:26px}.sc .tt{font-size:13px;letter-spacing:1.5px;color:var(--ac);font-weight:800;margin-top:6px;text-transform:uppercase}
.sc .mv{font-size:19px;font-weight:900;margin-top:6px;line-height:1.15;word-wrap:break-word}.sc .sb{font-size:13px;color:var(--mu);margin-top:auto;padding-top:6px;line-height:1.25}
.today{display:flex;align-items:center;gap:16px;padding:16px;border-radius:24px;background:rgba(255,255,255,.07);border:1.5px solid rgba(255,255,255,.12)}
.today b{font-size:20px}.today p{margin:4px 0 10px;color:var(--mu);font-size:15px}
.kp3{display:grid;grid-template-columns:repeat(3,1fr);gap:10px}.kp{background:rgba(255,255,255,.08);border-radius:18px;padding:12px 8px;text-align:center}
.kp span{display:block;font-size:11px;letter-spacing:1px;color:var(--mu);font-weight:800}.kp b{display:block;font-size:18px;margin-top:6px;word-break:break-word}
.pos{color:#7dffb3}.neg{color:#ff8a8e}
.brow{margin:10px 0}.bl{display:flex;justify-content:space-between;font-size:15px;margin-bottom:5px}.bt{height:10px;background:rgba(255,255,255,.1);border-radius:5px;overflow:hidden}.bf{height:100%;border-radius:5px}
.li{display:flex;align-items:center;gap:12px;padding:12px 14px;margin:8px 0;border-radius:18px;background:rgba(255,255,255,.07)}.li.late{border:1.5px solid #ffcf5a}
.lm{flex:1;min-width:0}.lm b{display:block;font-size:17px}.lm span{font-size:13px;color:var(--mu)}.la{font-weight:900;font-size:17px;white-space:nowrap}
.x{width:34px;height:34px;border-radius:50%;border:0;background:rgba(255,255,255,.1);color:#fff;font-size:20px;flex:none;font-family:inherit}
.ck{width:34px;height:34px;border-radius:50%;border:2.5px solid var(--cy);background:transparent;color:#07102e;font-size:20px;font-weight:900;flex:none;font-family:inherit}.ck.on{background:var(--cy)}
.seg{display:flex;gap:10px}
.chart{display:flex;align-items:flex-end;gap:8px;height:170px;padding:8px 6px;background:rgba(255,255,255,.05);border-radius:18px}
.cb{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:flex-end;height:100%}.cf{width:70%;max-width:34px;border-radius:8px 8px 3px 3px;background:linear-gradient(180deg,var(--cy),var(--vi))}
.cv{font-size:11px;color:var(--mu);margin-bottom:3px;min-height:14px}.cd{font-size:12px;color:var(--mu);margin-top:4px}
.btn.sm{margin-top:14px}.chip:disabled{opacity:.45}
.pb{height:12px;background:rgba(255,255,255,.1);border-radius:6px;overflow:hidden;margin:6px 0 4px}.pb div{height:100%;background:linear-gradient(90deg,var(--cy),#7dffb3);border-radius:6px}
.step{display:flex;gap:8px;flex:none}.step button{width:40px;height:36px;border-radius:12px;border:0;background:rgba(255,255,255,.12);color:#fff;font-size:15px;font-weight:800;font-family:inherit}
.rep{background:rgba(255,255,255,.07);border-radius:20px;padding:16px;margin-top:12px}
details.dg{margin-top:14px;background:rgba(255,255,255,.05);border-radius:14px;padding:10px 14px}details.dg summary{color:var(--mu);font-size:15px}details.dg pre{white-space:pre-wrap;font-size:13px;color:var(--mu);font-family:inherit}
.st{padding:6px 12px;border-radius:999px;border:0;font-size:13px;font-weight:800;font-family:inherit;color:#07102e;background:#9fb0ff;flex:none}.st.s1{background:#ffcf5a}.st.s2{background:#7dffb3}
</style>
</head>
<body>
<div id="app"></div>
<script src="config.js"></script>
<script>
var LS = {
  get: function (k, d) { try { var v = localStorage.getItem(k); return v ? JSON.parse(v) : d; } catch (e) { return d; } },
  set: function (k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) {} }
};
var CFG = window.LUMEN_CONFIG || {};
var profile = LS.get('lumen_profile', null);
var hist = LS.get('lumen_hist', []);
var settings = LS.get('lumen_settings', {apiKey: '', model: ''});
var view = 'welcome';
var busy = false;
var STEPS = ['welcome', 'name', 'job', 'needs', 'style', 'key'];
var NEEDS = ['Kun rejasi', 'Sog‘liq', 'Moliya', 'O‘qish', 'Ish unumdorligi', 'Ijod', 'Sayohat', 'Oila'];
var JOBS = ['Talaba', 'Dasturchi', 'Tadbirkor', 'O‘qituvchi', 'Shifokor', 'Dizayner', 'Haydovchi', 'Boshqa'];
var TONES = ['Do‘stona', 'Rasmiy', 'Qisqa va aniq', 'Motivatsion'];
var NEED_PROMPT = {
  'Kun rejasi': 'Bugungi kunim uchun aniq reja tuz.',
  'Sog‘liq': 'Sog‘lig‘im uchun bugun nimalarga e’tibor berishim kerak? Qisqa maslahat ber.',
  'Moliya': 'Xarajatlarimni nazorat qilish uchun oddiy reja taklif qil.',
  'O‘qish': 'Bugun nima o‘rganishim mumkin? Qisqa o‘quv reja ber.',
  'Ish unumdorligi': 'Ish unumdorligimni oshirish uchun 3 ta amaliy maslahat ber.',
  'Ijod': 'Menga ijodiy g‘oya ber va boshlash uchun qadamlarni ayt.',
  'Sayohat': 'Yaqin hafta oxiri uchun sayohat g‘oyasi ber.',
  'Oila': 'Oilam bilan vaqt o‘tkazish uchun bugun nima qilsam bo‘ladi?'
};
var draft = {name: '', job: '', needs: [], extra: '', tone: TONES[0], goal: '', wake: '07:00'};
var app = document.getElementById('app');
function $(id) { return document.getElementById(id); }
function esc(s) { return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }
function getKey() { if (settings.apiKey) { return settings.apiKey; } var k = CFG.apiKey; if (k && k.indexOf('__') !== 0) { return k; } return ''; }
function getModel() { return settings.model || settings.autoModel || CFG.model || 'gemini-flash-latest'; }
function saveHist() { LS.set('lumen_hist', hist.slice(-60)); }

function robot(sz) {
  return '<svg class="robot" width="' + sz + '" height="' + Math.round(sz * 1.1) + '" viewBox="0 0 400 440">' +
    '<defs><linearGradient id="rb" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff"/><stop offset="1" stop-color="#c9d4ff"/></linearGradient></defs>' +
    '<line x1="125" y1="84" x2="95" y2="24" stroke="#b8c4ff" stroke-width="8" stroke-linecap="round"/><circle cx="95" cy="24" r="13" fill="#2de2ff"/>' +
    '<line x1="275" y1="84" x2="305" y2="24" stroke="#b8c4ff" stroke-width="8" stroke-linecap="round"/><circle cx="305" cy="24" r="13" fill="#2de2ff"/>' +
    '<rect x="135" y="312" width="130" height="100" rx="44" fill="url(#rb)"/><circle cx="200" cy="360" r="12" fill="#2de2ff"/>' +
    '<circle cx="52" cy="205" r="30" fill="#e9eeff" stroke="#b3c0ff" stroke-width="5"/><circle cx="348" cy="205" r="30" fill="#e9eeff" stroke="#b3c0ff" stroke-width="5"/>' +
    '<rect x="60" y="70" width="280" height="250" rx="110" fill="url(#rb)"/>' +
    '<rect x="88" y="132" width="224" height="150" rx="62" fill="#0a1230" stroke="#27348a" stroke-width="5"/>' +
    '<path d="M92 118 L118 56 Q200 38 282 56 L308 118 Q200 134 92 118 Z" fill="#14142e"/>' +
    '<path d="M130 87 l9 9 l-9 9 l-9 -9z M165 87 l9 9 l-9 9 l-9 -9z M200 87 l9 9 l-9 9 l-9 -9z M235 87 l9 9 l-9 9 l-9 -9z M270 87 l9 9 l-9 9 l-9 -9z" fill="#fff"/>' +
    '<rect class="eye" x="130" y="172" width="44" height="58" rx="20" fill="#9ff3ff"/><rect class="eye" x="226" y="172" width="44" height="58" rx="20" fill="#9ff3ff"/>' +
    '<path d="M168 252 Q200 270 232 252" fill="none" stroke="#2de2ff" stroke-width="6" stroke-linecap="round"/></svg>';
}

function dots(i) {
  var s = '<div class="dots">';
  for (var k = 1; k < STEPS.length; k++) { s += '<div class="dot' + (k <= i ? ' on' : '') + '"></div>'; }
  return s + '</div>';
}
function show(v) { view = v; render(); }
function nextStep() {
  var i = STEPS.indexOf(view) + 1;
  if (STEPS[i] === 'key' && getKey()) { i++; }
  if (i >= STEPS.length) { finish(); } else { show(STEPS[i]); }
}
function prevStep() { var i = STEPS.indexOf(view) - 1; if (i >= 0) { show(STEPS[i]); } }
function bad(id) { var e = $(id); if (e) { e.classList.remove('bad'); void e.offsetWidth; e.classList.add('bad'); e.focus(); } }
function backRow() { return '<button class="btn ghost" onclick="prevStep()">Orqaga</button>'; }

function render() {
  if (view === 'chat') { buildChat(); return; }
  if (view === 'home') { buildHome(); return; }
  if (view === 'sec') { buildSec(); return; }
  if (view === 'settings') { buildSettings(); return; }
  var i = STEPS.indexOf(view);
  var h = '';
  if (view === 'welcome') {
    h = '<div class="scr" style="align-items:center;text-align:center;justify-content:center">' + robot(210) +
      '<h1>Salom! Men <span style="color:var(--cy)">Lumen</span></h1>' +
      '<p class="sub">Shaxsiy AI yordamchingiz. Sizni yaqinroq tanishim uchun bir necha savol beraman.</p>' +
      '<div class="sp"></div><button class="btn" onclick="nextStep()">Boshlaymiz</button></div>';
  } else if (view === 'name') {
    h = '<div class="scr">' + dots(i) + '<h1>Ismingiz nima?</h1><p class="sub">Sizga ismingiz bilan murojaat qilaman.</p>' +
      '<input id="f_name" value="' + esc(draft.name) + '" placeholder="Masalan: Aziz" autocomplete="off">' +
      '<div class="sp"></div><button class="btn" onclick="saveName()">Davom etish</button>' + backRow() + '</div>';
  } else if (view === 'job') {
    var jc = '';
    JOBS.forEach(function (j, k) { jc += '<button class="chip" onclick="pickJob(' + k + ')">' + j + '</button>'; });
    h = '<div class="scr">' + dots(i) + '<h1>Qanday ish bilan shug‘ullanasiz?</h1><p class="sub">Kasbingiz yoki mashg‘ulotingiz — javoblarni sizga moslash uchun.</p>' +
      '<input id="f_job" value="' + esc(draft.job) + '" placeholder="Masalan: dasturchi, talaba..." autocomplete="off">' +
      '<div class="chips">' + jc + '</div><div class="sp"></div><button class="btn" onclick="saveJob()">Davom etish</button>' + backRow() + '</div>';
  } else if (view === 'needs') {
    var nc = '';
    NEEDS.forEach(function (n, k) { nc += '<button class="chip' + (draft.needs.indexOf(n) >= 0 ? ' on' : '') + '" onclick="toggleNeed(' + k + ')">' + n + '</button>'; });
    h = '<div class="scr">' + dots(i) + '<h1>Sizga nima kerak?</h1><p class="sub">Bir nechtasini tanlashingiz mumkin.</p>' +
      '<div class="chips">' + nc + '</div>' +
      '<label class="l">YANA NIMA KERAK? (IXTIYORIY)</label><textarea id="f_extra" rows="3" placeholder="Masalan: ingliz tilini o‘rganmoqchiman">' + esc(draft.extra) + '</textarea>' +
      '<div class="sp"></div><button class="btn" onclick="saveNeeds()">Davom etish</button>' + backRow() + '</div>';
  } else if (view === 'style') {
    var tc = '';
    TONES.forEach(function (t, k) { tc += '<button class="chip' + (draft.tone === t ? ' on' : '') + '" onclick="pickTone(' + k + ')">' + t + '</button>'; });
    h = '<div class="scr">' + dots(i) + '<h1>Qanday gaplashay?</h1><p class="sub">Uslubingizni tanlang va bir-ikki narsani aytib qo‘ying.</p>' +
      '<div class="chips">' + tc + '</div>' +
      '<label class="l">ASOSIY MAQSADINGIZ (IXTIYORIY)</label><input id="f_goal" value="' + esc(draft.goal) + '" placeholder="Masalan: har kuni kitob o‘qish" autocomplete="off">' +
      '<label class="l">ERTALAB SOAT NECHADA TURASIZ?</label><input id="f_wake" type="time" value="' + esc(draft.wake) + '">' +
      '<div class="sp"></div><button class="btn" onclick="saveStyle()">Davom etish</button>' + backRow() + '</div>';
  } else if (view === 'key') {
    h = '<div class="scr">' + dots(i) + '<h1>Google AI kaliti</h1><p class="sub">Men Google Gemini bilan ishlayman. Bepul kalitni <a href="https://aistudio.google.com/app/apikey">aistudio.google.com/app/apikey</a> sahifasida olishingiz mumkin.</p>' +
      '<input id="f_key" type="password" placeholder="AIza..." autocomplete="off">' +
      '<div class="sp"></div><button class="btn" onclick="saveKey()">Saqlash va boshlash</button>' +
      '<button class="btn ghost" onclick="finish()">Keyinroq</button>' + backRow() + '</div>';
  }
  app.innerHTML = h;
}
function saveName() { var v = $('f_name').value.trim(); if (!v) { bad('f_name'); return; } draft.name = v; nextStep(); }
function pickJob(k) { if (JOBS[k] === 'Boshqa') { $('f_job').value = ''; $('f_job').focus(); return; } $('f_job').value = JOBS[k]; }
function saveJob() { var v = $('f_job').value.trim(); if (!v) { bad('f_job'); return; } draft.job = v; nextStep(); }
function toggleNeed(k) { draft.extra = $('f_extra').value; var n = NEEDS[k]; var i = draft.needs.indexOf(n); if (i >= 0) { draft.needs.splice(i, 1); } else { draft.needs.push(n); } render(); }
function saveNeeds() { draft.extra = $('f_extra').value.trim(); if (!draft.needs.length && !draft.extra) { draft.needs = ['Kun rejasi']; } nextStep(); }
function pickTone(k) { draft.goal = $('f_goal').value; draft.wake = $('f_wake').value || '07:00'; draft.tone = TONES[k]; render(); }
function saveStyle() { draft.goal = $('f_goal').value.trim(); draft.wake = $('f_wake').value || '07:00'; nextStep(); }
function saveKey() { var v = $('f_key').value.trim(); if (!v) { bad('f_key'); return; } settings.apiKey = v; LS.set('lumen_settings', settings); finish(); }

function finish() {
  profile = JSON.parse(JSON.stringify(draft));
  LS.set('lumen_profile', profile);
  var g = 'Salom, ' + profile.name + '! 👋 Men Lumenman.\n\nSiz ' + profile.job.toLowerCase() + ' ekansiz. Men sizga ' + (profile.needs.length ? profile.needs.join(', ').toLowerCase() : 'turli masalalar') + ' bo‘yicha yordam beraman.';
  if (profile.goal) { g += '\n\nMaqsadingiz: ' + profile.goal + ' — buni birga amalga oshiramiz.'; }
  g += '\n\nBugun nimadan boshlaymiz?';
  hist = [{role: 'model', text: g}];
  saveHist();
  go('home');
}

function inline(s) { return esc(s).replace(/\*\*(.+?)\*\*/g, '<b>$1</b>').replace(/`([^`]+)`/g, '<code>$1</code>'); }
function md(t) {
  var lines = String(t).split('\n'); var out = ''; var list = '';
  function close() { if (list) { out += '</' + list + '>'; list = ''; } }
  lines.forEach(function (ln) {
    var m1 = ln.match(/^\s*[-*•]\s+(.*)$/); var m2 = ln.match(/^\s*\d+[.)]\s+(.*)$/); var hm = ln.match(/^#{1,3}\s+(.*)$/);
    if (m1) { if (list !== 'ul') { close(); out += '<ul>'; list = 'ul'; } out += '<li>' + inline(m1[1]) + '</li>'; }
    else if (m2) { if (list !== 'ol') { close(); out += '<ol>'; list = 'ol'; } out += '<li>' + inline(m2[1]) + '</li>'; }
    else { close(); if (hm) { out += '<p><b>' + inline(hm[1]) + '</b></p>'; } else if (ln.trim() !== '') { out += '<p>' + inline(ln) + '</p>'; } }
  });
  close();
  return out;
}

function buildChat() {
  var q = '';
  q += '<button class="chip" onclick="quick(-1)">☀️ Ertalabki briefing</button>';
  (profile.needs || []).slice(0, 4).forEach(function (n, k) { q += '<button class="chip" onclick="quick(' + k + ')">' + n + '</button>'; });
  app.innerHTML = '<div class="hdr"><button class="gear" onclick="go(\'home\')">‹</button>' + robot(44) + '<div class="t"><b>Agent Lumen</b><span>onlayn · Gemini</span></div><button class="gear" onclick="openSettings()">⚙</button></div>' +
    '<div id="banner"></div><div id="msgs"></div><div id="quick">' + q + '</div>' +
    '<div class="bar"><textarea id="inp" rows="1" placeholder="Xabar yozing..."></textarea><button class="send" id="sendBtn" onclick="doSend()">➤</button></div>';
  var inp = $('inp');
  inp.addEventListener('keydown', function (e) { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); doSend(); } });
  inp.addEventListener('input', function () { inp.style.height = 'auto'; inp.style.height = Math.min(120, inp.scrollHeight) + 'px'; });
  updateMsgs();
}
function updateMsgs() {
  var b = $('banner'); if (b) { b.innerHTML = getKey() ? '' : '<div class="banner" onclick="openSettings()">⚠ Google API kaliti kiritilmagan. Bu yerni bosib kiriting.</div>'; }
  var h = '';
  hist.forEach(function (m) { h += '<div class="m ' + (m.role === 'user' ? 'u' : (m.err ? 'a err' : 'a')) + '">' + md(m.text) + '</div>'; });
  if (busy) { h += '<div class="m a typing"><span></span><span></span><span></span></div>'; }
  var box = $('msgs'); if (!box) { return; }
  box.innerHTML = h; box.scrollTop = box.scrollHeight;
  var sb = $('sendBtn'); if (sb) { sb.disabled = busy; }
}
function quick(k) {
  if (k < 0) { send('Menga bugungi kun uchun qisqa ertalabki briefing tayyorla: reja, 2 ta maslahat va bitta motivatsion gap.'); return; }
  send(NEED_PROMPT[profile.needs[k]] || profile.needs[k]);
}
function doSend() { var inp = $('inp'); var t = inp.value; inp.value = ''; inp.style.height = 'auto'; send(t); }

function sysPrompt() {
  var p = profile; var d = new Date();
  var days = ['yakshanba', 'dushanba', 'seshanba', 'chorshanba', 'payshanba', 'juma', 'shanba'];
  function z(n) { return n < 10 ? '0' + n : '' + n; }
  var now = d.getFullYear() + '-' + z(d.getMonth() + 1) + '-' + z(d.getDate()) + ' ' + z(d.getHours()) + ':' + z(d.getMinutes()) + ' (' + days[d.getDay()] + ')';
  return 'Sen "Agent Lumen" — o‘zbek tilida gaplashadigan shaxsiy AI yordamchisan. ' +
    'Foydalanuvchi ismi: ' + p.name + '. Kasbi/mashg‘uloti: ' + p.job + '. ' +
    'U quyidagi mavzularda yordam so‘ragan: ' + (p.needs.length ? p.needs.join(', ') : 'umumiy') + '. ' +
    (p.extra ? 'Qo‘shimcha ehtiyoji: ' + p.extra + '. ' : '') +
    (p.goal ? 'Asosiy maqsadi: ' + p.goal + '. ' : '') +
    'Ertalab soat ' + p.wake + ' da turadi. Gaplashish uslubi: ' + p.tone + '. ' +
    'Hozirgi sana va vaqt: ' + now + '. ' +
    'Qoidalar: foydalanuvchi boshqa tilda yozmasa, o‘zbek tilida (lotin yozuvida) javob ber. Javoblar qisqa, aniq va amaliy bo‘lsin; kerak bo‘lsa qisqa ro‘yxatlardan foydalan. Foydalanuvchiga ismi bilan, iliq murojaat qil. ' +
    'Sog‘liq, moliya va huquq masalalarida umumiy ma’lumot ber, tibbiy yoki moliyaviy maslahat o‘rnini bosmasligini qisqa eslat, jiddiy holatda mutaxassisga murojaat qilishni tavsiya et. Bilmagan narsangni to‘qima.' +
    '\n\nFoydalanuvchining ilovadagi joriy ma‘lumotlari (savol shularga tegishli bo‘lsa, ulardan foydalan):\n' + digest();
}
function chatContents() {
  var contents = hist.filter(function (m) { return !m.err; }).slice(-24).map(function (m) { return {role: m.role, parts: [{text: m.text}]}; });
  while (contents.length && contents[0].role !== 'user') { contents.shift(); }
  return contents;
}
function callGemini(model, sys, contents, maxTok) {
  var url = 'https://generativelanguage.googleapis.com/v1beta/models/' + encodeURIComponent(model) + ':generateContent?key=' + encodeURIComponent(getKey());
  var body = {systemInstruction: {parts: [{text: sys}]}, contents: contents, generationConfig: {temperature: 0.8, maxOutputTokens: maxTok || 1200}};
  return fetch(url, {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(body)}).then(function (r) {
    return r.json().catch(function () { return {}; }).then(function (data) {
      if (!r.ok) { var e = new Error((data.error && data.error.message) || ('HTTP ' + r.status)); e.status = r.status; throw e; }
      var c = data.candidates && data.candidates[0]; var parts = c && c.content && c.content.parts;
      var t = parts ? parts.map(function (p) { return p.text || ''; }).join('') : '';
      if (!t) { throw new Error(data.promptFeedback && data.promptFeedback.blockReason ? 'blocked' : 'empty'); }
      return t;
    });
  });
}
var RETRY_BASE = 1500;
function modelVer(n) { var m = n.match(/gemini-(\d+(?:\.\d+)?)/); return m ? parseFloat(m[1]) : 0; }
function mOk(m) { return (m.supportedGenerationMethods || []).indexOf('generateContent') >= 0; }
function mName(m) { return String(m.name || '').replace('models/', ''); }
function pickModel(list) {
  var strict = list.filter(function (m) { var n = mName(m); return mOk(m) && /flash/.test(n) && !/lite|image|tts|live|audio|thinking|exp|preview|embedding|robotics|computer|learnlm|gemma|vision/.test(n); });
  var pool = strict.length ? strict : list.filter(function (m) { var n = mName(m); return mOk(m) && /flash/.test(n) && !/image|tts|live|audio|embedding|robotics|computer/.test(n); });
  pool.sort(function (a, b) { return modelVer(mName(b)) - modelVer(mName(a)); });
  return pool.length ? mName(pool[0]) : null;
}
function pickAlt(list, skip) {
  var pool = list.filter(function (m) { var n = mName(m); return mOk(m) && /flash/.test(n) && n !== skip && !/image|tts|live|audio|embedding|robotics|computer/.test(n); });
  pool.sort(function (a, b) { return modelVer(mName(b)) - modelVer(mName(a)); });
  return pool.length ? mName(pool[0]) : null;
}
function listModels() {
  return fetch('https://generativelanguage.googleapis.com/v1beta/models?pageSize=200&key=' + encodeURIComponent(getKey())).then(function (r) { return r.json(); }).then(function (d) { return d.models || []; });
}
function waitMs(ms) { return new Promise(function (r) { setTimeout(r, ms); }); }
function withRetry(fn, n) {
  return fn().catch(function (e) {
    if (n > 0 && e && (e.status === 503 || e.status === 500)) { return waitMs(RETRY_BASE * (4 - n)).then(function () { return withRetry(fn, n - 1); }); }
    throw e;
  });
}
function askGemini(sys, contents, maxTok) {
  var first = getModel();
  return withRetry(function () { return callGemini(first, sys, contents, maxTok); }, 3).catch(function (e) {
    if (!e) { throw e; }
    if (e.status === 404) {
      return listModels().then(function (list) {
        var m = pickModel(list);
        if (!m || m === first) { throw e; }
        return withRetry(function () { return callGemini(m, sys, contents, maxTok); }, 3).then(function (t) { settings.autoModel = m; LS.set('lumen_settings', settings); return t; });
      });
    }
    if (e.status === 503 || e.status === 500) {
      return listModels().then(function (list) {
        var m = pickAlt(list, first);
        if (!m) { throw e; }
        return callGemini(m, sys, contents, maxTok);
      }, function () { throw e; });
    }
    throw e;
  });
}
function errMsg(e) {
  var m = String(e && e.message || '');
  if (e && e.name === 'TypeError') { return 'Internet bilan aloqa yo‘q. Ulanishni tekshirib, qayta urinib ko‘ring.'; }
  if (e && e.status === 400 && /API key/i.test(m)) { return 'API kaliti noto‘g‘ri. Sozlamalardan kalitni tekshiring.'; }
  if (e && e.status === 403) { return 'Kalitga ruxsat yo‘q. Kalit to‘g‘riligini va Gemini API yoqilganini tekshiring.'; }
  if (e && e.status === 404) { return 'Model topilmadi (' + getModel() + '). Sozlamalarda model nomini o‘zgartiring.'; }
  if (e && (e.status === 503 || e.status === 500)) { return 'Google serveri hozir band (yuqori yuklama). Bir ozdan keyin qayta urinib ko‘ring.'; }
  if (e && e.status === 429) { return 'So‘rovlar limiti tugadi. Birozdan keyin qayta urinib ko‘ring.'; }
  if (m === 'blocked') { return 'Bu so‘rovga javob berolmayman. Boshqacha so‘rab ko‘ring.'; }
  if (m === 'empty') { return 'Javob bo‘sh keldi. Qayta urinib ko‘ring.'; }
  return 'Xatolik: ' + m;
}
function send(text) {
  text = (text || '').trim();
  if (!text || busy) { return; }
  hist.push({role: 'user', text: text});
  if (!getKey()) { hist.push({role: 'model', text: 'Google API kaliti kiritilmagan. Sozlamalar (⚙) bo‘limidan kalitni kiriting.', err: true}); saveHist(); updateMsgs(); return; }
  busy = true; saveHist(); updateMsgs();
  askGemini(sysPrompt(), chatContents(), 1200).then(function (t) { hist.push({role: 'model', text: t}); }, function (e) { hist.push({role: 'model', text: errMsg(e), err: true}); }).then(function () { busy = false; saveHist(); updateMsgs(); });
}

function openSettings() { if (view !== 'settings') { prevView = view; } view = 'settings'; buildSettings(); }
function buildSettings() {
  var tc = '';
  TONES.forEach(function (t, k) { tc += '<button class="chip' + (profile.tone === t ? ' on' : '') + '" onclick="setTone(' + k + ')">' + t + '</button>'; });
  app.innerHTML = '<div class="scr"><h1>Sozlamalar</h1>' +
    '<label class="l">ISM</label><input id="s_name" value="' + esc(profile.name) + '">' +
    '<label class="l">KASB</label><input id="s_job" value="' + esc(profile.job) + '">' +
    '<label class="l">GAPLASHISH USLUBI</label><div class="chips">' + tc + '</div>' +
    '<label class="l">GOOGLE (GEMINI) API KALITI</label><input id="s_key" type="password" value="' + esc(settings.apiKey) + '" placeholder="' + (CFG.apiKey && CFG.apiKey.indexOf('__') !== 0 ? 'Ilova ichidagi kalit ishlatilmoqda' : 'AIza...') + '">' +
    '<label class="l">MODEL</label><input id="s_model" value="' + esc(settings.model) + '" placeholder="' + esc(CFG.model || 'gemini-flash-latest') + '">' +
    '<div class="sp"></div><button class="btn" onclick="saveSettings()">Saqlash</button>' +
    '<button class="btn ghost" data-a="seedDemo">Namuna ma‘lumotlar qo‘shish</button>' +
    '<button class="btn ghost" onclick="clearChat()">Suhbatni tozalash</button>' +
    '<button class="btn red" data-a="clearData">Bo‘limlardagi ma‘lumotlarni o‘chirish</button>' +
    '<button class="btn red" onclick="resetAll()">Profilni qayta to‘ldirish</button>' +
    '<button class="btn ghost" onclick="closeSettings()">Orqaga</button></div>';
}
function setTone(k) { profile.tone = TONES[k]; readSettings(); LS.set('lumen_profile', profile); buildSettings(); }
function readSettings() {
  profile.name = $('s_name').value.trim() || profile.name; profile.job = $('s_job').value.trim() || profile.job;
  settings.apiKey = $('s_key').value.trim(); settings.model = $('s_model').value.trim();
}
function saveSettings() { readSettings(); LS.set('lumen_profile', profile); LS.set('lumen_settings', settings); closeSettings(); }
function closeSettings() { go(prevView || 'home'); }
function clearChat() { hist = [{role: 'model', text: 'Suhbat tozalandi. Yangidan boshlaymiz, ' + profile.name + '! Nima qilamiz?'}]; saveHist(); closeSettings(); }
function resetAll() { if (!confirm('Profil va suhbat o‘chiriladi. Davom etamizmi?')) { return; } LS.set('lumen_profile', null); LS.set('lumen_hist', []); profile = null; hist = []; draft = {name: '', job: '', needs: [], extra: '', tone: TONES[0], goal: '', wake: '07:00'}; show('welcome'); }

/* ===================== MONITORING ===================== */
var DATA = LS.get('lumen_data', null) || {};
['fin', 'meds', 'health', 'tasks', 'goals', 'media', 'reports'].forEach(function (k) { if (!DATA[k]) { DATA[k] = []; } });
if (!DATA.medlog) { DATA.medlog = {}; }
var sec = 'fin', finType = 'exp', finCat = 'Oziq-ovqat', hMetric = 'pulse', mediaKind = 'Kitob', repBusy = false, repShown = null, repErr = '', prevView = 'home';
var SECS = [
  {key: 'fin', title: 'Moliya', icon: '💰', color: '#2de2ff', sub: 'Daromad va xarajatlar'},
  {key: 'med', title: 'Dorilar', icon: '💊', color: '#ff6fd8', sub: 'Qabul qilish nazorati'},
  {key: 'hea', title: 'Sog‘liq', icon: '❤️', color: '#ff5a6e', sub: 'Puls, uyqu, qadam, vazn, suv'},
  {key: 'tsk', title: 'Kun rejasi', icon: '📅', color: '#8c6bff', sub: 'Bugungi vazifalar'},
  {key: 'gol', title: 'O‘sish', icon: '🌱', color: '#7dffb3', sub: 'Maqsadlar va taraqqiyot'},
  {key: 'cul', title: 'Madaniyat', icon: '📚', color: '#ffcf5a', sub: 'Kitob va kinolar'},
  {key: 'rep', title: 'Hisobotchi agent', icon: '📊', color: '#4d8dff', sub: 'AI hisobotlar'}
];
var EXP_CATS = ['Oziq-ovqat', 'Transport', 'Kommunal', 'Ko‘ngilochar', 'Sog‘liq', 'Kiyim', 'Boshqa'];
var INC_CATS = ['Maosh', 'Qo‘shimcha', 'Boshqa'];
var CAT_COL = {'Oziq-ovqat': '#2de2ff', 'Transport': '#8c6bff', 'Kommunal': '#4d8dff', 'Ko‘ngilochar': '#ff6fd8', 'Sog‘liq': '#ff5a6e', 'Kiyim': '#ffcf5a', 'Boshqa': '#9fb0ff', 'Maosh': '#7dffb3', 'Qo‘shimcha': '#7dffb3'};
var HM = [{k: 'pulse', n: 'Puls', u: 'urish/daq', agg: 'last'}, {k: 'sleep', n: 'Uyqu', u: 'soat', agg: 'last'}, {k: 'steps', n: 'Qadamlar', u: '', agg: 'sum'}, {k: 'weight', n: 'Vazn', u: 'kg', agg: 'last'}, {k: 'water', n: 'Suv', u: 'stakan', agg: 'sum'}];
var MEDIA_ST = ['Rejada', 'Jarayonda', 'Tugadi'];
var DAYS_S = ['Ya', 'Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh'];
var DAYS_F = ['Yakshanba', 'Dushanba', 'Seshanba', 'Chorshanba', 'Payshanba', 'Juma', 'Shanba'];
var REP = {
  daily: {t: 'Kunlik xulosa', p: 'Bugungi kun uchun qisqa xulosa tayyorla: nima bajarildi, nima qoldi, dorilar qabul qilinishi, bugungi xarajat va 3 ta aniq tavsiya. Sarlavhalar va qisqa ro‘yxatlardan foydalan.'},
  weekly: {t: 'Haftalik hisobot', p: 'Oxirgi 7 kun bo‘yicha hisobot tayyorla: moliya, dorilar intizomi, sog‘liq ko‘rsatkichlari, maqsadlar va vazifalar. Kuchli tomonlar, e’tibor talab qiladigan joylar va kelasi hafta uchun 3 ta reja yoz.'},
  fin: {t: 'Moliya hisoboti', p: 'Moliya bo‘yicha tahlil yoz: daromad va xarajat, eng katta xarajat toifalari, balans va tejash uchun 3 ta amaliy maslahat.'},
  doc: {t: 'Shifokor uchun hisobot', p: 'Shifokorga ko‘rsatish uchun qisqa, tartibli hisobot tayyorla: puls, uyqu, qadamlar, vazn, suv va dori qabul qilish intizomi (7 kun). Tashxis qo‘yma va davolash tavsiya qilma; faqat ma’lumotlarni jadvalsiz, aniq ro‘yxat bilan keltir va e’tibor talab qiluvchi o‘zgarishlarni alohida qayd et.'}
};

function z2(n) { return n < 10 ? '0' + n : '' + n; }
function dkey(d) { d = d || new Date(); return d.getFullYear() + '-' + z2(d.getMonth() + 1) + '-' + z2(d.getDate()); }
function ago(n) { var d = new Date(); d.setDate(d.getDate() - n); return dkey(d); }
function saveData() { LS.set('lumen_data', DATA); }
function uid() { return Date.now().toString(36) + Math.random().toString(36).slice(2, 6); }
function num(n) { var s = String(Math.round(n)); var neg = s.charAt(0) === '-'; if (neg) { s = s.slice(1); } var o = ''; for (var i = 0; i < s.length; i++) { if (i > 0 && (s.length - i) % 3 === 0) { o += ' '; } o += s.charAt(i); } return (neg ? '-' : '') + o; }
function money(n) { return num(n) + ' so‘m'; }
function nowHM() { var d = new Date(); return z2(d.getHours()) + ':' + z2(d.getMinutes()); }
function secInfo(k) { return SECS.filter(function (s) { return s.key === k; })[0]; }

function finMonth() { var m = dkey().slice(0, 7); var inc = 0, exp = 0, cats = {}; DATA.fin.forEach(function (f) { if (f.d.slice(0, 7) !== m) { return; } if (f.t === 'inc') { inc += f.amt; } else { exp += f.amt; cats[f.cat] = (cats[f.cat] || 0) + f.amt; } }); return {inc: inc, exp: exp, bal: inc - exp, cats: cats}; }
function finToday() { var t = dkey(); var s = 0; DATA.fin.forEach(function (f) { if (f.d === t && f.t === 'exp') { s += f.amt; } }); return s; }
function medSlots(dk) { var out = []; DATA.meds.forEach(function (m) { if (m.c && m.c > dk) { return; } m.times.forEach(function (t) { out.push({id: m.id + '|' + t, med: m, time: t}); }); }); out.sort(function (a, b) { return a.time < b.time ? -1 : (a.time > b.time ? 1 : 0); }); return out; }
function medTaken(dk, sid) { return !!(DATA.medlog[dk] && DATA.medlog[dk][sid]); }
function medToday() { var t = dkey(); var sl = medSlots(t); var tk = sl.filter(function (s) { return medTaken(t, s.id); }).length; return {slots: sl, taken: tk, total: sl.length}; }
function medAdherence() { var tot = 0, tk = 0; for (var i = 0; i < 7; i++) { var dk = ago(i); medSlots(dk).forEach(function (s) { tot++; if (medTaken(dk, s.id)) { tk++; } }); } return tot ? Math.round(tk * 100 / tot) : null; }
function nextDose() { var mt = medToday(); var now = nowHM(); var pend = mt.slots.filter(function (s) { return !medTaken(dkey(), s.id); }); if (!pend.length) { return null; } var up = pend.filter(function (s) { return s.time >= now; }); return up.length ? up[0] : pend[0]; }
function hmInfo(k) { return HM.filter(function (h) { return h.k === k; })[0]; }
function hmDay(k, dk) { var agg = hmInfo(k).agg; var items = DATA.health.filter(function (h) { return h.k === k && h.d === dk; }); if (!items.length) { return null; } if (agg === 'sum') { return items.reduce(function (a, b) { return a + b.v; }, 0); } return items[items.length - 1].v; }
function hmLatest(k) { for (var i = DATA.health.length - 1; i >= 0; i--) { if (DATA.health[i].k === k) { return DATA.health[i]; } } return null; }
function tasksToday() { var t = dkey(); return DATA.tasks.filter(function (x) { return x.d === t; }).sort(function (a, b) { var A = a.time || '99:99', B = b.time || '99:99'; return A < B ? -1 : (A > B ? 1 : 0); }); }
function todayStats() { var tk = tasksToday(); var md = medToday(); var total = tk.length + md.total; var done = tk.filter(function (x) { return x.done; }).length + md.taken; return {done: done, total: total, pct: total ? Math.round(done * 100 / total) : 0}; }
function goalsAvg() { if (!DATA.goals.length) { return null; } return Math.round(DATA.goals.reduce(function (a, g) { return a + g.pct; }, 0) / DATA.goals.length); }
function dataEmpty() { return !DATA.fin.length && !DATA.meds.length && !DATA.health.length && !DATA.tasks.length && !DATA.goals.length && !DATA.media.length; }

function digest() {
  var L2 = []; var t = dkey(); var m = finMonth();
  L2.push('Sana: ' + t + ' (' + DAYS_F[new Date().getDay()] + ')');
  var cs = Object.keys(m.cats);
  L2.push('MOLIYA (bu oy): daromad ' + money(m.inc) + ', xarajat ' + money(m.exp) + ', balans ' + money(m.bal) + '. Bugungi xarajat: ' + money(finToday()) + '.' + (cs.length ? ' Toifalar: ' + cs.map(function (c) { return c + ' ' + money(m.cats[c]); }).join(', ') + '.' : ''));
  var md = medToday(); var ad = medAdherence();
  L2.push('DORILAR: ' + (DATA.meds.length ? DATA.meds.map(function (x) { return x.name + (x.dose ? ' ' + x.dose : '') + ' (' + x.times.join(', ') + ')'; }).join('; ') : 'kiritilmagan') + '. Bugun qabul qilingan: ' + md.taken + '/' + md.total + '. 7 kunlik intizom: ' + (ad === null ? 'ma’lumot yo‘q' : ad + '%') + '.');
  var hs = HM.map(function (h) { var l = hmLatest(h.k); var vals = []; for (var i = 0; i < 7; i++) { var v = hmDay(h.k, ago(i)); if (v !== null) { vals.push(v); } } var avg = vals.length ? Math.round(vals.reduce(function (a, b) { return a + b; }, 0) / vals.length * 10) / 10 : null; return h.n + ': ' + (l ? l.v + ' ' + h.u + ' (' + l.d + ')' : 'yo‘q') + (avg !== null ? ', 7 kunlik o‘rtacha ' + avg : ''); });
  L2.push('SOG‘LIQ: ' + hs.join('; ') + '.');
  var tk = tasksToday();
  L2.push('BUGUNGI VAZIFALAR: ' + (tk.length ? tk.map(function (x) { return (x.time ? x.time + ' ' : '') + x.title + (x.done ? ' [bajarildi]' : ' [qoldi]'); }).join('; ') : 'yo‘q') + '.');
  L2.push('MAQSADLAR: ' + (DATA.goals.length ? DATA.goals.map(function (g) { return g.title + ' ' + g.pct + '%'; }).join('; ') : 'yo‘q') + '.');
  L2.push('KITOB/KINO: ' + (DATA.media.length ? DATA.media.map(function (x) { return x.kind + ' «' + x.title + '» — ' + MEDIA_ST[x.st]; }).join('; ') : 'yo‘q') + '.');
  return L2.join('\n');
}

function go(v) { view = v; render(); }
function secSummary(k) {
  if (k === 'fin') { var m = finMonth(); return {main: money(m.bal), sub: 'Bugun: −' + num(finToday()) + ' so‘m'}; }
  if (k === 'med') { var md = medToday(); var nd = nextDose(); return {main: md.total ? md.taken + '/' + md.total + ' bugun' : 'Dori yo‘q', sub: nd ? 'Keyingi: ' + nd.time + ' ' + esc(nd.med.name) : (md.total ? 'Hammasi qabul qilindi ✓' : 'Dori qo‘shing')}; }
  if (k === 'hea') { var p = hmLatest('pulse'); var sl = hmLatest('sleep'); return {main: p ? 'Puls ' + p.v : 'Kiriting', sub: sl ? 'Uyqu ' + sl.v + ' soat' : 'Sog‘liq ko‘rsatkichlari'}; }
  if (k === 'tsk') { var tk = tasksToday(); var dn = tk.filter(function (x) { return x.done; }).length; var nx = tk.filter(function (x) { return !x.done; })[0]; return {main: tk.length ? dn + '/' + tk.length + ' vazifa' : 'Reja yo‘q', sub: nx ? (nx.time ? nx.time + ' ' : '') + esc(nx.title) : (tk.length ? 'Hammasi bajarildi ✓' : 'Vazifa qo‘shing')}; }
  if (k === 'gol') { var av = goalsAvg(); return {main: av === null ? 'Maqsad yo‘q' : av + '% o‘rtacha', sub: DATA.goals.length + ' ta maqsad'}; }
  if (k === 'cul') { var run = DATA.media.filter(function (x) { return x.st === 1; }).length; return {main: DATA.media.length + ' ta', sub: 'Jarayonda: ' + run}; }
  var lr = DATA.reports[DATA.reports.length - 1]; return {main: 'AI hisobot', sub: lr ? 'Oxirgi: ' + esc(lr.t) : 'Kunlik xulosa olish'};
}

function buildHome() {
  var st = todayStats(); var d = new Date();
  var C0 = 2 * Math.PI * 44;
  var cards = SECS.map(function (s) { var c = secSummary(s.key); return '<button class="sc' + (s.key === 'rep' ? ' wide' : '') + '" style="--ac:' + s.color + '" data-a="openSec" data-id="' + s.key + '"><div class="ic">' + s.icon + '</div><div class="tt">' + s.title + '</div><div class="mv">' + c.main + '</div><div class="sb">' + c.sub + '</div></button>'; }).join('');
  app.innerHTML = '<div class="hdr">' + robot(44) + '<div class="t"><b>Salom, ' + esc(profile.name) + '</b><span class="nd">' + DAYS_F[d.getDay()] + ', ' + z2(d.getDate()) + '.' + z2(d.getMonth() + 1) + '.' + d.getFullYear() + '</span></div><button class="gear" data-a="goChat">💬</button><button class="gear" onclick="openSettings()">⚙</button></div>' +
    '<div class="body"><div class="today"><svg width="104" height="104" viewBox="0 0 104 104" style="flex:none"><circle cx="52" cy="52" r="44" fill="none" stroke="rgba(255,255,255,.12)" stroke-width="10"/><circle cx="52" cy="52" r="44" fill="none" stroke="#2de2ff" stroke-width="10" stroke-linecap="round" stroke-dasharray="' + C0 + '" stroke-dashoffset="' + (C0 * (1 - st.pct / 100)) + '" transform="rotate(-90 52 52)"/><text x="52" y="60" text-anchor="middle" font-size="24" font-weight="900" fill="#fff">' + st.pct + '%</text></svg>' +
    '<div><b>Bugungi bajarilish</b><p>' + (st.total ? st.done + ' / ' + st.total + ' ta (vazifa va dorilar)' : 'Hali vazifa yoki dori kiritilmagan') + '</p><button class="chip" data-a="askChat" data-p="Bugungi ma‘lumotlarimga qarab, bugun nimalarga e‘tibor berishim kerakligini qisqa ayt.">💬 Lumen maslahati</button></div></div>' +
    '<div class="sgrid">' + cards + '</div>' +
    (dataEmpty() ? '<button class="btn ghost" data-a="seedDemo" style="margin-top:18px">Namuna ma‘lumotlar bilan to‘ldirish</button>' : '') + '</div>';
}

function buildSec() {
  var s = secInfo(sec); var fn = {fin: secFin, med: secMed, hea: secHea, tsk: secTsk, gol: secGol, cul: secCul, rep: secRep}[sec];
  app.innerHTML = '<div class="hdr"><button class="gear" onclick="go(\'home\')">‹</button><div class="t"><b>' + s.icon + ' ' + s.title + '</b><span class="nd">' + s.sub + '</span></div><button class="gear" data-a="goChat">💬</button></div><div class="body" id="body">' + fn() + '</div>';
}
function keepInputs(ids, fn) { var v = ids.map(function (i) { return $(i) ? $(i).value : ''; }); fn(); ids.forEach(function (i, k) { if ($(i)) { $(i).value = v[k]; } }); }
function chipRow(items, cur, act) { return items.map(function (c) { return '<button class="chip' + (cur === c ? ' on' : '') + '" data-a="' + act + '" data-id="' + esc(c) + '">' + esc(c) + '</button>'; }).join(''); }
function aiBtn(label, prompt) { return '<button class="btn ghost" data-a="askChat" data-p="' + esc(prompt) + '">💬 ' + label + '</button>'; }

function secFin() {
  var m = finMonth(); var cats = Object.keys(m.cats).sort(function (a, b) { return m.cats[b] - m.cats[a]; }); var tot = m.exp || 1;
  var bars = cats.map(function (c) { var p = Math.round(m.cats[c] * 100 / tot); return '<div class="brow"><div class="bl"><span>' + esc(c) + '</span><b>' + money(m.cats[c]) + '</b></div><div class="bt"><div class="bf" style="width:' + p + '%;background:' + (CAT_COL[c] || '#9fb0ff') + '"></div></div></div>'; }).join('') || '<p class="mu">Bu oy hali xarajat yo‘q.</p>';
  var cl = finType === 'exp' ? EXP_CATS : INC_CATS; if (cl.indexOf(finCat) < 0) { finCat = cl[0]; }
  var list = DATA.fin.slice(-15).reverse().map(function (f) { return '<div class="li"><div class="lm"><b>' + esc(f.cat) + '</b><span>' + esc(f.note || '') + (f.note ? ' · ' : '') + f.d.slice(5) + '</span></div><div class="la ' + (f.t === 'inc' ? 'pos' : 'neg') + '">' + (f.t === 'inc' ? '+' : '−') + num(f.amt) + '</div><button class="x" data-a="delFin" data-id="' + f.id + '">×</button></div>'; }).join('');
  return '<div class="kp3"><div class="kp"><span>DAROMAD</span><b class="pos">' + num(m.inc) + '</b></div><div class="kp"><span>XARAJAT</span><b class="neg">' + num(m.exp) + '</b></div><div class="kp"><span>BALANS</span><b>' + num(m.bal) + '</b></div></div>' +
    '<h3>Xarajat toifalari (bu oy)</h3>' + bars +
    '<h3>Yangi yozuv</h3><div class="seg"><button class="chip' + (finType === 'exp' ? ' on' : '') + '" data-a="finType" data-id="exp">Xarajat</button><button class="chip' + (finType === 'inc' ? ' on' : '') + '" data-a="finType" data-id="inc">Daromad</button></div><div class="chips">' + chipRow(cl, finCat, 'finCat') + '</div>' +
    '<input id="f_amt" type="number" inputmode="decimal" placeholder="Summa (so‘m)"><div style="height:10px"></div><input id="f_note" placeholder="Izoh (ixtiyoriy)"><button class="btn sm" data-a="addFin">Qo‘shish</button>' +
    '<h3>So‘nggi yozuvlar</h3>' + (list || '<p class="mu">Yozuvlar yo‘q.</p>') +
    aiBtn('Lumendan moliyaviy maslahat', 'Moliya ma‘lumotlarimni tahlil qilib, tejash bo‘yicha 3 ta aniq maslahat ber.');
}
function secMed() {
  var md = medToday(); var now = nowHM(); var ad = medAdherence(); var nd = nextDose(); var td = dkey();
  var rows = md.slots.map(function (s) { var tk = medTaken(td, s.id); var late = !tk && s.time < now; return '<div class="li' + (late ? ' late' : '') + '"><button class="ck' + (tk ? ' on' : '') + '" data-a="togMed" data-id="' + esc(s.id) + '">' + (tk ? '✓' : '') + '</button><div class="lm"><b>' + esc(s.med.name) + (s.med.dose ? ' · ' + esc(s.med.dose) : '') + '</b><span>' + s.time + (late ? ' · kechikdi' : '') + (s.med.note ? ' · ' + esc(s.med.note) : '') + '</span></div></div>'; }).join('') || '<p class="mu">Bugun uchun dori yo‘q. Quyida dori qo‘shing.</p>';
  var meds = DATA.meds.map(function (m) { return '<div class="li"><div class="lm"><b>' + esc(m.name) + (m.dose ? ' · ' + esc(m.dose) : '') + '</b><span>' + m.times.join(', ') + '</span></div><button class="x" data-a="delMed" data-id="' + m.id + '">×</button></div>'; }).join('');
  return '<div class="kp3"><div class="kp"><span>BUGUN</span><b>' + md.taken + '/' + md.total + '</b></div><div class="kp"><span>7 KUN</span><b>' + (ad === null ? '—' : ad + '%') + '</b></div><div class="kp"><span>KEYINGI</span><b>' + (nd ? nd.time : '—') + '</b></div></div>' +
    '<h3>Bugungi dorilar</h3>' + rows +
    '<h3>Dori qo‘shish</h3><input id="m_name" placeholder="Dori nomi"><div style="height:10px"></div><input id="m_dose" placeholder="Dozasi (masalan: 500 mg)"><div style="height:10px"></div><input id="m_times" value="08:00, 20:00" placeholder="Vaqtlar: 08:00, 20:00"><div style="height:10px"></div><input id="m_note" placeholder="Izoh (ovqatdan keyin...)"><button class="btn sm" data-a="addMed">Qo‘shish</button>' +
    (meds ? '<h3>Mening dorilarim</h3>' + meds : '') +
    '<p class="mu small">Ilova qabul qilinganini kuzatadi, lekin ovozli eslatma chiqarmaydi. Dorilar bo‘yicha shifokor maslahatiga amal qiling.</p>';
}
function secHea() {
  var hm = hmInfo(hMetric);
  var chips = HM.map(function (h) { var l = hmLatest(h.k); return '<button class="chip' + (hMetric === h.k ? ' on' : '') + '" data-a="setHm" data-id="' + h.k + '">' + h.n + (l ? ' · ' + l.v : '') + '</button>'; }).join('');
  var days = [], vals = []; for (var i = 6; i >= 0; i--) { var d = new Date(); d.setDate(d.getDate() - i); days.push(DAYS_S[d.getDay()]); vals.push(hmDay(hMetric, dkey(d))); }
  var mx = Math.max.apply(null, vals.map(function (v) { return v || 0; }).concat([1]));
  var bars = vals.map(function (v, i) { return '<div class="cb"><div class="cv">' + (v === null ? '' : v) + '</div><div class="cf" style="height:' + (v === null ? 2 : Math.max(4, Math.round(v * 100 / mx))) + 'px"></div><div class="cd">' + days[i] + '</div></div>'; }).join('');
  var last = hmLatest(hMetric);
  return '<div class="chips">' + chips + '</div><h3>' + hm.n + ' — oxirgi 7 kun</h3><div class="chart">' + bars + '</div>' +
    '<p class="mu">' + (last ? 'Oxirgi: <b>' + last.v + ' ' + hm.u + '</b> (' + last.d.slice(5) + ')' : 'Hali qiymat kiritilmagan.') + '</p>' +
    '<h3>Qiymat kiritish</h3><input id="h_val" type="number" inputmode="decimal" step="any" placeholder="' + hm.n + (hm.u ? ' (' + hm.u + ')' : '') + '"><button class="btn sm" data-a="addHealth">Saqlash</button>' +
    (hMetric === 'water' ? '<button class="btn ghost" data-a="waterPlus">+ 1 stakan suv</button>' : '') +
    aiBtn('Lumendan sog‘liq maslahati', 'Sog‘liq ko‘rsatkichlarimni (puls, uyqu, qadam, vazn, suv) tahlil qilib, qisqa maslahat ber.') +
    '<p class="mu small">Bu ma‘lumotlar tibbiy tashxis emas. Xavotir bo‘lsa, shifokorga murojaat qiling.</p>';
}
function secTsk() {
  var tk = tasksToday(); var dn = tk.filter(function (x) { return x.done; }).length; var p = tk.length ? Math.round(dn * 100 / tk.length) : 0;
  var rows = tk.map(function (x) { return '<div class="li"><button class="ck' + (x.done ? ' on' : '') + '" data-a="togTask" data-id="' + x.id + '">' + (x.done ? '✓' : '') + '</button><div class="lm"><b style="' + (x.done ? 'text-decoration:line-through;opacity:.6' : '') + '">' + esc(x.title) + '</b><span>' + (x.time || 'vaqtsiz') + '</span></div><button class="x" data-a="delTask" data-id="' + x.id + '">×</button></div>'; }).join('') || '<p class="mu">Bugun uchun vazifa yo‘q.</p>';
  return '<div class="today" style="display:block"><b>' + dn + ' / ' + tk.length + ' bajarildi</b><div class="pb"><div style="width:' + p + '%"></div></div></div><h3>Bugungi vazifalar</h3>' + rows +
    '<h3>Vazifa qo‘shish</h3><input id="t_title" placeholder="Nima qilish kerak?"><div style="height:10px"></div><input id="t_time" type="time"><button class="btn sm" data-a="addTask">Qo‘shish</button>' +
    aiBtn('Lumendan kun rejasi', 'Bugungi vazifalarimni hisobga olib, kunim uchun soatma-soat reja tuz.');
}
function secGol() {
  var rows = DATA.goals.map(function (g) { return '<div class="li" style="display:block"><div style="display:flex;align-items:center;gap:10px"><div class="lm"><b>' + (g.pct >= 100 ? '✓ ' : '') + esc(g.title) + '</b><span>' + g.pct + '%</span></div><div class="step"><button data-a="goalStep" data-id="' + g.id + '" data-d="-10">−10</button><button data-a="goalStep" data-id="' + g.id + '" data-d="10">+10</button></div><button class="x" data-a="delGoal" data-id="' + g.id + '">×</button></div><div class="pb"><div style="width:' + g.pct + '%"></div></div></div>'; }).join('') || '<p class="mu">Hali maqsad yo‘q.</p>';
  return '<h3>Maqsadlarim</h3>' + rows + '<h3>Yangi maqsad</h3><input id="g_title" placeholder="Masalan: ingliz tilini o‘rganish"><button class="btn sm" data-a="addGoal">Qo‘shish</button>' +
    aiBtn('Maqsadlar bo‘yicha maslahat', 'Maqsadlarimga erishish uchun har biriga bitta aniq keyingi qadam taklif qil.');
}
function secCul() {
  var rows = DATA.media.map(function (x) { return '<div class="li"><div class="lm"><b>' + (x.kind === 'Kitob' ? '📖 ' : '🎬 ') + esc(x.title) + '</b><span>' + x.kind + '</span></div><button class="st s' + x.st + '" data-a="cycleMedia" data-id="' + x.id + '">' + MEDIA_ST[x.st] + '</button><button class="x" data-a="delMedia" data-id="' + x.id + '">×</button></div>'; }).join('') || '<p class="mu">Ro‘yxat bo‘sh.</p>';
  return '<h3>Ro‘yxatim</h3>' + rows + '<h3>Qo‘shish</h3><div class="seg">' + chipRow(['Kitob', 'Kino'], mediaKind, 'setKind') + '</div><div style="height:10px"></div><input id="c_title" placeholder="Nomi"><button class="btn sm" data-a="addMedia">Qo‘shish</button>' +
    aiBtn('Lumendan tavsiya', 'Qiziqishlarimga qarab, bitta kitob va bitta kino tavsiya qil, nima uchun ekanini qisqa yoz.');
}
function secRep() {
  var btns = [['daily', '☀️ Kunlik xulosa'], ['weekly', '🗓 Haftalik hisobot'], ['fin', '💰 Moliya hisoboti'], ['doc', '🩺 Shifokor uchun']].map(function (b) { return '<button class="chip" data-a="report" data-id="' + b[0] + '"' + (repBusy ? ' disabled' : '') + '>' + b[1] + '</button>'; }).join('');
  var cur = repShown !== null ? DATA.reports[repShown] : null; var body = '';
  if (repBusy) { body = '<div class="rep"><div class="m a typing"><span></span><span></span><span></span></div></div>'; }
  else if (repErr) { body = '<div class="rep"><div class="m a err">' + esc(repErr) + '</div></div>'; }
  else if (cur) { body = '<div class="rep"><b>' + esc(cur.t) + '</b><div class="mu small">' + new Date(cur.ts).toLocaleString() + '</div><div class="m" style="max-width:100%;background:none;padding:0;margin:10px 0 0">' + md(cur.text) + '</div><div class="chips"><button class="chip" data-a="copyRep">📋 Nusxa olish</button><button class="chip" data-a="shareRep">↗ Ulashish</button></div></div>'; }
  else { body = '<p class="mu">Hisobot turini tanlang. Hisobotchi agent ilovadagi barcha bo‘limlar ma‘lumotlarini yig‘ib, Gemini yordamida tayyorlaydi.</p>'; }
  var past = DATA.reports.map(function (r, i) { return '<div class="li" data-a="viewRep" data-id="' + i + '"><div class="lm"><b>' + esc(r.t) + '</b><span>' + new Date(r.ts).toLocaleString() + '</span></div></div>'; }).reverse().join('');
  return '<h3>Hisobot turi</h3><div class="chips">' + btns + '</div>' + body + '<details class="dg"><summary>Hisobot uchun yig‘ilgan ma‘lumotlar</summary><pre>' + esc(digest()) + '</pre></details>' + (past ? '<h3>Oldingi hisobotlar</h3>' + past : '');
}
function repSys() {
  return 'Sen "Hisobotchi agent" — Agent Lumen tizimidagi hisobot tayyorlovchi agentsan. Foydalanuvchi: ' + profile.name + ' (' + profile.job + '). Faqat berilgan ma‘lumotlarga tayanib, o‘zbek tilida (lotin yozuvida) aniq va tartibli hisobot yoz. Ma‘lumot yo‘q bo‘lsa, "ma‘lumot kiritilmagan" deb ayt, hech narsani to‘qima. Tibbiy tashxis qo‘yma va moliyaviy kafolat berma. Uslub: ' + profile.tone + '.';
}

var ACTIONS = {
  goChat: function () { go('chat'); },
  openSec: function (k) { sec = k; go('sec'); },
  askChat: function (id, el) { var p = el.getAttribute('data-p'); view = 'chat'; buildChat(); send(p); },
  finType: function (t) { keepInputs(['f_amt', 'f_note'], function () { finType = t; finCat = (t === 'exp' ? EXP_CATS : INC_CATS)[0]; buildSec(); }); },
  finCat: function (c) { keepInputs(['f_amt', 'f_note'], function () { finCat = c; buildSec(); }); },
  addFin: function () { var a = parseFloat($('f_amt').value); if (!(a > 0)) { bad('f_amt'); return; } DATA.fin.push({id: uid(), t: finType, amt: a, cat: finCat, note: $('f_note').value.trim(), d: dkey()}); saveData(); buildSec(); },
  delFin: function (id) { DATA.fin = DATA.fin.filter(function (f) { return f.id !== id; }); saveData(); buildSec(); },
  togMed: function (sid) { var t = dkey(); if (!DATA.medlog[t]) { DATA.medlog[t] = {}; } if (DATA.medlog[t][sid]) { delete DATA.medlog[t][sid]; } else { DATA.medlog[t][sid] = true; } saveData(); buildSec(); },
  addMed: function () {
    var name = $('m_name').value.trim(); if (!name) { bad('m_name'); return; }
    var ts = ($('m_times').value.match(/\d{1,2}:\d{2}/g) || ['08:00']).map(function (t) { var p = t.split(':'); return z2(parseInt(p[0], 10)) + ':' + p[1]; });
    ts = ts.filter(function (t, i) { return ts.indexOf(t) === i; }).sort();
    DATA.meds.push({id: uid(), name: name, dose: $('m_dose').value.trim(), times: ts, note: $('m_note').value.trim(), c: dkey()}); saveData(); buildSec();
  },
  delMed: function (id) { DATA.meds = DATA.meds.filter(function (m) { return m.id !== id; }); saveData(); buildSec(); },
  setHm: function (k) { hMetric = k; buildSec(); },
  addHealth: function () { var v = parseFloat($('h_val').value); if (isNaN(v)) { bad('h_val'); return; } DATA.health.push({id: uid(), k: hMetric, v: v, d: dkey()}); saveData(); buildSec(); },
  waterPlus: function () { DATA.health.push({id: uid(), k: 'water', v: 1, d: dkey()}); saveData(); buildSec(); },
  addTask: function () { var t = $('t_title').value.trim(); if (!t) { bad('t_title'); return; } DATA.tasks.push({id: uid(), title: t, time: $('t_time').value, done: false, d: dkey()}); saveData(); buildSec(); },
  togTask: function (id) { DATA.tasks.forEach(function (x) { if (x.id === id) { x.done = !x.done; } }); saveData(); buildSec(); },
  delTask: function (id) { DATA.tasks = DATA.tasks.filter(function (x) { return x.id !== id; }); saveData(); buildSec(); },
  addGoal: function () { var t = $('g_title').value.trim(); if (!t) { bad('g_title'); return; } DATA.goals.push({id: uid(), title: t, pct: 0}); saveData(); buildSec(); },
  goalStep: function (id, el) { var dl = parseInt(el.getAttribute('data-d'), 10); DATA.goals.forEach(function (g) { if (g.id === id) { g.pct = Math.max(0, Math.min(100, g.pct + dl)); } }); saveData(); buildSec(); },
  delGoal: function (id) { DATA.goals = DATA.goals.filter(function (g) { return g.id !== id; }); saveData(); buildSec(); },
  setKind: function (k) { keepInputs(['c_title'], function () { mediaKind = k; buildSec(); }); },
  addMedia: function () { var t = $('c_title').value.trim(); if (!t) { bad('c_title'); return; } DATA.media.push({id: uid(), kind: mediaKind, title: t, st: 0}); saveData(); buildSec(); },
  cycleMedia: function (id) { DATA.media.forEach(function (x) { if (x.id === id) { x.st = (x.st + 1) % 3; } }); saveData(); buildSec(); },
  delMedia: function (id) { DATA.media = DATA.media.filter(function (x) { return x.id !== id; }); saveData(); buildSec(); },
  report: function (k) {
    if (repBusy) { return; }
    repErr = ''; repShown = null;
    if (!getKey()) { repErr = 'Google API kaliti kiritilmagan. Sozlamalar (⚙) bo‘limidan kalitni kiriting.'; buildSec(); return; }
    repBusy = true; buildSec();
    var r = REP[k]; var contents = [{role: 'user', parts: [{text: r.p + '\n\nMa‘lumotlar:\n' + digest()}]}];
    askGemini(repSys(), contents, 2000).then(function (text) {
      DATA.reports.push({id: uid(), k: k, t: r.t, ts: Date.now(), text: text}); DATA.reports = DATA.reports.slice(-10); saveData(); repShown = DATA.reports.length - 1;
    }, function (e) { repErr = errMsg(e); }).then(function () { repBusy = false; if (view === 'sec' && sec === 'rep') { buildSec(); } });
  },
  viewRep: function (i) { repErr = ''; repShown = parseInt(i, 10); buildSec(); },
  copyRep: function () { var r = DATA.reports[repShown]; if (!r) { return; } var done = function () { alert('Nusxa olindi'); }; if (navigator.clipboard && navigator.clipboard.writeText) { navigator.clipboard.writeText(r.text).then(done, function () { fallbackCopy(r.text); }); } else { fallbackCopy(r.text); } },
  shareRep: function () { var r = DATA.reports[repShown]; if (!r) { return; } if (navigator.share) { navigator.share({title: r.t, text: r.text}).catch(function () {}); } else { fallbackCopy(r.text); } },
  seedDemo: function () { seedDemo(); go('home'); },
  clearData: function () { if (!confirm('Barcha bo‘limlardagi ma‘lumotlar o‘chiriladi. Davom etamizmi?')) { return; } DATA = {fin: [], meds: [], medlog: {}, health: [], tasks: [], goals: [], media: [], reports: []}; saveData(); go('home'); }
};
function fallbackCopy(text) { try { var ta = document.createElement('textarea'); ta.value = text; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta); alert('Nusxa olindi'); } catch (e) { alert('Nusxa olib bo‘lmadi'); } }
document.addEventListener('click', function (e) { var el = e.target && e.target.closest ? e.target.closest('[data-a]') : null; if (!el) { return; } var fn = ACTIONS[el.getAttribute('data-a')]; if (fn) { fn(el.getAttribute('data-id'), el); } });

function seedDemo() {
  var fin = [['exp', 45000, 'Oziq-ovqat', 'Bozor', 0], ['exp', 24500, 'Transport', 'Taksi', 0], ['exp', 150000, 'Kommunal', 'Gaz', 1], ['exp', 85000, 'Ko‘ngilochar', 'Kino va kafe', 2], ['exp', 120000, 'Oziq-ovqat', 'Supermarket', 3], ['exp', 60000, 'Sog‘liq', 'Dorixona', 4], ['inc', 4500000, 'Maosh', 'Oylik', 5], ['inc', 300000, 'Qo‘shimcha', 'Loyiha', 2]];
  fin.forEach(function (f) { DATA.fin.push({id: uid(), t: f[0], amt: f[1], cat: f[2], note: f[3], d: ago(f[4])}); });
  var m1 = {id: uid(), name: 'Vitamin D3', dose: '1 tabletka', times: ['08:00'], note: 'ovqatdan keyin', c: ago(6)}; var m2 = {id: uid(), name: 'Omega-3', dose: '1 kapsula', times: ['08:00', '20:00'], note: '', c: ago(6)}; DATA.meds.push(m1, m2);
  for (var i = 1; i <= 6; i++) { var dk = ago(i); DATA.medlog[dk] = {}; DATA.medlog[dk][m1.id + '|08:00'] = true; DATA.medlog[dk][m2.id + '|08:00'] = true; if (i % 3 !== 0) { DATA.medlog[dk][m2.id + '|20:00'] = true; } }
  var td = dkey(); DATA.medlog[td] = DATA.medlog[td] || {}; DATA.medlog[td][m1.id + '|08:00'] = true;
  for (var j = 6; j >= 0; j--) { var d = ago(j); DATA.health.push({id: uid(), k: 'pulse', v: 60 + ((j * 7) % 14), d: d}, {id: uid(), k: 'sleep', v: 6 + ((j * 3) % 5) / 2, d: d}, {id: uid(), k: 'steps', v: 4000 + ((j * 1700) % 6000), d: d}, {id: uid(), k: 'water', v: 3 + (j % 4), d: d}); if (j % 3 === 0) { DATA.health.push({id: uid(), k: 'weight', v: 77.5 - j * 0.1, d: d}); } }
  DATA.tasks.push({id: uid(), title: 'Ertalabki mashq', time: '07:30', done: true, d: td}, {id: uid(), title: 'Loyiha bo‘yicha uchrashuv', time: '15:00', done: false, d: td}, {id: uid(), title: 'Kitob o‘qish (30 daqiqa)', time: '21:00', done: false, d: td});
  DATA.goals.push({id: uid(), title: 'Ingliz tilini o‘rganish', pct: 40}, {id: uid(), title: 'Har kuni 8000 qadam', pct: 65}, {id: uid(), title: 'Jamg‘arma: 5 mln so‘m', pct: 30});
  DATA.media.push({id: uid(), kind: 'Kitob', title: 'Atomic Habits', st: 1}, {id: uid(), kind: 'Kino', title: 'Interstellar', st: 0}, {id: uid(), kind: 'Kitob', title: 'O‘tkan kunlar', st: 2});
  saveData();
}

window.lumenBack = function () {
  if (view === 'settings') { closeSettings(); return true; }
  if (view === 'sec' || view === 'chat') { go('home'); return true; }
  var i = STEPS.indexOf(view);
  if (i > 0) { prevStep(); return true; }
  return false;
};
if (profile) { go('home'); } else { render(); }
</script>
</body>
</html>
LUMEN_EOF
echo "Loyiha fayllari yaratildi"
