#import <Foundation/Foundation.h>

@interface Queue : NSObject {
    NSMutableArray *list;
    dispatch_queue_t queue;
}

- (void) put: (id) val;
- (id) get;
- (BOOL) isEmpty;
@end


