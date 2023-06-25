//Cline.h

//class definition for line class using cmhgrfx.lib

#include "cmhgrfx.h"

class CLine               
{ 
    private:
        short m_x1;
        short m_y1;
        short m_x2;
        short m_y2;
        short m_color;
        
    public:
        void Draw();
        void Sweep(short,short);                          
        CLine(short,short,short,short,short);
};
