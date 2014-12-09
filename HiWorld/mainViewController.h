//
//  ViewController.h
//  HiWorld
//
//  Created by Arent Stienstra on 07-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController <UIAlertViewDelegate>  {
    IBOutlet UITextField *textField;
    IBOutlet UILabel *userOutput;
    IBOutlet UILabel *userGuesedLetters;
    BOOL test;
 
}
    
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *userOutput;
@property (strong, nonatomic) IBOutlet UILabel *outputGuesses;
@property (strong, nonatomic) IBOutlet UILabel *userGuesedLetters;
-(NSString *)sortArray: (NSMutableArray*)array;
-(NSString *)makeStringOutput: (NSMutableArray*)array;
-(IBAction)newGame:(id)sender;
@end