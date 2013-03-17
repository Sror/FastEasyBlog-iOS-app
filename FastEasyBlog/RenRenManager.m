//
//  RenRenManager.m
//  FastEasyBlog
//
//  Created by svp on 27.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenManager.h"
#import "Renren.h"
#import "RenRenNews.h"
#import "RenRenBlog.h"
#import "RenRenUserInfo.h"
#import "RenRenComment.h"
#import "RenRenSource.h"
#import "RenRenAttachment.h"
#import "Global.h"
#import "NSDate+Helper.h"
//#import "PublishController.h"
#import "ROPublishPhotoRequestParam.h"
#import "Followed.h"

//私有成员
@interface RenRenManager()

//装载新鲜事对象
+ (RenRenNews*)loadRenRenNewsObjWithMutableDictionary:(NSMutableDictionary *)item;

//裝載日誌對象
+ (RenRenBlog*)loadRenRenBlogObjWithMutableDictionary:(NSDictionary *)item;

//装载评论对象
+ (RenRenComment*)loadRenRenCommentObjWithMutableDictionary:(NSMutableDictionary *)item;

//装载新鲜事评论对象
+ (NSMutableDictionary*)loadRenRenStatusCommentObjForJSON:(NSMutableDictionary *)item;

//装载日志评论对象
+ (RenRenComment*)loadRenRenBlogCommentObjWithMutableDictionary:(NSMutableDictionary *)item;

//装载日志评论对象(for json)
+ (RenRenComment*)loadRenRenBlogCommentObjForJSON:(NSMutableDictionary *)item;

//装载照片评论对象
+ (RenRenComment*)loadRenRenPhotoCommentObjWithMutableDictionary:(NSMutableDictionary *)item;

//装载照片评论对象(for json)
+ (RenRenComment*)loadRenRenPhotoCommentObjForJSON:(NSMutableDictionary *)item;

//装载人人用户对象
+ (RenRenUserInfo*)loadRenRenUserInfoObjWithMutableDictionary:(NSDictionary *)item;

//装载人人新鲜事中的（媒体附件）
+ (NSMutableArray*)loadRenRenNewsAttachmentObjsWithMutableArray:(NSMutableArray *)item;

//装载人人好友对象
+ (Followed*)loadRenRenFriendObjWithMutableDictionary:(NSMutableDictionary *)item;

@end



@implementation RenRenManager

-(void)dealloc{
	[super dealloc];
}

/*
 *验证是否已绑定
 */
+ (BOOL)isBoundToApplication{
	return [[Renren sharedRenren]isSessionValid];
}

/*
 *登出
 */
+ (void)logOut:(id<RenrenDelegate>)delegate{
	[[Renren sharedRenren]logout:delegate];
}

/*
 *解析新鲜事到对象
 */
+ (NSMutableArray*)resolveNewsToObject:(ROResponse *)response{
	NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
	if ([response.rootObject isKindOfClass:[NSArray class]]) {
		id infoArr=(NSArray*)response.rootObject;
		for (id item in infoArr) {
			if ([item isKindOfClass:[NSMutableDictionary class]]) {
				NSMutableDictionary *news=(NSMutableDictionary*)item;
				[result addObject:[RenRenManager loadRenRenNewsObjWithMutableDictionary:news]];
				
			}
		}
	}else {

	}
    
	return result;
}

/*
 *装载新鲜事对象
 */
