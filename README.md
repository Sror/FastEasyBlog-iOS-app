#FastEasyBlog
=============

![FastEasyBlog icon](http://img.my.csdn.net/uploads/201303/17/1363490143_5437.jpg.thumb.jpg)


##Overview
==========
###introduce images

![home page](http://img.my.csdn.net/uploads/201211/06/1352207659_3715.PNG)

###introduce info

It's a **iPhone** client app to help you share and twitter your idea and the feeling what you are thinking.
###sale and download
1.  visit the **iTunes** or **app stone** at [FastEasyBlog's download URL](https://itunes.apple.com/cn/app/id554504019?mt=8) 
2.  use any 2-dimensional bar code tool to scan the image:<br />
![download image url](http://img.my.csdn.net/uploads/201211/06/1352208734_1417.png)

##Purpose
=========
Last year, when I was studying ios-development, the White House's iOS App helped me so much.I konw open source is a good way to improve myself and help some newer.What's more sharing the code may let us communicate with each other usefully.<br />
Finally, you can add more functions for the app if you want.

##Attention
===========
there are some ***notifications*** that you should notice list below:
> (1) the app's running-environment at least iOS **5.1**, so it supports iOS version is:5.1+<br />
> (2) the app **doesn't** support iPhone 5's screen size, it means the app is better for iPhone 4 and 4S.<br />
> (3) it **doesn't** support [tianya](http://bbs.tianya.cn/) now.<br />
> (4) because of sina weibo's ***policy***, the app also **doesn't** support synchronous to sina weibo.

##Run and Debug
===============
to run the app, you need todo:

 * Xcode version 4.3.2, if 4.5 is a plus
 * the open platform's app key and secret(you need to be a developer of sina weibo/tencent weibo/renren if you want use it's open platform API) then search the file ***GlobalConstDefinition.h***,open it and find the **TODO** code segment:
 
```
//sina
/*
 *TODO:
 *go to sina weibo's open platform:http://open.weibo.com/ to apply a ios app
 *then write the appkey and app secret
 */
\#define kWBSDKDemoAppKey @""
\#define kWBSDKDemoAppSecret @""

//tencent
/*
 *TODO:
 *go to tencent weibo's open platform:http://dev.t.qq.com/ to apply a ios app
 *then write the appkey and app secret
 */
\#define oauthAppKey @""
\#define oauthAppSecret @""

//renren
/*
 *TODO:
 *go to renren's open platform:http://app.renren.com/developers to apply a ios app
 *then write the app_ID and API_Key
 */

\#define kAPP_ID     @""
\#define kAPI_Key    @""
```
replace the empty str(@"") with the key and secret that you applied

##License
=========
Copyright (c) 2013 yanghua_kobe. All rights reserved.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.


##Contact
=========
any problem, let me know:

1. <yanghua1127@gmail.com>
2. <http://blog.csdn.net/yanghua_kobe>

### enjoy and have fun!