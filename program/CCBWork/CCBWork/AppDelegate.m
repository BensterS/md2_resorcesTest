//
//  AppDelegate.m
//  CCBWork
//
//  Created by Benster on 14-9-9.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

int num = 0;
int errorNum = 0;
NSMutableString* errorInfo;         //错误信息
NSMutableDictionary* arrInfo;       //资源信息
NSMutableArray* pngList;            //图片列表
NSMutableDictionary* fileUseRate;   //使用率大于10次的资源文件

//初始化相关路径
NSString* ccbPath = @"/Users/Benster/Desktop/Works/乐多/仙魔录花千骨/md2_res_srcTest1/ccb/Resources";       //ccb文件路径
NSString* resSourcePath = @"/Users/Benster/Desktop/Works/乐多/仙魔录花千骨/md2_res_srcTest1/tps/srcpng2/";  //资源源目录
NSString* resDescPath = @"/Users/Benster/Desktop/Works/乐多/仙魔录花千骨/md2_res_srcTest1/tps/srcpng/";     //资源目标目录
NSString* sharePath = @"/Users/Benster/Desktop/Works/乐多/仙魔录花千骨/md2_res_srcTest1/tps/srcpng/share/"; //公共资源目录
NSString* logPath = @"/Users/Benster/Desktop/CCBWork/CCBWork/ccb/";                                      //输出文件目录
NSString* ccbiLogPath = @"/Users/Benster/Desktop/CCBWork/CCBWork/ccb/ccbi/";                             //ccbi操作日志录

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction)execution:(NSButton*)sender
{
    //初始化错误列表 文件复制信息列表
    errorInfo = [NSMutableString stringWithFormat:@"未复制成功的png\n"];
    arrInfo = [[NSMutableDictionary alloc] init];
    fileUseRate = [[NSMutableDictionary alloc] init];
    pngList = [[NSMutableArray alloc] init];
    
    //复制ccb文件到相关目录
    //ccbOperation();
    
    //初始化路径
    NSArray *fileNameArr = getFilenamelistOfType(@"ccb", ccbPath);
    NSMutableDictionary* fileInfoDict = [[NSMutableDictionary alloc] init];
    
    //读取该路径的所有符合条件的文件
    for (NSString* item in fileNameArr) {
        [fileInfoDict setObject:getFileInfo([NSString stringWithFormat:@"%@/%@", ccbPath, item]) forKey:[item substringToIndex:[item rangeOfString:@".ccb"].location]];
    }
    
    //把所有的图片信息存入数组
    for (NSDictionary* item in [arrInfo allValues]) {
        for (NSString* item1 in item) {
            [pngList addObject:item1];
        }
    }
    
    //统计使用率高的资源文件
    fileUseRate = fileUseCout([fileInfoDict allValues]);
    
    //读取mydp文件
    //NSArray* mydp = getMydpName(@"/Users/Benster/Desktop/CCBTest/CCBTest/mydpList.txt");
    
    //对比文件中的资源文件
    //        NSDictionary* fileInfoTemp = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@fileinfo.plist", logPath]];
    //        NSMutableDictionary* comparisonSrcDict = comparisonSrc(fileInfoDict, fileInfoTemp);
    
    //替换cbb文件中的plist文件
    for (NSString* item in fileNameArr) {
        ccbPlistReplace([NSString stringWithFormat:@"%@/%@", ccbPath, item], [item substringToIndex:[item rangeOfString:@"."].location]);
    }
    
    //读取文件中的信息，提取出png图片信息和plist文件信息, 并复制到相关目录
//    for (NSString* item in [fileInfoDict allKeys]) {
//       for (NSString* item1 in [fileInfoDict objectForKey:item]) {
//           copyToPath([NSString stringWithFormat:@"%@%@", resDescPath, item], [NSString stringWithFormat:@"%@%@", resSourcePath, item1],  item1, NO);
//       }
//    }
    
    //输出复制信息
    NSLog(@"copyNum = %i\terrorNum = %i", num, errorNum);
    
    //把复制信息写入文件
//    [comparisonSrcDict writeToFile:[NSString stringWithFormat:@"%@comparisonSrc.plist", logPath] atomically:NO];
//    [mydp writeToFile:[NSString stringWithFormat:@"%@/program_load.plist", logPath] atomically:NO];
    //[errorInfo writeToFile:[NSString stringWithFormat:@"%@/program_load_copy_error.txt", logPath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
//    [fileUseRate writeToFile:[NSString stringWithFormat:@"%@fileCount.plist", logPath] atomically:NO];
//    [fileInfoDict writeToFile:[NSString stringWithFormat:@"%@fileinfo.plist", logPath] atomically:NO];
//    [arrInfo writeToFile:[NSString stringWithFormat:@"%@fileinfo1.plist", logPath] atomically:NO];
//    [errorInfo writeToFile:[NSString stringWithFormat:@"%@copyError.txt", logPath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    
}



