//scmhgrfx.h

#ifndef SCMHGRFX_H
#define SCMHGRFX_H  

extern "C"
{
	void SetMode(short mode);
	void SetStartAddr(short scanline);
	void Pixel(short x,short y,short color);
	void Line(short xstart,short ystart,short xend,short yend,short color); 
	void Triangle(short x1,short y1,short x2,short y2,short x3,short y3,short color); 
	void Fill(short x,short y,short color);
}

#endif
