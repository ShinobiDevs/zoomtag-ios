//
//  MBLog.h
//  picloc
//
//  Created by Miki Bergin on 5/18/13.
//  Copyright (c) 2013 Miki Bergin. All rights reserved.
//

#ifndef picloc_MBLog_h
#define picloc_MBLog_h

#if defined(DEBUG) || defined(ADHOC)
#define MBLog(a...) NSLog(a)
#else
#define MBLog(a...)
#endif

#endif
