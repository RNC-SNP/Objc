#import "MapUtil.h"
#import <MapKit/MapKit.h>

static NSMutableArray<NSString*>* supportedMaps;

@implementation MapUtil

NSString* const MAP_DEFAULT = @"MAP_DEFAULT";
NSString* const MAP_TENCENT = @"MAP_TENCENT";
NSString* const MAP_GOOGLE = @"MAP_GOOGLE";
NSString* const MAP_GAODE = @"MAP_GAODE";
NSString* const MAP_BAIDU = @"MAP_BAIDU";

NSString* const SCHEME_MAP_TENCENT = @"qqmap://";
NSString* const SCHEME_MAP_GOOGLE = @"comgooglemaps://";
NSString* const SCHEME_MAP_GAODE = @"iosamap://";
NSString* const SCHEME_MAP_BAIDU = @"baidumap://";

+(NSArray<NSString*>*)supportedMaps {
    if (supportedMaps == nil) {
        supportedMaps = [NSMutableArray new];
        [supportedMaps addObject:MAP_DEFAULT];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAP_TENCENT]]) {
            [supportedMaps addObject:MAP_TENCENT];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAP_GOOGLE]]) {
            [supportedMaps addObject:MAP_GOOGLE];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAP_GAODE]]) {
            [supportedMaps addObject:MAP_GAODE];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAP_BAIDU]]) {
            [supportedMaps addObject:MAP_BAIDU];
        }
    }
    return supportedMaps;
}

+(void)openLocation:(CLLocationCoordinate2D)location Title:(NSString*)title {
    MKMapItem *mapItem = [self MapItemFromLocation:location];
    [mapItem setName:title];
    [mapItem openInMapsWithLaunchOptions:[self defaultLaunchOptions]];
}

+(void)navigateToLocation:(CLLocationCoordinate2D)location Title:(NSString*)title Map:(NSString*)map {
    if ([[self supportedMaps]containsObject:map]) {
        if ([MAP_DEFAULT isEqualToString:map]) {
            [MKMapItem openMapsWithItems:@[[MKMapItem mapItemForCurrentLocation], [self MapItemFromLocation:location]]
                           launchOptions:[self defaultLaunchOptions]];
        } else if ([MAP_TENCENT isEqualToString:map]) {
            NSString *url = @"%@map/routeplan?from=我的位置&type=walk&tocoord=%f,%f&to=%@&coord_type=1&policy=0";
            [self openMapUrl:[NSString stringWithFormat:url, SCHEME_MAP_TENCENT, location.latitude, location.longitude, title]];
        } else if ([MAP_GOOGLE isEqualToString:map]){
            NSString *url = @"%@?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving";
            [self openMapUrl:[NSString stringWithFormat:url, SCHEME_MAP_GOOGLE, @"RINC", @"rinc://", location.latitude, location.longitude]];
        } else if ([MAP_GAODE isEqualToString:map]){
            NSString *url = @"%@navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2";
            [self openMapUrl:[NSString stringWithFormat:url, SCHEME_MAP_GAODE, @"RINC", @"rinc://", location.latitude, location.longitude]];
        } else if ([MAP_BAIDU isEqualToString:map]){
            NSString *url = @"%@map/direction?origin={{我的位置}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02";
            [self openMapUrl:[NSString stringWithFormat:url, SCHEME_MAP_BAIDU, location.latitude, location.longitude]];
        }
    }
}

+(void)openMapUrl:(NSString*)url {
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+(MKMapItem*)MapItemFromLocation:(CLLocationCoordinate2D)location {
    return [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil]];
}

+(NSDictionary<NSString*,id>*)defaultLaunchOptions {
    return @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
             MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
}

@end
