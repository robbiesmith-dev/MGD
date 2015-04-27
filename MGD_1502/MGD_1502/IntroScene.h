//
//  IntroScene.h
//  MGD_1502
//
//  Created by Robert Smith on 2/25/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>


@interface IntroScene : SKScene <GKGameCenterControllerDelegate>

@property (strong, nonatomic) NSString *leaderboardID;

-(id)initWithSize:(CGSize)size leaderboardID:(NSString*)leaderboardID;

@end
