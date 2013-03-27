//
//  Global.m
//  RenRenTest
//
//  Created by svp on 12.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "Global.h"
#import "Reachability.h"        //网络检测

#pragma mark - Global implemention
#pragma mark -

@implementation Global

static Global *_global;

/*
 *获得Global的单例对象
 */
+(Global*)GetGlobalInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _global=[[Global alloc]init];
    });
    return _global;
}


/*
 *根据key从配置文件中读取value
 */
-(id)readConfigInfoFromConfigFileWithKey:(NSString *)key
                             forPlatform:(AllPlatform)platform{
	//NSDictionary *configs=[self GetAllPlatformInfo];
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	switch (platform) {
		case RenRen:{
			if (![defaults objectForKey:RENRENCONFIG]) {
				[defaults setObject:[[[NSMutableDictionary alloc]init]autorelease] forKey:RENRENCONFIG];
			}
			return [[defaults objectForKey:RENRENCONFIG]objectForKey:key];
		}
			break;
		case TencentWeibo:
			if (![defaults objectForKey:TENCENTWEIBOCONFIG]) {
				[defaults setObject:[[[NSMutableDictionary alloc]init]autorelease] forKey:TENCENTWEIBOCONFIG];
			}
			return [[defaults objectForKey:TENCENTWEIBOCONFIG]objectForKey:key];
			break;
		case SinaWeibo:
			if (![defaults objectForKey:SINAWEIBOCONFIG]) {
				[defaults setObject:[[[NSMutableDictionary alloc]init]autorelease] forKey:SINAWEIBOCONFIG];
			}
			return [[defaults objectForKey:SINAWEIBOCONFIG]objectForKey:key];
			break;
		case Tianya:
			if (![defaults objectForKey:DOUBANCONFIG]) {
				[defaults setObject:[[[NSMutableDictionary alloc]init]autorelease] forKey:DOUBANCONFIG];
			}
			return [[defaults objectForKey:DOUBANCONFIG]objectForKey:key];
			break;
		default:
			break;
	}
	return nil;
}

/*
 *写入配置信息
 */
-(void)writeConfigInfoToConfigFileWithValue:(id)value
                                     forKey:(NSString *)key
                                forPlatform:(AllPlatform)platform{
	//NSMutableDictionary *configs=[[self GetAllPlatformInfo]mutableCopy];
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	switch (platform) {
		case RenRen:{
			NSMutableDictionary *renrenConfig=[[defaults objectForKey:RENRENCONFIG]mutableCopy];
			if (!renrenConfig) {
				renrenConfig=[[NSMutableDictionary alloc]init];
			}
			[renrenConfig setValue:value forKey:key];
			//NSLog(@"%@",renrenConfig);
			[defaults setObject:renrenConfig forKey:RENRENCONFIG];
            [renrenConfig release];
		}
			break;
			
		case TencentWeibo:{
			NSMutableDictionary *tencentWeiboConfig=[[defaults objectForKey:TENCENTWEIBOCONFIG]mutableCopy];
			if (!tencentWeiboConfig) {
				tencentWeiboConfig=[[NSMutableDictionary alloc]init];
			}
			[tencentWeiboConfig setValue:value forKey:key];
			[defaults setObject:tencentWeiboConfig forKey:TENCENTWEIBOCONFIG];
            [tencentWeiboConfig release];
		}
			break;
			
		case SinaWeibo:{
			NSMutableDictionary *sinaWeiboConfig=[[defaults objectForKey:SINAWEIBOCONFIG]mutableCopy];
			if (!sinaWeiboConfig) {
				sinaWeiboConfig=[[NSMutableDictionary alloc]init];
			}
			[sinaWeiboConfig setValue:value forKey:key];
			[defaults setObject:sinaWeiboConfig forKey:SINAWEIBOCONFIG];
            [sinaWeiboConfig release];
		}
			break;
			
		case Tianya:{
			//NSDictionary *doubanConfig=[configs objectForKey:@"Douban"];
			NSMutableDictionary *doubanConfig=[[defaults objectForKey:DOUBANCONFIG]mutableCopy];
			if (!doubanConfig) {
				doubanConfig=[[NSMutableDictionary alloc]init];
			}
			[doubanConfig setValue:value forKey:key];
			[defaults setObject:doubanConfig forKey:DOUBANCONFIG];
            [doubanConfig release];
		}
			break;
			
		default:
			break;
	}
	
	//保存	
	[defaults synchronize];
}

/*
 *删除给定的配置项
 */
