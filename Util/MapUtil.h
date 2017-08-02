#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const MAP_DEFAULT;
extern NSString* const MAP_GOOGLE;
extern NSString* const MAP_BAIDU;
extern NSString* const MAP_GAODE;

@interface MapUtil : NSObject

+(NSArray<NSString*>*)supportedMaps;

+(void)openLocation:(CLLocationCoordinate2D)location Title:(NSString*)title;

+(void)navigateToLocation:(CLLocationCoordinate2D)location Map:(NSString*)map;

@end