+ (RenRenNews*)loadRenRenNewsObjWithMutableDictionary:(NSMutableDictionary *)item{
    RenRenNews *result=[[[RenRenNews alloc]init]autorelease];
    
    result.post_id=[item objectForKey:@"post_id"];
    result.source_id=[NSString stringWithFormat:@"%f",[[item objectForKey:@"source_id"] doubleValue]];
    NSInteger index=[result.source_id rangeOfString:@"."].location;
    result.source_id=[result.source_id substringToIndex:index];
	result.feed_type=[NSString stringWithFormat:@"%d",[(NSDecimalNumber*)[item objectForKey:@"feed_type"] intValue]];
    result.update_time=[item objectForKey:@"update_time"];
	result.actor_id=[NSString stringWithFormat:@"%d",[(NSDecimalNumber*)[item objectForKey:@"actor_id"] intValue]];
    result.actor_type=[item objectForKey:@"actor_type"];
	result.name=[item objectForKey:@"name"];
	result.headurl=[item objectForKey:@"headurl"];
	result.prefix=[item objectForKey:@"prefix"];
	result.message=[item objectForKey:@"message"];
	result.title=[item objectForKey:@"title"];
	result.href=[item objectForKey:@"href"];
	result.description=[item objectForKey:@"description"];
    if ([item objectForKey:@"attachment"]) {
        result.attachment=[RenRenManager loadRenRenNewsAttachmentObjsWithMutableArray:[item objectForKey:@"attachment"]];
    }
	
	result.comments=[item objectForKey:@"comments"];
	result.likes=[item objectForKey:@"likes"];
    if ([item objectForKey:@"source"]) {
        RenRenSource *innerSource=[[[RenRenSource alloc]init]autorelease];
        innerSource.text=[[item objectForKey:@"source"] objectForKey:@"text"];
        innerSource.href=[[item objectForKey:@"source"] objectForKey:@"href"];
        result.source=innerSource;
    }
	result.place=[item objectForKey:@"place"];
    
    return result;
}

/*
 *装载人人新鲜事中的（媒体附件）
 */
+ (NSMutableArray*)loadRenRenNewsAttachmentObjsWithMutableArray:(NSMutableArray *)attachmentItems{
    NSMutableArray *accachmentArr=[[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary *item in attachmentItems) {
        RenRenAttachment *attachment=[[[RenRenAttachment alloc]init]autorelease];
        attachment.href=[item objectForKey:@"href"];
        attachment.media_type=[item objectForKey:@"media_type"];
        attachment.media_id=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"media_id"] longLongValue]];
        attachment.src=[item objectForKey:@"src"];
        attachment.owner_name=[item objectForKey:@"owner_name"];
        attachment.owner_id=[NSString stringWithFormat:@"%d",[(NSDecimalNumber*)[item objectForKey:@"owner_id"] intValue]];
        attachment.content=[item objectForKey:@"content"];
        attachment.raw_src=[item objectForKey:@"raw_src"];
        
        [accachmentArr addObject:attachment];
    }
    return accachmentArr;
}

/*
 *解析日誌到對象
 */
+ (RenRenBlog*)resolveNewsDetailToObject:(ROResponse *)response{
    RenRenBlog *result=[[[RenRenBlog alloc]init]autorelease];
	if ([response.rootObject isKindOfClass:[NSArray class]]) {
        
	}else {
        ROResponseItem *responseObj=(ROResponseItem*)response.rootObject;
        result=[RenRenManager loadRenRenBlogObjWithMutableDictionary:(NSDictionary*)responseObj];
	}
    
	return result;
}
                
/*
 *裝載日誌對象
 */
+ (RenRenBlog*)loadRenRenBlogObjWithMutableDictionary:(NSDictionary *)item{
    RenRenBlog *blog=[[[RenRenBlog alloc]init]autorelease];
    blog.bid=[NSString stringWithFormat:@"%d",[(NSDecimalNumber*)[item objectForKey:@"id"] intValue]];
    blog.uid=[NSString stringWithFormat:@"%d",[(NSDecimalNumber*)[item objectForKey:@"uid"] intValue]];
    blog.name=[item objectForKey:@"name"];
    blog.headurl=[item objectForKey:@"headurl"];
    blog.time=[item objectForKey:@"time"];
    blog.title=[item objectForKey:@"title"];
    blog.content=[item objectForKey:@"content"];
    blog.view_count=[NSString stringWithFormat:@"%d",[(NSDecimalNumber*)[item objectForKey:@"view_count"] intValue]];
    blog.comment_count=[NSString stringWithFormat:@"%d",[(NSDecimalNumber*)[item objectForKey:@"comment_count"] intValue]];
    blog.share_count=[NSString stringWithFormat:@"%d",[(NSDecimalNumber*)[item objectForKey:@"share_count"] intValue]];
    blog.visable=[item objectForKey:@"visable"];
    blog.comments=[item objectForKey:@"comments"];
    
    return blog;
}