-(void)deleteConfigItemFromConfigFileWithKey:(NSString*)key
                                 forPlatform:(AllPlatform)platform{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	switch (platform) {
		case RenRen:{
			NSMutableDictionary *renrenConfig=[[defaults objectForKey:RENRENCONFIG]mutableCopy];
			[renrenConfig removeObjectForKey:key];
			[defaults setObject:renrenConfig forKey:RENRENCONFIG];
            [renrenConfig release];
		}
			break;
		case TencentWeibo:{
			NSMutableDictionary *tencentWeiboConfig=[[defaults objectForKey:TENCENTWEIBOCONFIG]mutableCopy];
			[tencentWeiboConfig removeObjectForKey:key];
			[defaults setObject:tencentWeiboConfig forKey:TENCENTWEIBOCONFIG];
            [tencentWeiboConfig release];
		}
			break;
		case SinaWeibo:{
			NSMutableDictionary *sinaWeiboConfig=[[defaults objectForKey:SINAWEIBOCONFIG]mutableCopy];
			[sinaWeiboConfig removeObjectForKey:key];
			[defaults setObject:sinaWeiboConfig forKey:SINAWEIBOCONFIG];
            [sinaWeiboConfig release];
		}
			break;
		case Tianya:{
			NSMutableDictionary *doubanConfig=[[defaults objectForKey:DOUBANCONFIG]mutableCopy];
			[doubanConfig removeObjectForKey:key];
			[defaults setObject:doubanConfig forKey:DOUBANCONFIG];
            [doubanConfig release];
		}
			break;
			
	}
	
	//保存	
	[defaults synchronize];
}

/*
 *日期格式的字符串转换为时间格式
 */
-(NSDate*)NSStringDateToNSDate:(NSString*)dateString{
	NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyyMMdd-HHmmss"];
	NSDate *date=[formatter dateFromString:dateString];
	[formatter release];
	return date;
}

/*
 *日期转化为日期格式的字符串
 */
-(NSString*)NSDateToNSString:(NSDate*)date{
	NSDateFormatter *formatter=[[[NSDateFormatter alloc]init]autorelease];
	[formatter setDateFormat:@"yyyy年MM月dd日HH时mm分ss秒"];
	NSString *dateString=[formatter stringFromDate:date];
	return dateString;
}

/*
 *日期格式的字符串转换为时间格式
 */
-(NSDate*)NSStringDateToNSDate:(NSString*)dateString
                 withFormatter:(NSDateFormatter*)formatter{
	return [formatter dateFromString:dateString];
}

/*
 *日期转化为日期格式的字符串
 */
-(NSString*)NSDateToNSString:(NSDate*)date
               withFormatter:(NSDateFormatter*)formatter{
	NSString	*dateString=[formatter stringFromDate:date];
	return dateString;
}

/*
 *日期字符串的格式化
 */
-(NSString*)FormatWithDateString:(NSString*)dateString 
						 withSourceFormatter:(NSDateFormatter*)sourceFormatter 
							forResultFormatter:(NSDateFormatter*)resultFormatter{
	NSDate *tmpDate=[GlobalInstance NSStringDateToNSDate:dateString withFormatter:sourceFormatter];
	return [GlobalInstance NSDateToNSString:tmpDate withFormatter:resultFormatter];
}

#pragma mark - get many kinds of height -
/*
 *获取特定大小的文本高度
 */
-(CGFloat)getHeightWithText:(NSString*)text
                   fontSize:(CGFloat)fontSize
                 constraint:(CGSize)cSize
                  minHeight:(CGFloat)mHeight{
    if (text==nil) {
        return mHeight;
    }
    CGFloat result=0.0f;
	CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:cSize lineBreakMode:UILineBreakModeWordWrap];
	result=MAX(size.height,mHeight);
	
	return result;
}

/*
 *获取特定大小的文本高度
 */
-(CGFloat)getHeightWithFontText:(NSString*)text
                           font:(UIFont*)_font
                     constraint:(CGSize)cSize
                      minHeight:(CGFloat)mHeight{
    if (text==nil) {
        return mHeight;
    }
    CGFloat result=0.0f;
	CGSize size=[text sizeWithFont:_font constrainedToSize:cSize lineBreakMode:UILineBreakModeWordWrap];
	result=MAX(size.height,mHeight);
	
	return result;
}

/*
 *获取特定大小的文本高度带换行形式
 */
-(CGFloat)getHeightWithText:(NSString*)text
                   fontSize:(CGFloat)fontSize
              lineBreakMode:(UILineBreakMode)lbm
                 constraint:(CGSize)cSize
                  minHeight:(CGFloat)mHeight{
    if (text==nil) {
        return mHeight;
    }
    CGFloat result=0.0f;
	CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:cSize lineBreakMode:lbm];
	result=MAX(size.height,mHeight);
	
	return result;
}

/*
 *获取特定大小的文本寬度
 */
-(CGFloat)getWidthWithText:(NSString*)text
                      font:(UIFont*)font{
    return [text sizeWithFont:font].width;
}


#pragma mark -
#pragma mark UIWebView
/*
 *改變網頁樣式    --直接讓UIWebView加載
 *備註：此處fontSize必須傳float類型  如：0.0f
 */
