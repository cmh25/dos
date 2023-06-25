//screen.h 

//page0 y=y+144
//page1 y=y+480
//split screen is 144 scan lines
//each page is 336 scan lines
                       
#ifndef SCREEN_H
#define SCREEN_H
                       
#include "cmhgrfx.h"

class CScreen
{ 
    private:
        short m_Color; 
        short m_Current_page;
        
    public:
        CScreen();
        ~CScreen();
        void Swap();
        void DrawLine(short x1,short y1,short x2,short y2,short color);  
        void DrawCircle(short xcenter,short ycenter,short radius,short color);
        void DrawEllipse(short xcenter,short ycenter,short xrad,short yrad,short color);
        void DrawPixel(short x,short y,short color);
        void DrawPutChar(short x,short y,short character,short color); 
        void DrawTriangle(short x1,short y1,short x2,short y2,short x3,short y3,short color);      
        
        void FillSplitScreen(short color);
        void FillPage0(short color);
        void FillPage1(short color);
        void FillAll(short color);
        void SetColor(short color);
};

#endif

