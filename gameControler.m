//
//  gameControler.m
//  evilHangman
//
//  Created by Arent Stienstra on 29-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import "gameControler.h"
#import "mainViewController.h"

@implementation gameControler{
    mainViewController *view;
}


//@synthesize gameRunning;
@synthesize guessedWord =_guessedWord;
@synthesize wordLength =_wordLength;
@synthesize guessedLetters =_guessedLetters;
@synthesize remainingGuesses =_remainingGuesses;
@synthesize aRandomCorrectWord=_aRandomCorrectWord;
@synthesize words=_words;
@synthesize remainingLetters=_remainingletters;


-(id) init{
    //load plist
    NSMutableDictionary *myDic = [[NSMutableDictionary alloc] initWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    // load defaults from plist
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
    //initialize game variabels
    self.remainingGuesses = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfGuesses"];
    self.wordLength = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"wordLength"];
    self.words= [[myDic valueForKey:@"words"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length == %d",self.wordLength]];
    self.remainingLetters = [NSMutableCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    self.guessedWord= [NSMutableArray array];
    self.guessedLetters=[NSMutableArray array];
    for(int i = 0;i <self.wordLength;i++){
        [self.guessedWord addObject:@""];
    }
    return self;
}

- (void)gameflow:(NSString *)input{
    if([self validInput:input]){ //validates input
        
        input = [input uppercaseString];
        [self.guessedLetters addObject:input]; //To show the user wich letters he already guessed
        
        NSMutableDictionary *equivalanceClasses = [self makeEquivalanceClasses:input];
        int optimalCode = [self bestEquivalanceClass:equivalanceClasses];
        self.words = [equivalanceClasses objectForKey:[NSNumber numberWithInt:optimalCode]]; //removes unneccecary words
    
        [self pickRandomCorrectWord];  // picks a random correct word as the 'awnser' (to show when de user has defeated)
        [self updateGuessedWordWithCode:optimalCode andInput:input];     //Update the letters that has been guessed correctly (for the output)
        if(optimalCode == 0){
            self.remainingGuesses= self.remainingGuesses -1;  //decreases the remaining guesses if the user didnt guess a correct letter
        }
    }
    
}

// checks if user input is valid  (as in any letter from the) alphabet
- (Boolean)validInput: (NSString *) input{
    
    // check if input is backspace!
    if(!input.length){
        return NO;
    }
    input = [input uppercaseString]; //forces uppercase
    
    //Checks if the guessed letter has not been guessed before!
    NSCharacterSet *s = [self.remainingLetters invertedSet];
    NSRange r = [input rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        return NO;
    }
    [self.remainingLetters removeCharactersInString:input];
    return YES;
}


// This method will create all the nessecary equicilance classes. It will loop over every word and determine wich class it belongs
- (NSMutableDictionary *)makeEquivalanceClasses: (NSString *)input{
    NSMutableDictionary *equivalanceClasses = [[ NSMutableDictionary alloc] init];
     int totalLength = (int)[self.words count];
    
    for(int i = 0; i<totalLength;i++){ // loop over every word in wordlist
        NSString *word = [self.words objectAtIndex:i]; //current word
        int code = [self indicesToCode:[self wordToIndices:word andInput:input]]; //code is the equivalance class (Check indicesToCode for an explanation)
        NSMutableArray *wordlist = [NSMutableArray array];
        
        if( [equivalanceClasses objectForKey:[NSNumber numberWithInt:code]] ){ // checks if the equivalance class alreaddy exist
            wordlist = [equivalanceClasses objectForKey:[NSNumber numberWithInt:code]]; // if so, add
            [wordlist addObject:word];
            [equivalanceClasses setObject:wordlist forKey:[NSNumber numberWithInt:code]];
        }
        else{
            [wordlist addObject:word];
            [equivalanceClasses setObject:wordlist forKey:[NSNumber numberWithInt:code]]; // else create new wordlist
        }
    }
    
    return equivalanceClasses;
}

// This method will find the equivalance class wich contains the most words.
- (int)bestEquivalanceClass:(NSMutableDictionary *)equivalanceClasses{
    int maxLength =0;
    int optimalCode =0;
    int iLength =0;
    for(id element in equivalanceClasses){ // loops over every equivalance class
        iLength = (int)[[equivalanceClasses objectForKey:element] count];
        if( iLength > maxLength){ //maxLength will become the maximum number of words in the equivalance class
            maxLength = iLength ;
            optimalCode = (int)[element integerValue]; //optimalCode is the code for the largest equivalance class.
        }
    }
    return optimalCode;
}

//This method picks a random correct word, this word is displayed when the user has lost.
- (void)pickRandomCorrectWord{
    
    int totalLength = (int)[self.words count];
    int randomIndex;
    if(totalLength>1){
        randomIndex = arc4random() % (totalLength-1); //This will insure that the randomindex will not exceed the length of the word list
    }
    else{
        randomIndex = 0;
    }
    self.aRandomCorrectWord = [self.words objectAtIndex:randomIndex];
}

//This method will make a range of indices with an code. It will use binary numbers (i.e. 11 -> 1,0,1,1 because (1* 2^0 + 1*2^1 + 0*2^2 + 1*2^3 = 11)
-(NSMutableArray *)makeIndices:(int)code{
    NSMutableArray *indices = [NSMutableArray array];
        for( double i =self.wordLength-1; i >= 0; i--){
            if(code - pow(2,i) >=0 ){
                code = code -pow(2,i);
                [indices setObject:[NSNumber numberWithInt:1] atIndexedSubscript:self.wordLength-i-1];
            }
            else{
                [indices setObject:[NSNumber numberWithInt:0] atIndexedSubscript:self.wordLength-i-1];
            }
        }
    return indices;
}

// This method will make an code with a range of indices using binary numbers( i.e [0,1,1,0,0] = (0*2^0 + 0*2^1 + 1*2^2 + 1*2^3 +0*2^4 = 12) each code represents an equivalance class)
- (int)indicesToCode:(NSMutableArray *)indices{
    int code=0;
    for(int i = 0; i<self.wordLength;i++){
        if([indices objectAtIndex:i] == [NSNumber numberWithInt:1]){
            code = code + pow(2,self.wordLength-i-1);
        }
    }
    return code;
}

// This method makes and range of indices with an word and an inputletter. The index 'i' will be 0 if the word has a different letter on index 'i' than the inputletter and 1 if the letters are the same. (i.e.  word: CALL and letter L -> [0,0,1,1]
- (NSMutableArray *)wordToIndices: (NSString *)word andInput:(NSString *)input{
    NSMutableArray *indices = [NSMutableArray array];
    for(int i =0; i<self.wordLength;i++){
        if([word characterAtIndex:i] == [input characterAtIndex:0]){
            [indices setObject:[NSNumber numberWithInt:1] atIndexedSubscript:i];
        }
        else{
            [indices setObject:[NSNumber numberWithInt:0] atIndexedSubscript:i];
        }
        
    }
    
    return indices;
    
}


//Updates the correctly guessed letters
- (void)updateGuessedWordWithCode:(int)code andInput:(NSString *)input{
    NSMutableArray *indices =[self makeIndices:code];
    for(int i = 0;i<self.wordLength;i++)
        if([indices objectAtIndex:i] == [NSNumber numberWithInt:1]){
            [self.guessedWord setObject:input atIndexedSubscript:i];
        }
}

// Checks if the game is won
- (Boolean)gameWon{
    
    for( id element in self.guessedWord){
        if([element isEqualToString:@""]){
            return NO;
        }
    }
    return YES;
}

// Checks if the game is lost
- (Boolean)gameLost{
    if(self.remainingGuesses > 0){
        return NO;
    }
    else{
        return YES;
    }
}


@end

