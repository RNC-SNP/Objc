#import "MapView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIUtil.h"

@interface Annotation()<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title, *subTitle;

-(NSString*)Id;

@end

@implementation Annotation

+(instancetype)annotationWithLatitude:(double)latitude Longitude:(double)longitude Title:(NSString*)title SubTitle:(NSString*)subTitle {
    Annotation *annotation = [Annotation new];
    annotation.title = title;
    annotation.subTitle = subTitle;
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return annotation;
}

-(NSString*)Id {
    return [NSString stringWithFormat:@"%f_%f_%@_%@", _coordinate.latitude, _coordinate.longitude, _title, _subTitle];
}

@end

@interface MapView()<MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) MKUserLocation* userLocation;
@property (nonatomic,strong) NSMutableArray<Annotation*>* annotations;
@property (nonatomic,strong) NSMutableDictionary *routesDict;

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
        _routesDict = [NSMutableDictionary new];
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
        NSString *ID = [annotation Id];
        if ([_routesDict objectForKey:ID] != nil) {
            [_routesDict removeObjectForKey:ID];
        }
    }
}

-(void)moveToUserLocation {
    if (_userLocation != nil) {
        CLLocationCoordinate2D loc = _userLocation.location.coordinate;
        [self setCenterLatitude:loc.latitude Longitude:loc.longitude RegionSpan:0.001];
    }
}

-(void)takeSnapshot:(void(^)(UIImage*))handler {
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    options.region = _mapView.region;
    options.size = _mapView.frame.size;
    options.scale = [[UIScreen mainScreen]scale];
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc]initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        handler(error ? nil : snapshot.image);
    }];
}

-(void)routesAction:(UIButton*)sender {
    Annotation *annotation = _annotations[sender.tag];
    NSString *ID = [annotation Id];
    if ([_routesDict objectForKey:ID] == nil) {
        MKDirectionsRequest *request = [MKDirectionsRequest new];
        request.source = [self mapItemFromLocation:_userLocation.location.coordinate];
        request.destination = [self mapItemFromLocation:annotation.coordinate];
        MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (!error) {
                [response.routes enumerateObjectsUsingBlock:^(MKRoute *obj, NSUInteger idx, BOOL *stop) {
                    [obj.steps enumerateObjectsUsingBlock:^(MKRouteStep *obj, NSUInteger idx, BOOL *stop) {
                        NSLog(@"%@", obj.instructions);
                    }];
                }];
                NSMutableArray *overlays = [NSMutableArray new];
                for (MKRoute *route in [response routes]) {
                    [_mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
                    [overlays addObject:[route polyline]];
                }
                [_routesDict setObject:overlays forKey:ID];
                SetTitleNormal(sender, @"隐藏路线");
            }
        }];
    } else {
        [_mapView removeOverlays:[_routesDict objectForKey:ID]];
        [_routesDict removeObjectForKey:ID];
        SetTitleNormal(sender, @"显示路线");
    }
}

-(MKMapItem*)mapItemFromLocation:(CLLocationCoordinate2D)location {
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:location addressDictionary:nil];
    return [[MKMapItem alloc]initWithPlacemark:placemark];
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
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        NSString *annotationId = [annotation Id];
        MKAnnotationView *annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:annotationId];
        }
        
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 45)];
        btn.titleLabel.numberOfLines = 2;
        SetTitleNormal(btn, @"显示路线");
        SetTitleColorNormal(btn, self.tintColor);
        SetClickCallback(btn, @selector(routesAction:));
        SetTextSize(btn.titleLabel, 15);
        [btn setTag:[_annotations indexOfObject:annotation]];
        annotationView.rightCalloutAccessoryView = btn;
        
        UILabel *label = [UIUtil LabelFromFrame:CGRectZero Color:[UIColor grayColor] Size:10];
        label.text = annotation.subTitle;
        annotationView.detailCalloutAccessoryView = label;
        
        return annotationView;
    }
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view {
    
}

-(void)mapView:(MKMapView*)mapView didDeselectAnnotationView:(MKAnnotationView*)view {
    
}

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *lineRenderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
        lineRenderer.lineWidth = 5;
        lineRenderer.strokeColor = [UIColor yellowColor];
        return lineRenderer;
    }
    return nil;
}

@end
