//
// Copyright 2018 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "XCUIApplication+GREYEnvironment.h"

@implementation XCUIApplication (GREYEnvironment)

- (void)grey_configureApplicationForLaunch {
  NSMutableDictionary<NSString *, NSString *> *mutableEnv = [self.launchEnvironment mutableCopy];
  if (![mutableEnv[@"EG_SKIP_INSERT_LIBRARIES"] isEqualToString:@"YES"]) {
    NSString *insertionKey = @"DYLD_INSERT_LIBRARIES";
    NSString *insertionValue = @"@executable_path/Frameworks/AppFramework.framework/AppFramework";
    NSString *alreadyExistingValue = [mutableEnv valueForKey:insertionKey];
    NSArray<NSString *> *existingValues = [alreadyExistingValue componentsSeparatedByString:@":"];
    if (existingValues && ![existingValues containsObject:insertionValue]) {
      insertionValue = [NSString stringWithFormat:@"%@:%@", alreadyExistingValue, insertionValue];
    }
    [mutableEnv setObject:insertionValue forKey:insertionKey];
  }

  // Pass in this flag so logging is enabled for the application process for both NSLog and OSLog.
  mutableEnv[@"OS_ACTIVITY_DT_MODE"] = @"YES";
  self.launchEnvironment = [mutableEnv copy];
}

@end
