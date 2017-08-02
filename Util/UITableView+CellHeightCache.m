#import "UITableView+CellHeightCache.h"

#import "objc/runtime.h"

@interface CellHeightCache : NSObject
@property (nonatomic,strong) NSMutableDictionary *cache;
@end

@implementation CellHeightCache

-(instancetype)init {
    if (self = [super init]) {
        _cache = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(BOOL)existsHeightForKey:(id<NSCopying>)key {
    NSNumber *number = _cache[key];
    return number && ![number isEqualToNumber:@-1];
}

-(void)cacheHeight:(CGFloat)height withKey:(id<NSCopying>)key {
    _cache[key] = @(height);
}

-(CGFloat)heightForKey:(id<NSCopying>)key {
#if CGFLOAT_IS_DOUBLE
    return [_cache[key] doubleValue];
#else
    return [_cache[key] floatValue];
#endif
}

@end

@implementation UITableView(CellHeightCache)

-(CGFloat)cachedCellHeightOfKey:(NSString*)key {
    if (key != nil) {
        CellHeightCache* cache = [self cellHeightCache];
        if ([cache existsHeightForKey:key]) {
            CGFloat cachedHeight = [cache heightForKey:key];
            return cachedHeight;
        }
    }
    return 0;
}

-(void)cacheCellHeight:(CGFloat)cellHeight withKey:(NSString*)key {
    [self.cellHeightCache cacheHeight:cellHeight withKey:key];
}

-(CellHeightCache*)cellHeightCache {
    CellHeightCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [CellHeightCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end
