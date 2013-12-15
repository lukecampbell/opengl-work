#import "Queue.h"

@implementation Queue

- (id) init {
    self = [super init];
    if(self) {
        list = [NSMutableArray new];
        queue = dispatch_queue_create("Thread Safe Queue", NULL);
    }
    return self;
}

- (void) dealloc {
    dispatch_release(queue);
}

- (void) put: (id) val {
    if(!val) {
        return;
    }
    dispatch_async(queue, ^{
        [list addObject: val];
    });
}

- (id) get {
    __block id obj=nil;
    dispatch_sync(queue, ^{
        if([list count] > 0) {
            obj = [list objectAtIndex:0];
            [list removeObjectAtIndex: 0];
        }
    });
    return obj;
}

- (BOOL) isEmpty {
    __block BOOL retval;
    dispatch_sync(queue, ^{
        retval = [list count] > 0;
    });
    return retval;
}


@end