/*
 *解析评论
 */
+ (NSMutableArray*)resolveComments:(ROResponse*)response{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
		id infoArr=(NSArray*)response.rootObject;
		for (id item in infoArr) {
			if ([item isKindOfClass:[NSMutableDictionary class]]) {
				NSMutableDictionary *comment=(NSMutableDictionary*)item;
				[result addObject:[RenRenManager loadRenRenCommentObjWithMutableDictionary:comment]];
			}
		}
        return result;
	}else{
        return nil;
    }
}

/*
 *解析评论(for json)
 */
+ (NSMutableArray*)resolveStatusCommentsForJSON:(ROResponse*)response{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
		id infoArr=(NSArray*)response.rootObject;
		for (id item in infoArr) {
			if ([item isKindOfClass:[NSMutableDictionary class]]) {
				NSMutableDictionary *comment=(NSMutableDictionary*)item;
				[result addObject:[RenRenManager loadRenRenStatusCommentObjForJSON:comment]];
			}
		}
        return result;
	}else{
        return nil;
    }
}

/*
 *装载评论对象(for json)
 */
+ (NSMutableDictionary*)loadRenRenStatusCommentObjForJSON:(NSMutableDictionary *)item{
    NSMutableDictionary *itemDic=[[[NSMutableDictionary alloc]init]autorelease];
    
    [itemDic setObject:[NSString stringWithFormat:@"%llu",[[item objectForKey:@"uid"]longLongValue]] forKey:@"uniqueId"];
    [itemDic setObject:[item objectForKey:@"name"] forKey:@"name"];
    [itemDic setObject:[item objectForKey:@"tinyurl"] forKey:@"headImgUrl"];
    [itemDic setObject:[item objectForKey:@"text"] forKey:@"text"];
    [itemDic setObject:[item objectForKey:@"time"] forKey:@"pubDate"];
    [itemDic setObject:[NSString stringWithFormat:@"%llu",[[item objectForKey:@"comment_id"]longLongValue]] forKey:@"comment_id"];
    
    return itemDic;
}

/*
 *装载评论对象
 */
+ (RenRenComment*)loadRenRenCommentObjWithMutableDictionary:(NSMutableDictionary *)item{
    RenRenComment *comment=[[[RenRenComment alloc]init]autorelease];
    comment.uid=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"uid"]longLongValue]];
    comment.name=[item objectForKey:@"name"];
    comment.headurl=[item objectForKey:@"tinyurl"];
    comment.time=[item objectForKey:@"time"];
    comment.comment_id=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"comment_id"]longLongValue]];
    comment.text=[item objectForKey:@"text"];
    
    return comment;
}

/*
 *解析日誌评论
 */
+ (NSMutableArray*)resolveBlogComments:(ROResponse*)response{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
		id infoArr=(NSArray*)response.rootObject;
		for (id item in infoArr) {
			if ([item isKindOfClass:[NSMutableDictionary class]]) {
				NSMutableDictionary *comment=(NSMutableDictionary*)item;
				[result addObject:[RenRenManager loadRenRenBlogCommentObjWithMutableDictionary:comment]];
			}
		}
        return result;
	}else{
        return nil;
    }
}

/*
 *解析日誌评论(for json)
 */
