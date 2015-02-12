//
//  RandomGen.m
//  MGD_1502
//
//  Created by Robert Smith on 2/11/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import "RandomGen.h"

@implementation RandomGen


+(NSInteger) randomSpotFromLeft:(NSInteger)left right:(NSInteger)right
{
    return arc4random()%(right-left)+left;
}
@end
