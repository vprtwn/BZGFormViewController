//
//  BZGKeyboardControlSpecs.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGKeyboardControl.h"
#import "BZGTextFieldCell.h"

BZGKeyboardControl  *keyboardControl;
BZGTextFieldCell    *cell1;
BZGTextFieldCell    *cell2;

SpecBegin(BZGKeyboardControl)

before(^{
    keyboardControl = [[BZGKeyboardControl alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    cell1 = [[BZGTextFieldCell alloc] init];
    cell2 = [[BZGTextFieldCell alloc] init];
});

after(^{
    keyboardControl = nil;
    cell1           = nil;
    cell2           = nil;
});


describe(@"Initialization", ^{
    it(@"should initialize with correct defaults", ^{
        expect(keyboardControl.previousButton).toNot.beNil();
        expect(keyboardControl.nextButton).toNot.beNil();
        expect(keyboardControl.doneButton).toNot.beNil();
        expect(keyboardControl.previousButton.enabled).to.beFalsy();
        expect(keyboardControl.nextButton.enabled).to.beFalsy();
        expect(keyboardControl.previousButton.tintColor).to.equal([UIColor blackColor]);
        expect(keyboardControl.nextButton.tintColor).to.equal([UIColor blackColor]);
        expect(keyboardControl.doneButton.tintColor).to.equal([UIColor blackColor]);
    });
});

describe(@"Button States", ^{
    
    it(@"should have both buttons enabled if it has a previous cell and next cell", ^{
        keyboardControl.previousCell    = cell1;
        keyboardControl.nextCell        = cell2;
        expect(keyboardControl.previousButton.enabled).to.beTruthy();
        expect(keyboardControl.nextButton.enabled).to.beTruthy();
    });
    
    it(@"should have only the previous button enabled if it has a previous cell and a nil next cell", ^{
        keyboardControl.previousCell    = cell1;
        keyboardControl.nextCell        = nil;
        expect(keyboardControl.previousButton.enabled).to.beTruthy();
        expect(keyboardControl.nextButton.enabled).to.beFalsy();
    });
    
    it(@"should have only the next button enabled if it has a nil previous cell and a next cell", ^{
        keyboardControl.previousCell    = nil;
        keyboardControl.nextCell        = cell2;
        expect(keyboardControl.previousButton.enabled).to.beFalsy();
        expect(keyboardControl.nextButton.enabled).to.beTruthy();
    });
    
    it(@"should have both buttons disabled if it has a nil previous cell and a nil next cell", ^{
        keyboardControl.previousCell    = nil;
        keyboardControl.nextCell        = nil;
        expect(keyboardControl.previousButton.enabled).to.beFalsy();
        expect(keyboardControl.nextButton.enabled).to.beFalsy();
    });
    
});

SpecEnd