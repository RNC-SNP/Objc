#import <Foundation/Foundation.h>

@interface SystemSettings : NSObject

+(void)LocationAuth;

+(void)CalendarAuth;

+(void)CameraAuth;

+(void)ContactsAuth;

+(void)HealthAuth;

+(void)MicrophoneAuth;

+(void)PhotosAuth;

+(void)ReminderAuth;

+(void)Bluetooth;

+(void)Wifi;

+(void)Notification;

@end
