#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const MAP_DEFAULT;
extern NSString* const MAP_TENCENT;
extern NSString* const MAP_GOOGLE;
extern NSString* const MAP_GAODE;
extern NSString* const MAP_BAIDU;

@interface MapUtil : NSObject

+(NSArray<NSString*>*)supportedMaps;

+(void)openLocation:(CLLocationCoordinate2D)location Title:(NSString*)title;

+(void)navigateToLocation:(CLLocationCoordinate2D)location Title:(NSString*)title Map:(NSString*)map;

@end
