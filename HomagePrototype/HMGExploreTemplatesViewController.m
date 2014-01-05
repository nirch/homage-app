//
//  HomageViewController.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGExploreTemplatesViewController.h"
#import "HMGTemplateDetailedViewController.h"
#import "HMGTemplateCVCell.h"
//#import "HMGTemplateIterator.h"
//#import "HMGTemplate.h"
#import "HMGHomage.h"

@interface HMGExploreTemplatesViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak,nonatomic) IBOutlet UICollectionView *templateCView;
//@property (strong,nonatomic) HMGTemplateIterator *templateIterator;
@property (nonatomic) NSInteger selectedStoryIndex;

@end

@implementation HMGExploreTemplatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.templateIterator = [[HMGTemplateIterator alloc] init];
    //self.templatesArray = [self.templateIterator next];
    
    self.stories = [[HMGHomage sharedHomage] stories];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.stories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.templateCView dequeueReusableCellWithReuseIdentifier:@"TemplateCell"
                                  forIndexPath:indexPath];
    //HMGTemplate *template = self.templatesArray[indexPath.item];
    HMGStory *story = self.stories[indexPath.item];
    [self updateCell:cell withStory:story];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell withStory:(HMGStory *)story
{
    if ([cell isKindOfClass: [HMGTemplateCVCell class]])
    {
        HMGTemplateCVCell *templateCell = (HMGTemplateCVCell *) cell;
        templateCell.templateName.text = story.name;
        
        if (story.thumbnail)
        {
            templateCell.templatePreviewImageView.image = story.thumbnail;
        }
        else
        {
            if (story.thumbnailURL)
            {
                // Loading the thumbnail (doing this on a different thread)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    // Downloading the thumbnail from URL
                    NSError *thumbnailDownloadError;
                    story.thumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:story.thumbnailURL options:NSDataReadingMappedAlways error:&thumbnailDownloadError]];
                    if (thumbnailDownloadError)
                    {
                        NSString *errorDescription = [NSString stringWithFormat:@"Trying to download image from: %@, resulted with the following error: %@", story.thumbnailURL.path, thumbnailDownloadError.description];
                        HMGLogError(errorDescription);
                        [NSException raise:@"ConnectivityException" format:@"%@", errorDescription];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        templateCell.templatePreviewImageView.image = story.thumbnail;
                    });
                });
            }
            else
            {
                // Error - No URL
                HMGLogError(@"story <%@> has no thumbnail URL", story.name);
            }
        }

        //templateCell.difficulty.text = template.levelDescription;
        //templateCell.uploaded                     = template.uploadDate;
        //templateCell.numOfRemakes.text = [NSString stringWithFormat:NSLocalizedString(@"NUM_OF_REMAKES", nil), [template.remakes count]];
        //cell.totalViews                           = template.totalViews;
    }
        
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedStoryIndex = indexPath.item;
    UICollectionViewCell *cell = [self.templateCView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showTemplate" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTemplate"])
    {
        if ([segue.destinationViewController isKindOfClass:[HMGTemplateDetailedViewController class]] && [sender isKindOfClass:[HMGTemplateCVCell class]])
        {
            HMGTemplateDetailedViewController *destController = (HMGTemplateDetailedViewController *)segue.destinationViewController;
            //HMGTemplate *templateToDisplay = self.templatesArray[self.selectedTemplateIndex];
            //destController.templateToDisplay = templateToDisplay;
            
            HMGStory *selectedStory = self.stories[self.selectedStoryIndex];
            destController.storyToDisplay = selectedStory;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
