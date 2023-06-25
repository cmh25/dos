//screen.h  - for svga mode 103h 800x600 256 color

//page0 y=y+144
//page1 y=y+480
//split screen is 144 scan lines
//each page is 336 scan lines
                       
#ifndef SCREEN_H
#define SCREEN_H
                       
#include "scmhgrfx.h"

class CScreen
{ 
    private:
        short m_Color; 
        short m_Current_page;
        
    public:
        CScreen();
        ~CScreen();
        void Swap();
        void DrawLine(short x1,short y1,short x2,short y2);        
        void DrawPixel(short x,short y);
        void DrawTriangle(short x1,short y1,short x2,short y2,short x3,short y3);
        void SetColor(short color);
};

#endif
