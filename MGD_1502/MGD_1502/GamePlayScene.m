//
//  GameScene.m
//  MGD_1502
//
//  Created by Robert Smith on 2/3/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import "GamePlayScene.h"

@implementation GamePlayScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        self.backgroundColor = [SKColor blackColor];
        // add a physics body to the scene
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        // change gravity settings of the physics world
        self.physicsWorld.gravity = CGVectorMake(0, -1.5);
        //Edge Frame
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        [self addBG];
        [self addPlayer];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        //CGPoint location = [touch locationInNode:self];
        
        NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
        for (SKNode *node in nodes)
        {
            //or check the node against your nodes
//            if ([node.name isEqualToString:@"bg"])
//            {
//                [self addLaser];
//                [self runAction:[SKAction playSoundFileNamed:@"rock.wav" waitForCompletion:NO]];
//            }
            
            if ([node.name isEqualToString:@"player"])
            {
                [self runAction:[SKAction playSoundFileNamed:@"spaceship.wav" waitForCompletion:NO]];
            }
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        CGPoint newPosition = CGPointMake(location.x, 100);
        
        // stop the paddle from going too far
        if (newPosition.x < _player.size.width / 2)
        {
            newPosition.x = _player.size.width / 2;
        }
        if (newPosition.x > self.size.width - (_player.size.width/2))
        {
            newPosition.x = self.size.width - (_player.size.width/2);
        }
        
        _player.position = newPosition;
    }
}

-(void)update:(CFTimeInterval)currentTime
{

}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addPlayer
{
    //Player
    _player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    _player.size = CGSizeMake(75, 75);
    _player.position = CGPointMake(self.frame.size.width/2, 100);
    _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.frame.size];
    _player.physicsBody.dynamic = NO;
    _player.name = @"player";
    
    [self addChild:_player];
}

- (void)addBG
{
    //Set Sky from PNG
    SKSpriteNode *sky = [SKSpriteNode spriteNodeWithImageNamed:@"newBG"];
    sky.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    sky.anchorPoint = CGPointMake(0, 0);
    sky.position = CGPointMake(0, 0);
    sky.name = @"bg";
    
    [self addChild:sky];
}

-(void)addLaser
{
   //Laser
    SKSpriteNode *laser = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(20, 40)];
    laser.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 40);
    laser.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:laser.frame.size];
    laser.name = @"laser";
    
    [self addChild:laser];
}

@end
