//	人人业务逻辑实现类
//  RenRenManager.h
//  FastEasyBlog
//
//  Created by svp on 27.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RenRenBlog;
@class RenRenUserInfo;
@class PublishController;
@class Followed;

@interface RenRenManager : NSObject {
}


//验证是否已绑定
+ (BOOL)isBoundToApplication;

//登出
+ (void)logOut:(id<RenrenDelegate>)delegate;

//解析新鲜事到对象
+ (NSMutableArray*)resolveNewsToObject:(ROResponse *)response;

//解析日誌到對象
+ (RenRenBlog*)resolveNewsDetailToObject:(ROResponse *)response;

//解析狀態评论
+ (NSMutableArray*)resolveComments:(ROResponse*)response;

//解析评论(for json)
+ (NSMutableArray*)resolveStatusCommentsForJSON:(ROResponse*)response;

//解析日誌评论
+ (NSMutableArray*)resolveBlogComments:(ROResponse*)response;

//解析日誌评论(for json)
+ (NSMutableArray*)resolveBlogCommentsForJSON:(ROResponse*)response;

//解析照片评论
+ (NSMutableArray*)resolvePhotoComments:(ROResponse*)response;

//解析照片评论(for json)
+ (NSMutableArray*)resolvePhotoCommentsForJSON:(ROResponse*)response;

//獲取授權列表
+ (NSArray*)getAuthorizedPermissionList;

//解析人人日期
+ (NSString*)resolveRenRenDate:(NSString*)sourceDateStr;

//解析人人用户对象
+ (RenRenUserInfo*)resolveRenRenUserInfoToObject:(ROResponse *)response;

//解析人人好友
+ (NSMutableArray*)resolveRenRenFriends:(ROResponse *)response;

@end
