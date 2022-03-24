#ifndef RELIC_H
#define RELIC_H

#include <objc/objc.h>

#if __cplusplus
extern "C" {
#endif

void RelicHookMessageEx(Class cls, SEL sel, void * replacement);
void RelicUnhookMessageEx(Class cls, SEL sel);

#if __cplusplus
}
#endif

#endif
