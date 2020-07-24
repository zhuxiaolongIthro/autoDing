#!/bin/bash

adb shell uiautomator dump /sdcard/$1.xml
adb pull /sdcard/$1.xml ~/Desktop/androidToolShell/shs
exit 0
