//------------------------------------------------------------
//                         cmhgrfx.h
//                          10-15-98
//------------------------------------------------------------

extern "C" 
{
	void Line(short xstart,short ystart,short xend,short yend,short color);
	void Circle(short xcenter,short ycenter,short radius,short color);
	void Ellipse(short xcenter,short ycenter,short xrad,short yrad, short color);
	void SetMode(short mode);
	//void Poly(short color,short argcount,);
	//void Fpoly(short color,short count,short* line_list_ptr,);
	void Fill(short address,short bytecount,short color);
	void Pixel(short x,short y,short color);
	void PutChar(short x,short y,short character,short color);
	void SetSplitScreen(short scanline);
	void SetStartAddr(short start_addr); 
}
