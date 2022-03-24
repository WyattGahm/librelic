#import <Foundation/Foundation.h>
#include "../relicwrapper.m"
#include "SCNMessagingMessage.h"


static BOOL (*orig_savehax)(id self, SEL _cmd);
BOOL savehax(id self, SEL _cmd){
    if([self messageType] == 18){
        NSLog(@"Saving Message...");
        return true;
    }
    return orig_savehax(self, _cmd);
}

static void (*orig_snapghost)(id self, SEL _cmd, long long arg1, id arg2, long long arg3, id arg4);
static void snapghost(id self, SEL _cmd, long long arg1, id arg2, long long arg3, id arg4){
    NSLog(@"Hello, you opened a snap!");
    orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
}



%ctor {
    NSLog(@"RelicLoader Active :) if you arent no5up or kanji wyd bro");
    RelicHookMessageEx(%c(SCNMessagingMessage), @selector(isSaved), (void*)savehax, &orig_savehax);
    RelicHookMessageEx(%c(SCNMessagingSnapManager), @selector(onSnapInteraction:conversationId:messageId:callback:), (void *)snapghost, &orig_snapghost);
}