+ (NSMutableArray*)resolveBlogCommentsForJSON:(ROResponse*)response{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
		id infoArr=(NSArray*)response.rootObject;
		for (id item in infoArr) {
			if ([item isKindOfClass:[NSMutableDictionary class]]) {
				NSMutableDictionary *comment=(NSMutableDictionary*)item;
				[result addObject:[RenRenManager loadRenRenBlogCommentObjForJSON:comment]];
			}
		}
        return result;
	}else{
        return nil;
    }
}

/*
 *装载日志评论对象
 */
+ (RenRenComment*)loadRenRenBlogCommentObjWithMutableDictionary:(NSMutableDictionary *)item{
    RenRenComment *comment=[[[RenRenComment alloc]init]autorelease];
    comment.uid=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"uid"]longLongValue]];
    comment.name=[item objectForKey:@"name"];
    comment.headurl=[item objectForKey:@"headurl"];
    comment.time=[item objectForKey:@"time"];
    comment.comment_id=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"comment_id"]longLongValue]];
    comment.text=[item objectForKey:@"content"];
    
    return comment;
}

/*
 *装载日志评论对象
 */
+ (NSMutableDictionary*)loadRenRenBlogCommentObjForJSON:(NSMutableDictionary *)item{
    NSMutableDictionary *itemDic=[[[NSMutableDictionary alloc]init]autorelease];
    [itemDic setObject:[NSString stringWithFormat:@"%llu",[[item objectForKey:@"uid"]longLongValue]] forKey:@"uniqueId"];
    [itemDic setObject:[item objectForKey:@"name"] forKey:@"name"];
    [itemDic setObject:[item objectForKey:@"headurl"] forKey:@"headImgUrl"];
    [itemDic setObject:[item objectForKey:@"content"] forKey:@"text"];
    [itemDic setObject:[item objectForKey:@"time"] forKey:@"pubDate"];
    [itemDic setObject:[NSString stringWithFormat:@"%llu",[[item objectForKey:@"comment_id"]longLongValue]] forKey:@"comment_id"];

    return itemDic;
}

/*
 *解析照片评论
 */
+ (NSMutableArray*)resolvePhotoComments:(ROResponse*)response{
	NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
		id infoArr=(NSArray*)response.rootObject;
		for (id item in infoArr) {
			if ([item isKindOfClass:[NSMutableDictionary class]]) {
				NSMutableDictionary *comment=(NSMutableDictionary*)item;
				[result addObject:[RenRenManager loadRenRenPhotoCommentObjWithMutableDictionary:comment]];
			}
		}
        return result;
	}else{
        return nil;
    }
}

/*
 *解析照片评论(for json)
 */
+ (NSMutableArray*)resolvePhotoCommentsForJSON:(ROResponse*)response{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
		id infoArr=(NSArray*)response.rootObject;
		for (id item in infoArr) {
			if ([item isKindOfClass:[NSMutableDictionary class]]) {
				NSMutableDictionary *comment=(NSMutableDictionary*)item;
				[result addObject:[RenRenManager loadRenRenPhotoCommentObjForJSON:comment]];
			}
		}
        return result;
	}else{
        return nil;
    }
}

/*
 *装载照片评论对象(for json)
 */
+ (NSMutableDictionary*)loadRenRenPhotoCommentObjForJSON:(NSMutableDictionary *)item{
	NSMutableDictionary *itemDic=[[[NSMutableDictionary alloc]init]autorelease];
    
    [itemDic setObject:[NSString stringWithFormat:@"%llu",[[item objectForKey:@"uid"]longLongValue]] forKey:@"uniqueId"];
    [itemDic setObject:[item objectForKey:@"name"] forKey:@"name"];
    [itemDic setObject:[item objectForKey:@"headurl"] forKey:@"headImgUrl"];
    [itemDic setObject:[item objectForKey:@"text"] forKey:@"text"];
    [itemDic setObject:[item objectForKey:@"time"] forKey:@"pubDate"];
    [itemDic setObject:[NSString stringWithFormat:@"%llu",[[item objectForKey:@"comment_id"]longLongValue]] forKey:@"comment_id"];
    
    return itemDic;
}

