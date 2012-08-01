//
//  ShelfViewController.m
//  Baker
//
//  ==========================================================================================
//
//  Copyright (c) 2010-2012, Davide Casali, Marco Colombo, Alessandro Morandi
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this list of
//  conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this list of
//  conditions and the following disclaimer in the documentation and/or other materials
//  provided with the distribution.
//  Neither the name of the Baker Framework nor the names of its contributors may be used to
//  endorse or promote products derived from this software without specific prior written
//  permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
//  SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "ShelfViewController.h"
#import "ShelfManager.h"

#import "BakerViewController.h"

@implementation ShelfViewController

@synthesize books;

#pragma mark - Init

- (id)init {

    self = [super init];
    if (self) {
        self.books = [ShelfManager localBooksList];
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc
{
    [books release];

    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Baker Shelf";

    self.gridView.backgroundColor  = [UIColor scrollViewTexturedBackgroundColor];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;

    [self.gridView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Shelf data source

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    return [books count];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *cellIdentifier = @"cellIdentifier";

    AQGridViewCell *cell = (AQGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[[AQGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 150) reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionGlowColor = [UIColor clearColor];

        NSString *bookPath = [[self.books objectAtIndex:index] path];
        UIImage *thumbImg  = [UIImage imageWithContentsOfFile:[bookPath stringByAppendingPathComponent:@"thumb.png"]];
        UIImageView *thumb = [[[UIImageView alloc] initWithImage:thumbImg] autorelease];

        [cell.contentView addSubview:thumb];
	}

    return cell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(153.6, 240);
}

#pragma mark - Navigation management

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    [gridView deselectItemAtIndex:index animated:NO];

    BakerViewController *bakerViewController = [[BakerViewController alloc] initWithBook:[self.books objectAtIndex:index]];

    [self.navigationController pushViewController:bakerViewController animated:YES];
    [bakerViewController release];
}

@end
