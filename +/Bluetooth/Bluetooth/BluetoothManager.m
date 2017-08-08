//
//  BluetoothManager.m
//  Bluetooth
//
//  Created by RincLiu on 31/07/2017.
//  Copyright © 2017 RINC. All rights reserved.
//

#import "BluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

static BluetoothManager *instance;

@interface BluetoothManager()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic,strong) CBCentralManager *manager;
@property (nonatomic,strong) CBPeripheral *peripheral;
@end

@implementation BluetoothManager

+(instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc]init];
        }
    });
    return instance;
}

-(instancetype)init {
    if (self = [super init]) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

#pragma mark CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager*)central {
    switch (central.state) {
        case CBManagerStatePoweredOn: {
            NSLog(@"Bluetooth powered on..");
            [central scanForPeripheralsWithServices:nil options: nil];
            break;
        }
        case CBManagerStatePoweredOff: {
            NSLog(@"Bluetooth powered off..");
            break;
        }
        case CBManagerStateUnsupported: {
            NSLog(@"Bluetooth is not supported..");
            break;
        }
        case CBManagerStateUnauthorized: {
            NSLog(@"Bluetooth is not authenticated..");
            break;
        }
        case CBManagerStateUnknown: {
            NSLog(@"Bluetooth state unknown..");
            break;
        }
        case CBManagerStateResetting: {
            NSLog(@"Bluetooth state resetting..");
            break;
        }
    }
}

-(void)centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary<NSString*,id>*)advertisementData RSSI:(NSNumber*)RSSI {
    NSLog(@"Discover peripheral:%@", peripheral.name);
    if ([peripheral.name hasPrefix:@"MI"]) {
        _peripheral = peripheral;
        [_manager connectPeripheral:_peripheral options:nil];
    }
}

-(void)centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral {
    [peripheral discoverServices:nil];//TODO
    peripheral.delegate = self;
}

-(void)centralManager:(CBCentralManager*)central didFailToConnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error {
    NSLog(@"Fail to connect:%@", error);
}

-(void)centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error {
    NSLog(@"Disconnect:%@", error);
    [central connectPeripheral:peripheral options:nil];
}

#pragma mark CBPeripheralDelegate

-(void)peripheral:(CBPeripheral*)peripheral didDiscoverServices:(NSError*)error {
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];//TODO
    }
}

-(void)peripheral:(CBPeripheral*)peripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError*)error {
    for (CBCharacteristic *ch in service.characteristics) {
        if ([ch  isEqual: @"xxx"]) {//TODO:WRITE DATA
            NSData *data = nil;
            [_peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
        }
    }
}

-(void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error {
    if ([characteristic  isEqual: @"xxx"]) {//TODO:READ DATA
        NSLog(@"Value:%@", characteristic.value);
    }
}

@end
