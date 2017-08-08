#import "MapView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapUtil.h"
#import "UIAlertController+Window.h"
#import "UIUtil.h"

@interface Annotation()<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title, *subTitle;

@end

@implementation Annotation

+(instancetype)annotationWithLatitude:(double)latitude Longitude:(double)longitude Title:(NSString*)title SubTitle:(NSString*)subTitle {
    Annotation *annotation = [Annotation new];
    annotation.title = title;
    annotation.subTitle = subTitle;
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return annotation;
}

@end

@interface MapView()<MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) MKUserLocation* userLocation;
@property (nonatomic,copy) NSMutableArray<Annotation*>* annotations;

@end

@implementation MapView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _mapView = [[MKMapView alloc]initWithFrame:frame];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.showsScale = NO;
        _mapView.showsCompass = NO;
        _mapView.showsTraffic = NO;
        _mapView.showsBuildings = YES;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _mapView.delegate = self;
        [self addSubview:_mapView];
        _annotations = [NSMutableArray new];
    }
    return self;
}

-(void)setCenterLatitude:(double)latitude Longitude:(double)longitude RegionSpan:(double)regionSpan {
    CLLocationCoordinate2D center =  CLLocationCoordinate2DMake(latitude, longitude);
    [_mapView setCenterCoordinate:center animated:YES];
    MKCoordinateSpan span = MKCoordinateSpanMake(regionSpan, regionSpan);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [_mapView setRegion:region animated:YES];
}

-(void)addAnnotation:(Annotation*)annotation AutoSelect:(BOOL)autoSelect {
    if (![_annotations containsObject:annotation]) {
        [_annotations addObject:annotation];
        [_mapView addAnnotation:annotation];
        if (autoSelect) {
            [_mapView selectAnnotation:annotation animated:YES];
        }
    }
}

-(void)removeAnnotation:(Annotation*)annotation {
    if ([_annotations containsObject:annotation]) {
        [_mapView removeAnnotation:annotation];
        [_annotations removeObject:annotation];
    }
}

-(void)naviAction:(UIButton*)sender {
    Annotation *annotation = _annotations[sender.tag];
    NSArray *maps = [MapUtil supportedMaps];
    if (maps.count > 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择地图开始导航" preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString* map in maps) {
            [alertController addAction:[UIAlertAction actionWithTitle:[self MapName:map] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [MapUtil navigateToLocation:annotation.coordinate Title:annotation.title Map:map];
            }]];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController show:YES];
    } else {
        [MapUtil navigateToLocation:annotation.coordinate Title:annotation.title Map:MAP_DEFAULT];
    }
}

-(NSString*)MapName:(NSString*)map {
    if ([map isEqualToString:MAP_DEFAULT]) {
        return @"系统地图";
    } else if ([map isEqualToString:MAP_TENCENT]) {
        return @"腾讯地图";
    } else if ([map isEqualToString:MAP_GOOGLE]) {
        return @"谷歌地图";
    } else if ([map isEqualToString:MAP_GAODE]) {
        return @"高德地图";
    } else if ([map isEqualToString:MAP_BAIDU]) {
        return @"百度地图";
    } else {
        return @"";
    }
}

#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView*)mapView regionWillChangeAnimated:(BOOL)animated {
    
}

-(void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

-(void)mapViewWillStartLoadingMap:(MKMapView*)mapView {
    
}

-(void)mapViewDidFinishLoadingMap:(MKMapView*)mapView {
    
}

-(void)mapViewDidFailLoadingMap:(MKMapView*)mapView withError:(NSError*)error {
    
}

-(void)mapView:(MKMapView*)mapView didUpdateUserLocation:(MKUserLocation*)userLocation {
    _userLocation = userLocation;
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(Annotation*)annotation {
    NSString *annotationID = [NSString stringWithFormat:@"%f_%f_%@_%@", annotation.coordinate.latitude, annotation.coordinate.longitude, annotation.title, annotation.subTitle];
    MKAnnotationView *annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:annotationID];
    }
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    annotationView.draggable = NO;
    
    CLLocationCoordinate2D currentLoc = annotation.coordinate;
    CLLocationCoordinate2D userLoc = _userLocation.location.coordinate;
    if (currentLoc.latitude != userLoc.latitude && currentLoc.longitude != userLoc.longitude) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 31, 30)];
        SetTitleNormal(btn, @"导航");
        SetTitleColorNormal(btn, self.tintColor);
        SetClickCallback(btn, @selector(naviAction:));
        SetTextSize(btn.titleLabel, 15);
        [btn setTag:[_annotations indexOfObject:annotation]];
        annotationView.rightCalloutAccessoryView = btn;
        
        UILabel *label = [UIUtil LabelFromFrame:CGRectZero Color:[UIColor grayColor] Size:10];
        label.text = annotation.subTitle;
        annotationView.detailCalloutAccessoryView = label;
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view {
    
}

-(void)mapView:(MKMapView*)mapView didDeselectAnnotationView:(MKAnnotationView*)view {
    
}

@end
