//
//  DMLoginViewController.m
//  location-notes
//
//  Created by Darin Minamoto on 9/1/15.
//  Copyright (c) 2015 com.d_m. All rights reserved.
//

#import "DMLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface DMLoginViewController ()

@end

@implementation DMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - Interface Builder Actions

- (IBAction)onFacebookLoginClicked:(id)sender {
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships" ];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        NSLog(@"Finished log in!");
        if (!user) {
            NSString *alertMessage, *alertTitle;
            if (error) {
                FBErrorCategory errorCategory = [FBErrorUtility errorCategoryForError:error];
                if ([FBErrorUtility shouldNotifyUserForError:error]) {
                    alertTitle = @"Something went wrong";
                    alertMessage = [FBErrorUtility userMessageForError:error];
                } else if (errorCategory == FBErrorCategoryAuthenticationReopenSession) {
                    alertTitle = @"Session Error";
                    alertMessage = @"Your current session is no longer valid. Please log in again.";
                } else if (errorCategory == FBErrorCategoryUserCancelled) {
                    NSLog(@"User cancelled login");
                } else {
                    alertTitle = @"Unknown error";
                    alertMessage = @"Error. Please try again later.";
                }
            }
            
            if (alertMessage) {
                [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            }
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Logged in!" message:[NSString stringWithFormat:@"Logged in as: %@", user.username] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            NSLog([NSString stringWithFormat:@"Logged in as: %@", user.username]);
        }
    }];
}

@end