/*
 *装载照片评论对象
 */
+ (RenRenComment*)loadRenRenPhotoCommentObjWithMutableDictionary:(NSMutableDictionary *)item{
	RenRenComment *comment=[[[RenRenComment alloc]init]autorelease];
    comment.uid=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"uid"]longLongValue]];
    comment.name=[item objectForKey:@"name"];
    comment.headurl=[item objectForKey:@"headurl"];
    comment.time=[item objectForKey:@"time"];
    comment.comment_id=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"comment_id"]longLongValue]];
    comment.text=[item objectForKey:@"text"];
    
    return comment;
}


/*
 *獲取授權列表
 */
+ (NSArray*)getAuthorizedPermissionList{
    NSArray *permissionArray=[[[NSArray alloc]initWithObjects:
															@"publish_feed",
															@"status_update",
															@"read_user_feed",
															@"read_user_blog",
															@"read_user_status",
															@"read_user_comment",
                                                            @"read_user_share",
                                                            @"read_user_photo",
                                                            @"publish_comment",
                                                            @"photo_upload",
															nil]autorelease];
    return permissionArray;
}

//解析人人日期
+ (NSString*)resolveRenRenDate:(NSString*)sourceDateStr{
    //源格式
	NSDateFormatter *sourceFormatter=[[[NSDateFormatter alloc]init]autorelease];
	[sourceFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tmpDate=[sourceFormatter dateFromString:sourceDateStr];
    
    return [tmpDate countDownString];
}

/*
 *解析人人用户对象
 */
+ (RenRenUserInfo*)resolveRenRenUserInfoToObject:(ROResponse *)response{
	RenRenUserInfo *result=[[[RenRenUserInfo alloc]init]autorelease];
	if ([response.rootObject isKindOfClass:[NSArray class]]) {
        id infoArr=(NSArray*)response.rootObject;
			if ([[infoArr objectAtIndex:0] isKindOfClass:[NSMutableDictionary class]]) {
				NSDictionary *currentUserData=(NSDictionary*)[infoArr objectAtIndex:0];
				result=[RenRenManager loadRenRenUserInfoObjWithMutableDictionary:currentUserData];
			}
	}else {
        
	}
    
	return result;
}

/*
 *装载人人用户对象
 */
+ (RenRenUserInfo*)loadRenRenUserInfoObjWithMutableDictionary:(NSDictionary *)item{
	RenRenUserInfo *result=[[[RenRenUserInfo alloc]init]autorelease];
	result.uniquedId=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"uid"]longLongValue]];
	result.name=[item objectForKey:@"name"];
	result.tinyurl=[item objectForKey:@"tinyurl"];
	result.headurl=[item objectForKey:@"headurl"];
	result.zidou=[[item objectForKey:@"zidou"]intValue];
	result.star=[[item objectForKey:@"star"]intValue];
	return result;
}

/*
 *解析人人好友
 */
+ (NSMutableArray*)resolveRenRenFriends:(ROResponse *)response{
    NSMutableArray *followedArr=[[[NSMutableArray alloc]init]autorelease];
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
        NSArray *infoArr=(NSArray*)response.rootObject;
        for (NSMutableDictionary *item in infoArr) {
            [followedArr addObject:[RenRenManager loadRenRenFriendObjWithMutableDictionary:item]];
        }
        
        return followedArr;
    }
    
    return nil;
}

/*
 *装载人人好友对象
 */
+ (Followed*)loadRenRenFriendObjWithMutableDictionary:(NSMutableDictionary *)item{
    Followed *followed=[[[Followed alloc]init]autorelease];
    followed.userId=[NSString stringWithFormat:@"%llu",[[item objectForKey:@"id"]longLongValue]];
    followed.nick=[item objectForKey:@"name"];
    followed.headImgUrl=[item objectForKey:@"tinyurl"];
    
    return followed;
}


@end
