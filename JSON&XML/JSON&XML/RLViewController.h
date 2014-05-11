//
//  RLViewController.h
//  JSON&XML
//
//  Created by RincLiu on 5/11/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLViewController : UIViewController<NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableString *xmlString;

@end
