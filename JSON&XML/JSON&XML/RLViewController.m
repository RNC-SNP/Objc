//
//  RLViewController.m
//  JSON&XML
//
//  Created by RincLiu on 5/11/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self serializeJSON];
    [self parseXML];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Use NSJSONSerialization:

-(void)serializeJSON
{
    // Init URL:
    NSURL *url = [NSURL URLWithString:@"https://api.douban.com/v2/book/1220562"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    // Serialize JSON data:
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
    if (error)
    {
        assert(error);
    }
    NSLog(@"Serialized JSON data:\n%@", array);
    // Create a plist file in SandBox's Document drectory:
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documents[0] stringByAppendingPathComponent:@"json.plist"];
    // Save serialized data in plist file:
    [array writeToFile:path atomically:YES];
    NSLog(@"JSON data has been saved at:%@", path);
}

#pragma mark - Use NSXMLParser:

-(void)parseXML
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"provinces" ofType:@"xml"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    parser.delegate = self;
    
    [parser parse];
}

#pragma mark - Methods in NSXMLParserDelegate protocol:

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    if(!_xmlString)
    {
        _xmlString = [NSMutableString stringWithString:@"xml data : {\n"];
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"plist"])
    {
        NSNumber *version = attributeDict[@"version"];
        [_xmlString appendFormat:@"version: %@", version];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_xmlString appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_xmlString appendString:@"}"];
    NSLog(@"%@", _xmlString);
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    assert(parseError);
}

@end
