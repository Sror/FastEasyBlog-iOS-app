//
//  MapKitDragAndDropViewController.h
//  MapKitDragAndDrop
//
//  Created by digdog on 11/1/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface MapKitDragAndDropViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
	IBOutlet MKMapView *mapView;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocation *currentLocation;

+ (MapKitDragAndDropViewController *)sharedInstance;

-(void) start;
-(void) stop;
-(BOOL) locationKnown;



@end

