//
//  ViewControler2.m
//  HiWorld
//
//  Created by Arent Stienstra on 07-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import "settingsViewController.h"

@implementation settingsViewController

-(IBAction)slidetheslider:(id)sender{
    labelSliderGuesses.text =  [NSString stringWithFormat:@"%1.0f", sliderGuesses.value *25 +1 ];
    labelSliderWords.text =  [NSString stringWithFormat:@"%1.0f", sliderWords.value *30 +1 ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

