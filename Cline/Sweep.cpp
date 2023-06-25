//Sweep.cpp

#include "cline.h"
#include <stdio.h>
#include <conio.h>

int main()
{              
    short color=0;  
    SetMode(18);
    getchar();
    for(;;)
    {
        for(color=0;color<16;color++)
        {
            CLine* pline=new CLine(0,0,639,0,color);
            pline->Draw();
            pline->Sweep(480,640);
            delete pline;  
            if(kbhit())
            {
                SetMode(3);
                return 0;
            }
        }
    }
}

