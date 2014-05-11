//
//  RLViewController.m
//  FileOperation
//
//  Created by RincLiu on 5/8/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self readDirectories];
    [self createDirectory];
    [self writeArrayToFile];
    [self readArrayFromFile];
    [self writeDataToFile];
    [self readSubPathsOfDir];
    [self removeItemAtPath];
    [self changeCurrentDirToWrite];
    [self writeWithNSMutableData];
    [self readWithNSData];
    
    NSMutableDictionary *dic = [self readPropertyList];
    NSLog(@"data in plist:%@", dic);
    [self writePropertyList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search dir:

-(NSString*)searchDir:(NSSearchPathDirectory)dir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(dir, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(void)readDirectories
{
    NSLog(@"home: %@\n", NSHomeDirectory());
    NSLog(@"tmp: %@\n", NSTemporaryDirectory());
    
    NSLog(@"document: %@\n", [self searchDir:NSDocumentDirectory]);
    NSLog(@"caches: %@\n", [self searchDir:NSCachesDirectory]);
    NSLog(@"library: %@\n", [self searchDir:NSLibraryDirectory]);
}

#pragma mark - Use NSString/NSMutableString/NSArray/NSMutableArray/NSDictionary/NSMutableDictionary:

-(void)writeArrayToFile
{
    NSArray* array = [[NSArray alloc]initWithObjects:@"Rinc Liu", @"i@RincLiu.com", @"http://RincLiu.com", nil];
    NSString *fileName = @"array.txt";
    NSString* path = [self searchDir:NSDocumentDirectory];
    NSString *filePath = [[path stringByAppendingPathComponent:@"myDir"] stringByAppendingPathComponent:fileName];
    
    // With NSString/NSMutableString/NSArray/NSMutableArray/NSDictionary/NSMutableDictionary's
    // 'writeToFile' method, you can write data to a file directly.
    // And the data is saved as XML fromat.
    [array writeToFile:filePath atomically:YES];
}

-(void)readArrayFromFile
{
    NSString *fileName = @"array.txt";
    NSString* path = [self searchDir:NSDocumentDirectory];
    NSString *filePath = [[path stringByAppendingPathComponent:@"myDir"] stringByAppendingPathComponent:fileName];
    
    // With NSString/NSMutableString/NSArray/NSMutableArray/NSDictionary/NSMutableDictionary's
    // 'initWithContentsOfFile' method, you can read data from a file directly.
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    NSLog(@"Data in file %@: %@", filePath, array);
}

#pragma mark - Use NSData/NSMutableData:

-(void)writeWithNSMutableData
{
    NSString *fileName = @"data.txt";
    NSString *filePath = [[self searchDir:NSDocumentDirectory] stringByAppendingPathComponent:fileName];
    
    NSString *dataStr = @"qwertyuiopasdfghjklzxcvbnm";
    int dataInt = 56789;
    float dataFloat = 0.1234f;
    
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    [mutableData appendData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    [mutableData appendBytes:&dataInt length:sizeof(dataInt)];
    [mutableData appendBytes:&dataFloat length:sizeof(dataFloat)];
    [mutableData writeToFile:filePath atomically:YES];
}

-(void)readWithNSData
{
    
    NSString *fileName = @"data.txt";
    NSString *filePath = [[self searchDir:NSDocumentDirectory] stringByAppendingPathComponent:fileName];
    
    int intData;
    float floatData = 0.0;
    NSString *stringData;
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    stringData = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 26)]
                                       encoding:NSUTF8StringEncoding];
    [data getBytes:&intData range:NSMakeRange(26, sizeof(intData))];
    [data getBytes:&floatData range:NSMakeRange(26 + sizeof(intData), sizeof(floatData))];
    NSLog(@"stringData:%@\n intData:%d\n floatData:%f", stringData, intData, floatData);
}

#pragma mark - Use plist:

-(NSMutableDictionary*)readPropertyList
{
    // Read plist path from Main Bundle:
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyList" ofType:@"plist"];
    // Read data in plist:
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return dic;
}

-(void)writePropertyList
{
    NSMutableDictionary *dic = [self readPropertyList];
    
    [dic setObject:@"newValue" forKey:@"newKey"];
    
    NSString *newPlistPath = [[self searchDir:NSDocumentDirectory]stringByAppendingString:@"NewPropertyList.plist"];
    
    [dic writeToFile:newPlistPath atomically:YES];
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithContentsOfFile:newPlistPath];
    NSLog(@"data in new plist:%@", newDic);
}

#pragma mark - Use NSFileManager:

-(void)createDirectory
{
    NSString *docDir = [self searchDir:NSDocumentDirectory];
    NSString *myDir = [docDir stringByAppendingPathComponent:@"myDir"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:myDir withIntermediateDirectories:YES attributes:nil error:nil];
}

-(void)writeDataToFile
{
    NSString *fileName = @"data.txt";
    NSString* path = [self searchDir:NSDocumentDirectory];
    NSString *filePath = [[path stringByAppendingPathComponent:@"myDir"] stringByAppendingPathComponent:fileName];
    
    NSString *dataStr = @"qwertyuiopasdfghjklzxcvbnm";
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:data attributes:nil];
}

-(void)readSubPathsOfDir
{
    NSString* path = [self searchDir:NSDocumentDirectory];
    NSString *filePath = [path stringByAppendingPathComponent:@"myDir"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPaths = [fileManager subpathsAtPath:filePath];
    NSLog(@"%@", subPaths);
    NSArray *subPathsOfDirectory = [fileManager subpathsOfDirectoryAtPath:filePath error:nil];
    NSLog(@"%@", subPathsOfDirectory);
}

-(void)changeCurrentDirToWrite
{
    NSString* path = [self searchDir:NSDocumentDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // With changing current directory, you needn't specify the dir to write.
    [fileManager changeCurrentDirectoryPath:path];
    
    NSString *fileName = @"array.txt";
    NSString *dataStr = @"qwertyuiopasdfghjklzxcvbnm";
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileManager createFileAtPath:fileName contents:data attributes:nil];
}

-(void)removeItemAtPath
{
    NSString* path = [self searchDir:NSDocumentDirectory];
    NSString *filePath = [path stringByAppendingPathComponent:@"myDir"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

@end
