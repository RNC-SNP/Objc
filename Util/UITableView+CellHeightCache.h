#import <UIKit/UIKit.h>

@interface UITableView(CellHeightCache)

-(CGFloat)cachedCellHeightOfKey:(NSString*)key;

-(void)cacheCellHeight:(CGFloat)cellHeight withKey:(NSString*)key;

@end
