//
//  GameViewController.m
//  MGD_1502
//
//  Created by Robert Smith on 2/3/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import "MGDVC.h"
#import "GamePlayScene.h"
#import "IntroScene.h"
#import <Social/Social.h>
#import <GameKit/GameKit.h>

@interface MGDVC ()

@property (nonatomic) BOOL gameCenterEnabled;

@property (nonatomic)  IntroScene *scene;

@end

@implementation MGDVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self authenticateLocalPlayer];
    

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scene = [[IntroScene alloc]initWithSize:skView.bounds.size leaderboardID:_leaderboardIdentifier];
        _scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:_scene];

    });
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)showShareScreen
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:@"TestTweet from the Game !!"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
}

-(void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (viewController != nil)
        {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else
        {
            if ([GKLocalPlayer localPlayer].authenticated)
            {
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil)
                    {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else
                    {
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}

@end
