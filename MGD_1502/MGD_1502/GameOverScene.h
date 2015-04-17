//
//  GameOverScene.h
//  MGD_1502
//
//  Created by Robert Smith on 2/12/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol sceneDelegate <NSObject>

-(void)showShareScreen;

@end


@interface GameOverScene : SKScene

@property (strong, nonatomic) id <sceneDelegate> myDelegate;

@end
