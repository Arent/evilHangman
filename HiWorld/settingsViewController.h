//
//  ViewControler2.h
//  HiWorld
//
//  Created by Arent Stienstra on 07-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsViewController : UIViewController{
    //float test;
    IBOutlet UISlider *sliderGuesses;
    IBOutlet UILabel *labelSliderGuesses;
    IBOutlet UISlider *sliderWords;
    IBOutlet UILabel *labelSliderWords;
}
-(IBAction)slidetheslider:(id)sender;
@end
