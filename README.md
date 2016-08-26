# RGSS
个人编写的一些RGSS脚本。其中一部分发表在卫星游戏工作室的[主站](https://www.s-gs.net/category/rgss/)上。

## fullscreen.rb
实现了 `Graphics.fullscreen?` 方法,用于判断RM窗口是否处于全屏状态。

## IniFile.rb
用于在RGSS中读取、写入ini文件中的值。
<pre>INI = IniFile.new(".\\Game.ini")
p INI[:Game][:Title] #获取游戏标题，缓冲区大小默认为64
p INI[:Game][:Title2] #读取一个不存在的键，则返回空字符串
p INI[:Game][:Title2,"NONE",128] #若读取的键不存在则返回"NONE"，并指定缓冲区大小为128
INI[:Game][:Title] = "Project1" #写入键值</pre>

## FTP.rb
用于在RM中连接FTP。功能不甚完善，仅供试验用。

## EasyConv.rb
转码模块，原作者不明。原版脚本实现了 `EasyConv.s2u(str)`, `EasyConv.s2u(str)` 两个模块方法。我将其修改为String类的实例方法，使用较为方便。