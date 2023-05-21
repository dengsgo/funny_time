# Funny Time App

一个全屏显示的时间软件，类似于 always on display (AOD, 永久显示) 的效果。

非常适合 OLED、Amoled 屏幕常亮使用。

使用 Flutter 技术开发，理论上支持全平台(Web、Android、iOS等)，Web、iOS 已测试。

## Usage 

打开 App, 会默认全屏显示一个时间组件，屏幕背景为全黑（#FF000000）。  

时间组件会随着时间做微小的移动以防止长时间显示导致的“烧屏”。 

点击时间组件，底部会显示一排设置工具栏，点击相应图标即可调整组件的外观，再次点击时间组件会隐藏设置工具栏。  

[查看App截图](#screenshot)

## Build

本地搭建 Flutter 开发环境，[flutter](https://flutter.dev)  

然后在本项目打开命令行窗口，执行下面命令即可构建。（可能需要选择构建平台，根据需要配置选择即可）

``` bash
flutter upgarde 
flutter pub get 
flutter run --release
```

## Develop 

本项目理论上支持多平台，开发时可以使用 Web 平台调试。

```bash
# Choose Web (Chrome Or Edge)
flutter run 
```

## Issue 

项目为自用软件开源，目前仅满足自己的需求。如果你使用中发现 Bug 或者有好的改进建议,
[欢迎提出 Issue](https://github.com/dengsgo/funny_time/issue) . 

## Donation

开源不易，纯属用爱发电。如果本软件对你有帮助，可以扫码请作者喝一杯咖啡。  

| 微信                                                        | 支付宝                                                        |
|-----------------------------------------------------------|------------------------------------------------------------|
| <img alt="微信" src="./doc/qrcode/wxpay.png" width="200" /> | <img alt="微信" src="./doc/qrcode/alipay.png" width="200" /> |


## Screenshot

### 屏显 

<img alt="屏显" src="./doc/asserts/sceen01.png" width="30%"/>  
<img alt="屏显" src="./doc/asserts/screen02.png" width="30%"/>  
<img alt="屏显" src="./doc/asserts/screen03.png" width="30%"/>
<img alt="屏显" src="./doc/asserts/screen_04.png" width="30%"/>  
<br/>

### 工具栏

<img alt="工具栏" src="./doc/asserts/toolbar (1).png" width="30%"/>  
<img alt="工具栏" src="./doc/asserts/toolbar (2).png" width="30%"/>  
<img alt="工具栏" src="./doc/asserts/toolbar (3).png" width="30%"/>  
<img alt="工具栏" src="./doc/asserts/toolbar (4).png" width="30%"/>  
<img alt="工具栏" src="./doc/asserts/toolbar (5).png" width="30%"/>
<br/>

### 字体样式

<img alt="字体样式" src="./doc/asserts/fontStyle (1).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (2).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (3).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (4).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (5).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (6).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (7).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (8).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (9).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (10).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (11).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (12).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (13).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (14).png" width="30%"/>
<img alt="字体样式" src="./doc/asserts/fontStyle (15).png" width="30%"/>








