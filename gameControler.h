//
//  gameControler.h
//  evilHangman
//
//  Created by Arent Stienstra on 29-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gameControler : UIViewController <UIAlertViewDelegate>


@property (retain, nonatomic, readwrite) NSMutableArray  *guessedWord;
@property (retain, nonatomic, readwrite) NSMutableArray  *guessedLetters;
@property (assign, nonatomic, readwrite) int  remainingGuesses;
@property (assign, nonatomic, readwrite) int  wordLength;
@property (copy, nonatomic, readwrite) NSString  *aRandomCorrectWord;
@property (retain, nonatomic, readwrite) NSMutableCharacterSet *remainingLetters;
@property (copy, nonatomic, readwrite) NSArray *words;


- (id)init;
- (void)gameflow: (NSString *)input;
- (Boolean)validInput: (NSString *)input;
- (NSMutableDictionary *)makeEquivalanceClasses: (NSString *)input;
- (int)bestEquivalanceClass:(NSMutableDictionary *)equivalanceClasses;
- (NSMutableArray *)makeIndices:(int)code;
- (int)indicesToCode:(NSMutableArray *)indices;
- (NSMutableArray *)wordToIndices: (NSString *)word andInput:(NSString *)input;
- (void)updateGuessedWordWithCode:(int)code andInput:(NSString *)input;
- (Boolean)gameWon;
- (Boolean)gameLost;

@end
