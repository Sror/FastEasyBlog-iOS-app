//
//  IconDownloader.m
//  RenRenTest
//
//  Created by yanghua on 10.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "IconDownloader.h"

Class object_getClass(id object);

@implementation IconDownloader

-(void)dealloc{
	[_appIcon release],_appIcon=nil;
	[_imgUrl release],_imgUrl=nil;
	[_indexPathInTableView release],_indexPathInTableView=nil;
    [_imgKey release],_imgKey=nil;
	[_activeDownload release],_activeDownload=nil;
	[_imageConnection cancel];
	[_imageConnection release],_imageConnection=nil;
	
	[super dealloc];
}

-(void)startDownload{
    self.activeDownload=[NSMutableData data];
    //异步加载图片
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:
                           [NSURLRequest requestWithURL:[NSURL URLWithString:self.imgUrl]] delegate:self];
    
    self.imageConnection=conn;
    [conn release];
}

-(void)cancelDownload{
	[self.imageConnection cancel];
	self.imageConnection=nil;
	self.activeDownload=nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
-(void)connection:(NSURLConnection *)connection
   didReceiveData:(NSData *)data{
	[self.activeDownload appendData:data];
}

-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error{
	self.activeDownload=nil;
	self.imageConnection=nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    UIImage *image=[[UIImage alloc]initWithData:self.activeDownload];
    
    if ((image.size.width!=self.imgWidth || image.size.height!=self.imgHeight)&&
        (self.imgWidth+self.imgHeight!=0)) {
        CGSize itemSize=CGSizeMake(self.imgWidth, self.imgHeight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect=CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        self.appIcon=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else {
        self.appIcon=image;
    }
    
    self.activeDownload=nil;
    [image release];
    
    self.imageConnection=nil;
    
    //解决：下载没有结束，controller已被释放带来的代理方法调用失败的问题
    //added by:yh       Date:2012-09-08
    Class _currentClass=object_getClass(self.delegate);
    if (_currentClass==_originalClass) {
        if (self.imgKey&&(![self.imgKey isEqualToString:@""])) {
            [self.delegate appImageDidLoad:self.indexPathInTableView forKey:self.imgKey];
        }else{
            [self.delegate appImageDidLoad:self.indexPathInTableView];
        }
    }
}

#pragma mark -override setter-
-(void)setDelegate:(id<IconDownloaderDelegate>)delegate_{
    if (_delegate!=delegate_) {
        _delegate=delegate_;
        _originalClass=object_getClass(_delegate);
    }
}



@end