#pragma mark - 获取文件中得PNG图片名和plist文件名
NSArray* getFileInfo(NSString* fileURL)
{
    NSString* str = [NSString stringWithContentsOfFile:fileURL encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* arr = [str componentsSeparatedByString:@"\n"];
    NSMutableDictionary* mDic1 = [[NSMutableDictionary alloc] init];
    
    for (NSUInteger i = 0; i < [arr count]; i ++) {
        //查找"<string>"位置
        NSUInteger location = [arr[i] rangeOfString:@"<string>"].location;
        //查找</string>位置
        NSUInteger length = [arr[i] rangeOfString:@"</string>"].location;
        
        //判断查找的位置是否存在 判断节点中间是否有数据
        if (location != 9223372036854775807 && length != 9223372036854775807 && length - location - 8 > 0) {
            
            NSString* tem1 = [arr[i] substringWithRange:NSMakeRange(location + 8, length-location-8)];
            
            //查找图片
            NSUInteger location2 = [tem1 rangeOfString:@".png"].location;
            
            //查找plist文件
            NSUInteger location3 = [arr[i-1] rangeOfString:@"<string>"].location;
            NSUInteger length3 = [arr[i-1] rangeOfString:@"</string>"].location;
            
            //判断是否存在图片
            if (location2 != 9223372036854775807 && location3 != 9223372036854775807 && length3 != 9223372036854775807) {
                NSString* tem3 = [arr[i-1] substringWithRange:NSMakeRange(location3 + 8, length3-location3-8)];
                [mDic1 setObject:tem3 forKey:tem1];
            }
        }
    }
    
    NSArray* tempArr = [fileURL componentsSeparatedByString:@"/"];
    [arrInfo setObject:mDic1 forKey:tempArr[[tempArr count] - 1]];
    
    return [mDic1 allKeys];
}

#pragma mark - 判断文件是否存在
BOOL isFileExistAtPath(NSString* fileFullPath)
{
    BOOL isExist = NO;
    //判断该文件夹是否存在
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    
    return isExist;
}

#pragma mark - 获取到该目录下所有的文件
NSArray* getFilenamelistOfType(NSString* type ,NSString* dirPath)
{
    NSMutableArray *filenamelist = [[NSMutableArray alloc] init];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    //通过遍历把所有的文件都存入filenamelist数组
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if (isFileExistAtPath(fullpath)) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}

#pragma mark - 把文件复制到指定路径
void copyToPath(NSString* desFullFilePath ,NSString* souresFileFullPath, NSString* file, BOOL isSharefFile)
{
    //在不复制公用文件时 判断该文件是否是公用文件
    if (!isSharefFile && [[fileUseRate allKeys] containsObject:file]) {
        return;
    }
    
    //判断文件夹是否存在，如果不存在则创建
    if (!isFileExistAtPath(desFullFilePath)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:desFullFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString* desPath = [NSString stringWithFormat:@"%@/%@", desFullFilePath, file];
    
    //判断是否文件复制成功 未成功的文件加入到错误列表
    if([[NSFileManager defaultManager] copyItemAtPath:souresFileFullPath toPath:desPath error:nil])
    {
        num ++;
        NSLog(@"The %i copy success!", num);
    }
    else
    {
        errorNum ++;
        [errorInfo appendString:[NSString stringWithFormat:@"%@\ttoFile\t%@\n", souresFileFullPath, [NSString stringWithFormat:@"%@/%@", desFullFilePath, file]]];
    }
}

#pragma mark - 统计资源使用率
NSMutableDictionary* fileUseCout(NSArray* arr)
{
    //统计资源使用次数
    NSMutableDictionary* tmpDict = [[NSMutableDictionary alloc] init];
    for (NSArray* item in arr) {
        for (NSString* item1 in item) {
            if ([[tmpDict allKeys] containsObject:item1]) {
                [tmpDict setObject:[NSString stringWithFormat:@"%lu", [[tmpDict valueForKey:item1] integerValue] + 1] forKey:item1];
            }
            else
            {
                [tmpDict setObject:@"1" forKey:item1];
            }
        }
    }
    
    int sum = 0;
    //删除使用率小于10次的资源文件
    for (NSString* item in [tmpDict allKeys]) {
        if ([[tmpDict valueForKey:item] integerValue] < 10) {
            [tmpDict removeObjectForKey:item];
        }
        else
        {
            //把公共资源文件复制到公共目录
            NSString* sourcePath = [resSourcePath stringByAppendingString:item];
            copyToPath(sharePath, sourcePath, item, YES);
            sum += [[tmpDict valueForKey:item] integerValue];
        }
    }
    
    NSLog(@"公共文件个数：%i", sum);
    
    return tmpDict;
}

#pragma mark - 格式化plistName
NSString* formatePlistName(NSString* ccbName)
{
    NSMutableString* tempStr = [[NSMutableString alloc] init];
    
    //判断字符串中是否有大写 有大写转换为_小写
    for (int i = 0; i < [ccbName length] - 1; i ++) {
        if ([ccbName characterAtIndex:i] > 64 && [ccbName characterAtIndex:i] < 91) {
            [tempStr appendString:[NSString stringWithFormat:@"_%c", [ccbName characterAtIndex:i] + 32]];
        }
        else
        {
            [tempStr appendString:[NSString stringWithFormat:@"%c", [ccbName characterAtIndex:i]]];
        }
    }
    
    [tempStr appendString:[ccbName substringFromIndex:[ccbName length] - 1]];
    [tempStr appendString:@".plist"];
    return tempStr;
}

#pragma mark - 查找并复制相关的ccb文件
void ccbOpration()
{
    //读取用notepad++再代码中查找到得ccbi文件信息
    NSString* str = [NSString stringWithContentsOfFile:@"/Users/Benster/Desktop/CCBTest/CCBTest/ccbi/ccbi.txt" encoding:NSUTF8StringEncoding error:nil];
    
    //把字符串按行数转为数组
    NSArray* arr = [str componentsSeparatedByString:@"\n"];
    NSMutableArray* arr1 = [[NSMutableArray alloc] init];
    
    //查找具体的ccb文件 并存入数组
    for (NSUInteger i = 0; i < [arr count]; i ++) {
        NSUInteger location = [arr[i] rangeOfString:@"ccb/"].location;
        NSUInteger length = [arr[i] rangeOfString:@".ccbi\","].location;
        
        //判断查找的位置是否存在 判断节点中间是否有数据
        if (location != 9223372036854775807 && length != 9223372036854775807 && length - location - 8 > 0) {
            NSString* tem = [arr[i] substringWithRange:NSMakeRange(location+4, length - location)];
            [arr1 addObject:tem];
        }
    }
    
    //去掉重复的ccb文件
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    for (NSString* item in arr1) {
        [dict setObject:item forKey:item];
    }
    
    //把去掉重复数据的ccb文件 存入数组
    [arr1 removeAllObjects];
    
    for (NSString* item in [dict allKeys]) {
        [arr1 addObject:item];
    }
    
    //按照数组中的ccb文件 复制到相关目录
    for (NSString* item in arr1) {
        copyToPath(@"/Users/Benster/Desktop/Works/乐多/仙魔录花千骨/md2_res_src2/ccb/Resources2", [NSString stringWithFormat:@"/Users/Benster/Desktop/Works/乐多/仙魔录花千骨/md2_res_src2/ccb/Resources/%@", item], item, NO);
    }
    
    //保存要用到的ccb 文件列表
    [arr1 writeToFile:@"/Users/Benster/Desktop/CCBTest/CCBTest/ccbi/程序中用到的ccb文件.txt" atomically:NO];
    
    //保存复制未成功的cbb文件
    [errorInfo writeToFile:@"/Users/Benster/Desktop/CCBTest/CCBTest/ccbi/ccbCopyError.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - 替换ccb文件中得plist文件
void ccbPlistReplace(NSString* fileURL, NSString* fileName)
{
    NSString* str = [NSString stringWithContentsOfFile:fileURL encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arr = [[str componentsSeparatedByString:@"\n"] mutableCopy];
    NSMutableString* fileInfo = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < [arr count]; i ++) {
        //查找"<string>"位置
        NSUInteger location = [arr[i] rangeOfString:@"<string>"].location;
        NSUInteger length = [arr[i] rangeOfString:@"</string>"].location;
        
        //判断查找的位置是否存在 判断节点中间是否有数据
        if (location != 9223372036854775807 && length != 9223372036854775807 && length - location - 8 > 0) {
            //截取节点之间plist文件名
            NSString* tem1 = [arr[i] substringWithRange:NSMakeRange(location + 8, length-location-8)];
            
            //查找图片
            NSUInteger location2 = [tem1 rangeOfString:@".plist"].location;
            
            //PNG图片的节点
            NSUInteger location3 = [arr[i+1] rangeOfString:@"<string>"].location;
            NSUInteger length3 = [arr[i+1] rangeOfString:@"</string>"].location;
            
            //判断是否存在plist文件
            if (location2 != 9223372036854775807) {
                [fileInfo appendString:[NSString stringWithFormat:@"%@ccb_res/", [arr[i] substringToIndex:location + 8]]];
                
                NSString* plistName = [NSMutableString stringWithFormat:@"%@.plist</string>\n", fileName];
                NSString* pngName = [arr[i+1] substringWithRange:NSMakeRange(location3 + 8, length3-location3-8)];
                
                if ([[fileUseRate allKeys] containsObject:pngName]) {
                    plistName = [NSMutableString stringWithFormat:@"share.plist</string>\n"];
                }
                
                [fileInfo appendString:plistName];
            }
            else
            {
                [fileInfo appendString:[NSMutableString stringWithFormat:@"%@\n", arr[i]]];
            }
        }
        else
        {
            [fileInfo appendString:[NSMutableString stringWithFormat:@"%@\n", arr[i]]];
        }
    }
    
    [fileInfo writeToFile:[NSString stringWithFormat:@"%@/%@.ccb", ccbPath, fileName] atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - 比较ccb文件
NSMutableDictionary* comparisonSrc(NSMutableDictionary* dict, NSDictionary* dict2)
{
    NSMutableDictionary* comparisonStcTemp = [[NSMutableDictionary alloc] init];
    
    for (NSString* item in [dict allKeys]) {
        NSMutableArray* addSrc = [[NSMutableArray alloc] init];
        NSMutableArray* removeSrc = [[NSMutableArray alloc] init];
        NSString* ccbName = [item stringByAppendingString:@".ccb"];
        
        if (nil == [dict objectForKey:item] && nil == [dict2 objectForKey:ccbName]) {
            continue;
        }
        
        //添加的文件
        for (NSString* item1 in [dict objectForKey:item]) {
            if (![[dict2 objectForKey:ccbName] containsObject:item1]) {
                [addSrc addObject:item1];
            }
        }
        
        if ([addSrc count] > 0) {
            [comparisonStcTemp setObject:addSrc forKey:[ccbName stringByAppendingString:@"新增的资源文件"]];
        }
        
        //判断是否有新增的ccb
        if (![[dict2 allKeys] containsObject:ccbName]) {
            [comparisonStcTemp setObject:@"新增ccb文件" forKey:ccbName];
            continue;
        }
        
        //删除的文件
        for (NSString* item1 in [dict2 objectForKey:ccbName]) {
            if (![[dict objectForKey:item] containsObject:item1]) {
                [removeSrc addObject:item1];
            }
        }
        
        if ([removeSrc count] > 0) {
            [comparisonStcTemp setObject:removeSrc forKey:[ccbName stringByAppendingString:@"删除的资源文件"]];
        }
    }
    
    
    return comparisonStcTemp;
}

#pragma mark - 读取mydp文件
NSArray* getMydpName(NSString* pathName)
{
    NSString* fileSources = [NSString stringWithContentsOfFile:pathName encoding:NSUTF8StringEncoding error:nil];
    NSArray* arr = [fileSources componentsSeparatedByString:@"\n"];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSMutableArray* mydpList = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < [arr count]; i ++) {
        NSString* cell = arr[i];
        
        NSUInteger isFind = [cell rangeOfString:@"AddHrMenuItem(\""].location;
        NSUInteger isFind1 = [cell rangeOfString:@"AddStaticMenuItem(\""].location;
        
        if (9223372036854775807 != isFind || 9223372036854775807 != isFind1) {
            NSArray* arrTemp = [cell componentsSeparatedByString:@","];
            for (NSString* item in arrTemp) {
                NSUInteger location = [item rangeOfString:@".mydp"].location;
                if (9223372036854775807 != location) {
                    NSUInteger start = [item rangeOfString:@"\""].location + 1;
                    NSUInteger end =  [item rangeOfString:@".mydp"].location - start;
                    NSString* mydpName = [item substringWithRange:NSMakeRange(start, end)];
                    
                    //判断是否还有下级目录
                    NSUInteger isSlashLeft = [mydpName rangeOfString:@"/"].location;
                    NSUInteger isSlashRight = [mydpName rangeOfString:@"\\"].location;
                    if (9223372036854775807 == isSlashLeft && 9223372036854775807 == isSlashRight)
                    {
                        [dict setObject:mydpName forKey:[mydpName stringByAppendingString:@".png"]];
                    }
                }
            }
            continue;
        }
        
        
        NSUInteger location = [cell rangeOfString:@".mydp\""].location;
        
        if (9223372036854775807 != location) {
            NSUInteger start = [cell rangeOfString:@"(\""].location + 2;
            NSInteger end = location - start;
            NSString* mydpName = [cell substringWithRange:NSMakeRange(start, end)];
            
            //判断是否还有下级目录
            NSUInteger isSlashLeft = [mydpName rangeOfString:@"/"].location;
            NSUInteger isSlashRight = [mydpName rangeOfString:@"\\"].location;
            if (9223372036854775807 == isSlashLeft && 9223372036854775807 == isSlashRight)
            {
                [dict setObject:mydpName forKey:[mydpName stringByAppendingString:@".png"]];
            }
        }
    }
    
    //判断程序中加载的资源在ccb中是否存在
    for (NSString* item in [dict allKeys]) {
        //if (![pngList containsObject:item]) {
        [mydpList addObject:item];
        //}
    }
    
    //复制资源到program_load目录
    for (NSString* item in mydpList) {
        copyToPath([NSString stringWithFormat:@"%@program_load", resDescPath], [NSString stringWithFormat:@"%@%@", resSourcePath, item], item, NO);
    }
    
    NSLog(@"%@\n%lu", mydpList, [mydpList count]);
    
    return mydpList;
}

@end
