//
//  MCoreDataContextOperation_Private.h
//  MCoreData
//
//  Created by Malcolm Hall on 14/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <MCoreData/MCDSaveContextOperation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDSaveContextOperation()

// Override to call custom completion blocks, then call super last since this is tearing down.
- (void)finishOnCallbackQueueWithError:(nullable NSError *)error NS_REQUIRES_SUPER;

// Use for custom progress blocks.
- (void)performBlockOnCallbackQueue:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END