-(NSString*)ChangeStyleWithHtml:(NSString*)htmlTxt
                     fontFamily:(NSString*)family
                       fontSize:(CGFloat)size
                      fontColor:(NSString*)color{
    NSString *result=[NSString stringWithFormat:
                      @"<html>\n"
                      "     <head>\n"
                      "         <meta http-equiv=\"Content-Type\" content=\"text/html\"; charset=utf-8>"
                      "         <neta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,minimum-scale=1.0,maximun-scale=1.0,user-scalable=no\">"
                      "         <style type=\"text/css\">\n"
                      "             body{font-family:\"%@\"; font-size:%f; color:%@;}\n"
                      "         </style>\n"
                      "     </head>"
                      "     <body>%@</body>\n"
                      "</html>",family,size,color,htmlTxt];
    
    return result;
}

/*
 *改變字體顏色      通過UIWebView執行js
 *調用方式：[uiWebView stringByEvaluatingJavaScriptFromString:jsString];
 */
-(NSString*)ChangeFontColorWithHtml:(NSString*)color{
    NSString *jsString=[[[NSString alloc]initWithFormat:@"document.body.style.color=%@",color]autorelease];
    return jsString;
    
}

/*
 *改變字體大小      通過UIWebView執行js
 *調用方式：[uiWebView stringByEvaluatingJavaScriptFromString:jsString];
 */
-(NSString*)ChangeFontSizeWithHtml:(CGFloat)size{
    NSString *jsString=[[[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f",size] autorelease];
    return jsString;
}

//清除UIWebView的背景色
-(void)clearWebViewBackground:(UIWebView*)webView{
    if (!webView) {
        return;
    }
    
    for (UIView *item in webView.subviews) {
        if ([item isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)item setBounces:NO];
        }
    }
}


#pragma mark -
#pragma mark Network status check
/*
 *是否开启WWAN网络
 */
-(BOOL)isEnable3G{
    return ([[Reachability reachabilityForLocalWiFi]currentReachabilityStatus]!=NotReachable);
}

/*
 *是否开启wifi上网方式
 */
-(BOOL)isEnableWiFi{
    return ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable);
}

/*
 *网络是否开启
 */
-(BOOL)isEnableNetwork{
    return ([GlobalInstance isEnableWiFi]||[GlobalInstance isEnable3G]);
}

//获取公网IP
- (NSString*)getOuterNetworkIPAddress{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://automation.whatismyip.com/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    if (error||!ip||[ip isEqualToString:@""]) {
        ip=@"127.0.0.1";
    }
    
    return ip;
}

/*
 *發送郵件
 */
-(void)sendEmailTo:(NSString*)to
       withSubject:(NSString*)subject
          withBody:(NSString*)body{
    NSString *mailString=[NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",
    [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
    [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
    [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

#pragma mark - Image handle -
/*
 *生成原比例的缩略图
 */
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image
                                       size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark - UI handle -
/*
 *弹出提示消息
 */
-(void)showMessageBoxWithMessage:(NSString*)msg{
	UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alerView show];
	[alerView release];
}

/*
 *显示弹出提示信息(HUD)
 */
-(void)showHUD:(NSString*)text
       andView:(UIView*)view andHUD:(MBProgressHUD *)hud{
    [view addSubview:hud];
    hud.labelText = text;
    hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}

/*
 *隐藏弹出提示框(HUD)
 */
-(void)hideHUD:(MBProgressHUD *)hud{
    [hud hide:YES];
    [hud removeFromSuperview];
}

/*
 *状态栏显示完成提示信息
 */
-(void)showOverlayMsg:(NSString*)msg
          andDuration:(NSTimeInterval)duration
           andOverlay:(MTStatusBarOverlay*)overlay{
    [overlay postImmediateFinishMessage:msg 
                               duration:duration animated:YES];
}

/*
 *状态栏显示错误提示信息
 */
-(void)showOverlayErrorMsg:(NSString*)msg
               andDuration:(NSTimeInterval)duration
                andOverlay:(MTStatusBarOverlay*)overlay{
    [overlay postImmediateErrorMessage:msg 
                               duration:duration animated:YES];
}

/*
 *动画效果：从底部出现
 */
-(CATransition*)AnimationFromBottomToTop{
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.7];
	[animation setType: kCATransitionFade];
	[animation setSubtype: kCATransitionFromTop];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
	return animation;
}

/*
 *移除子视图
 */
-(void)removeChilds:(UIView*)view{
	NSArray *viewArr=view.subviews;
	for (int i = 0; i < [viewArr count]; i++) {
		UIView *tmpView=[viewArr objectAtIndex:i];
		[tmpView removeFromSuperview];
	}
}

#pragma mark - AV player -
/*
 *播放提示音
 */
-(void)playTipAudio:(NSURL*)audioFileUrl{
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((CFURLRef)audioFileUrl, &soundId);
    AudioServicesPlaySystemSound(soundId);
}

/**
 *判断一个字符是不是中文
 */
- (BOOL)isChineseCharacter:(int)charWithASII{
    if( charWithASII > 0x4e00 && charWithASII < 0x9fff)
        return YES;
    
    return NO;
}

@end
