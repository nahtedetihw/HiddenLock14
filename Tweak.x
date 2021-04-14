#include <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "Tweak.h"

//Thanks to u/CreatureSurvive, u/WoahAName, little GrapeScript & little azzou :)

%hook TCCDService
- (void)setDefaultAllowedIdentifiersList:(NSArray *)list {
    if ([self.name isEqual:@"kTCCServiceFaceID"]) {
        NSMutableArray *tcclist = [list mutableCopy];
        [tcclist addObject:@"com.apple.mobileslideshow"];
        return %orig([tcclist copy]);
    }
    return %orig;
}
%end

%hook NSBundle
- (NSDictionary *)infoDictionary {
    NSMutableDictionary *plist = %orig.mutableCopy;
    [plist setObject:@"HiddenLock14 want's to use FaceID" forKey:@"NSFaceIDUsageDescription"];
    return plist.copy;
}
%end

%hook PXNavigationListGadget
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		LAContext *context = [LAContext new];
		NSError *fiError = nil;
		if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&fiError]) {
			[context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"Unlock Hidden album", nil) reply:^(BOOL success, NSError *error) {
				dispatch_async(dispatch_get_main_queue(), ^{
					if (success) {
						%orig;
					} else {
						[tableView deselectRowAtIndexPath:indexPath animated:NO];
					}
				});
			}];
		} else {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	} else {
		%orig;
	}
}
%end