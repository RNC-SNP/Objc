#import "SystemSettings.h"

@implementation SystemSettings

+(void)LocationAuth {
    [self openRoot:@"Privacy" Path:@"LOCATION"];
}

+(void)CalendarAuth {
    [self openRoot:@"Privacy" Path:@"CALENDARS"];
}

+(void)CameraAuth {
    [self openRoot:@"Privacy" Path:@"CAMERA"];
}

+(void)ContactsAuth {
    [self openRoot:@"Privacy" Path:@"CONTACTS"];
}

+(void)HealthAuth {
    [self openRoot:@"Privacy" Path:@"HEALTH"];
}

+(void)MicrophoneAuth {
    [self openRoot:@"Privacy" Path:@"MICROPHONE"];
}

+(void)PhotosAuth {
    [self openRoot:@"Privacy" Path:@"PHOTOS"];
}

+(void)ReminderAuth {
    [self openRoot:@"Privacy" Path:@"REMINDERS"];
}

+(void)Bluetooth {
    [self openRoot:@"Bluetooth" Path:nil];
}

+(void)Wifi {
    [self openRoot:@"WIFI" Path:nil];
}

+(void)Notification {
    [self openRoot:@"NOTIFICATIONS_ID" Path:nil];
}

+(void)openRoot:(NSString*)root Path:(NSString*)path {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"App-Prefs:root=%@&path=%@", root, path]];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}

@end
