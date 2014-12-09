//
//  gameControler.h
//  evilHangman
//
//  Created by Arent Stienstra on 29-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gameControler : UIViewController{
    int _remainingGuesses;
    int _wordLength;
    NSString *guessedWord;
    NSArray *words;
    NSMutableArray *guessedLetters;
    NSMutableCharacterSet *remainingLetters;
}
@property (assign, nonatomic, readwrite) BOOL  gameRunning;
@property (copy, nonatomic, readwrite) NSMutableArray  *guessedWord;
@property (copy, nonatomic, readwrite) NSMutableArray  *guessedLetters;
@property (assign, nonatomic, readwrite) int  remainingGuesses;


- (id)init;
- (Boolean)gameWon;
- (Boolean)gameLost;
- (Boolean)validInput: (NSString *)input;
- (Boolean)validCode: (int)code;
- (void)input: (NSString *)input;
- (void)chooseWordSubset: (NSString *)input;
- (NSPredicate *)makePredicateIndices:(NSMutableArray *)indices andInput:(NSString *)input;
- (NSMutableArray *)makeIndices:(int)code;
- (void)updateGuessedWordWithCode:(int)code andInput:(NSString *)input;

@end
