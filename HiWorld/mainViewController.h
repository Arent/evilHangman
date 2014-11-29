//
//  ViewController.h
//  HiWorld
//
//  Created by Arent Stienstra on 07-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController {
    IBOutlet UITextField *textField;
    IBOutlet UILabel *userOutput;
    IBOutlet UILabel *outputGuesses;
}
    
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *userOutput;
@property (strong, nonatomic) IBOutlet UILabel *outputGuesses;


@end

