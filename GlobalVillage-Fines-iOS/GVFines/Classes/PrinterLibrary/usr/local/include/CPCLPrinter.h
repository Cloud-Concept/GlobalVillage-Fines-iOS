//
//  CPCLPrinter.h
//  iOS
//
//  Created by leesk on 12. 1. 10..
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

// CPCL Status
#define STS_CPCL_BATTERY_LOW	  8 
#define STS_CPCL_COVER_OPEN		  4 
#define STS_CPCL_PAPER_EMPTY	  2 
#define STS_CPCL_BUSY 			  1 
#define STS_CPCL_NORMAL			  0 

// Unit
#define CPCL_INCH    0 
#define CPCL_CENTI   1 
#define CPCL_MILLI   2 
#define CPCL_DOTS    3 

// Justification
#define CPCL_LEFT     0 
#define CPCL_CENTER   1 
#define CPCL_RIGHT    2 

// Text Rotation
#define CPCL_NO_ROTATION    0 
#define CPCL_0_ROTATION     0 
#define CPCL_90_ROTATION    1 
#define CPCL_180_ROTATION   2 
#define CPCL_270_ROTATION   3 

// Concatenation
/** It concatenates text as horizontal */
#define CPCL_CONCAT    0  
/** It concatenates text as vertical */
#define CPCL_VCONCAT   1 

// Media Type
/**  Label with Gap. */
#define CPCL_LABEL 		  0 
/**  Label with Black Mark. */
#define CPCL_BLACKMARK    1 
/**  Continuous Label. */
#define CPCL_CONTINUOUS   2 

// Ratio
/** Set up width ratio */
#define CPCL_TXT_1WIDTH		1 
#define CPCL_TXT_2WIDTH		2 
#define CPCL_TXT_3WIDTH		3 
#define CPCL_TXT_4WIDTH		4 
#define CPCL_TXT_5WIDTH		5 
#define CPCL_TXT_6WIDTH		6 
#define CPCL_TXT_7WIDTH		7 
#define CPCL_TXT_8WIDTH		8 
#define CPCL_TXT_9WIDTH		9 
#define CPCL_TXT_10WIDTH    10 
#define CPCL_TXT_11WIDTH    11 
#define CPCL_TXT_12WIDTH    12 
#define CPCL_TXT_13WIDTH    13 
#define CPCL_TXT_14WIDTH    14 
#define CPCL_TXT_15WIDTH    15 
#define CPCL_TXT_16WIDTH    16  

// Height Ratio
/** Set up height ratio */
#define CPCL_TXT_1HEIGHT	1 
#define CPCL_TXT_2HEIGHT	2 
#define CPCL_TXT_3HEIGHT	3 
#define CPCL_TXT_4HEIGHT	4 
#define CPCL_TXT_5HEIGHT	5 
#define CPCL_TXT_6HEIGHT	6 
#define CPCL_TXT_7HEIGHT	7 
#define CPCL_TXT_8HEIGHT	8 
#define CPCL_TXT_9HEIGHT	9 
#define CPCL_TXT_10HEIGHT   10 
#define CPCL_TXT_11HEIGHT   11 
#define CPCL_TXT_12HEIGHT   12 
#define CPCL_TXT_13HEIGHT   13 
#define CPCL_TXT_14HEIGHT   14 
#define CPCL_TXT_15HEIGHT   15 
#define CPCL_TXT_16HEIGHT   16 

// Barcode Types
extern NSString * const CPCL_BCS_39;
extern NSString * const CPCL_BCS_39C; 
extern NSString * const CPCL_BCS_39F;  	
extern NSString * const CPCL_BCS_39FC;  	
extern NSString * const CPCL_BCS_93; 	
extern NSString * const CPCL_BCS_128; 	
extern NSString * const CPCL_BCS_EAN128;  
extern NSString * const CPCL_BCS_CODABAR;  
extern NSString * const CPCL_BCS_CODABARC;  
extern NSString * const CPCL_BCS_EAN8; 
extern NSString * const CPCL_BCS_EAN82; 
extern NSString * const CPCL_BCS_EAN85;  
extern NSString * const CPCL_BCS_EAN13;  
extern NSString * const CPCL_BCS_EAN132;  
extern NSString * const CPCL_BCS_EAN135;  
extern NSString * const CPCL_BCS_I2OF5;  
extern NSString * const CPCL_BCS_POSTNET;  
extern NSString * const CPCL_BCS_UPCA; 
extern NSString * const CPCL_BCS_UPCA2;  
extern NSString * const CPCL_BCS_UPCA5;  
extern NSString * const CPCL_BCS_UPCE;  
extern NSString * const CPCL_BCS_UPCE2;  
extern NSString * const CPCL_BCS_UPCE5;  
extern NSString * const CPCL_BCS_MSI; 
extern NSString * const CPCL_BCS_MSI1C;  
extern NSString * const CPCL_BCS_MSI2C;
extern NSString * const CPCL_BCS_MSI11C;  

// Barcode Ratio
/** Set up the barcode ratio as 1.5 : 1. */
#define CPCL_BCS_0RATIO   0  
/** Set up the barcode ratio as 2.0 : 1. */
#define CPCL_BCS_1RATIO   1  
/** Set up the barcode ratio as 2.5 : 1. */
#define CPCL_BCS_2RATIO   2  
/** Set up the barcode ratio as 3.0 : 1. */
#define CPCL_BCS_3RATIO   3  
/** Set up the barcode ratio as 3.5 : 1. */
#define CPCL_BCS_4RATIO   4  
/** Set up the barcode ratio as 2.0 : 1. */
#define CPCL_BCS_20RATIO   5  
/** Set up the barcode ratio as 2.1 : 1. */
#define CPCL_BCS_21RATIO   6 
/** Set up the barcode ratio as 2.2 : 1. */
#define CPCL_BCS_22RATIO   7  
/** Set up the barcode ratio as 2.3 : 1. */
#define CPCL_BCS_23RATIO   8  
/** Set up the barcode ratio as 2.4 : 1. */
#define CPCL_BCS_24RATIO   9  
/** Set up the barcode ratio as 2.5 : 1. */
#define CPCL_BCS_25RATIO   10  
/** Set up the barcode ratio as 2.6 : 1. */
#define CPCL_BCS_26RATIO   11  
/** Set up the barcode ratio as 2.7 : 1. */
#define CPCL_BCS_27RATIO   12  
/** Set up the barcode ratio as 2.8 : 1. */
#define CPCL_BCS_28RATIO   13  
/** Set up the barcode ratio as 2.9 : 1. */
#define CPCL_BCS_29RATIO   14  
/** Set up the barcode ratio as 3.0 : 1. */
#define CPCL_BCS_30RATIO   15  

// Pattern
/** Filled(Black/default value) */
#define CPCL_DEFAULT_PATTERN    100  
/** It prints the pattern as a horizontal line. */
#define CPCL_HORIZON_PATTERN    101 
/** It prints the pattern as a vertical line. */
#define CPCL_VERTICAL_PATTERN   102 
/** It prints the diagonal pattern to the right. */
#define CPCL_RDIAGON_PATTERN    103 
/** It prints the diagonal pattern to the left. */
#define CPCL_LDIAGON_PATTERN    104 
/** It prints the pattern as a square. */
#define CPCL_SQUARE_PATTERN     105 
/** It prints the pattern as a diagonal line to right and left. */
#define CPCL_CROSS_PATTERN      106 

// Tone
/** Set up as default. */
#define CPCL_CONT_DEFAULT  	  0 
/** Print as middle brightness. */
#define CPCL_CONT_MEDIUM  	  1  
/** Print as dark. */
#define CPCL_CONT_DARK 		  2 
/** Print as very dark. */
#define CPCL_CONT_VERY_DARK   3 

// 2D Barcode
extern NSString * const CPCL_BCS_PDF417; 
extern NSString * const CPCL_BCS_MAXICODE;
extern NSString * const CPCL_BCS_QRCODE;
extern NSString * const CPCL_BCS_DATAMATRIX;

extern NSString * const CPCL_BCS_RSS14;
extern NSString * const CPCL_BCS_RSS14STACK;
extern NSString * const CPCL_BCS_RSS14STACK_OMNI;
extern NSString * const CPCL_BCS_RSS_LTD;
extern NSString * const CPCL_BCS_RSS_EXP;
extern NSString * const CPCL_BCS_RSS_EXPSTACK;

// Text Font
#define CPCL_FONT_0   0 
#define CPCL_FONT_1   1 
#define CPCL_FONT_2   2 
#define CPCL_FONT_4   4 
#define CPCL_FONT_5   5 
#define CPCL_FONT_6   6 	
#define CPCL_FONT_7   7 

// Country Command Parameters.
extern NSString * const CPCL_COUNTRY_USA;
extern NSString * const CPCL_COUNTRY_GERMANY;
extern NSString * const CPCL_COUNTRY_FRANCE;
extern NSString * const CPCL_COUNTRY_SWEDEN; 
extern NSString * const CPCL_COUNTRY_SPAIN;
extern NSString * const CPCL_COUNTRY_NORWAY;
extern NSString * const CPCL_COUNTRY_ITALY;
extern NSString * const CPCL_COUNTRY_UK;
extern NSString * const CPCL_COUNTRY_CP850;
extern NSString * const CPCL_COUNTRY_LATIN9;



@interface CPCLPrinter : NSObject 
{
	NSStringEncoding encoding;
}

@property (nonatomic) NSStringEncoding encoding;

- (int) openPort:(NSString*)portName withPortParam:(int) port;
- (int) closePort;

// CPCL Command methods.
- (int) setForm:(int) horizonOffset withResX:(int) resolX withResY:(int) resolY withLabelHeight:(int) labelHeight withQuantity:(int) quantity;
- (int) printForm;
- (int) printerCheck;
- (int) status;
- (int) setMeasure:(int) measure;
- (int) setJustification:(int) justify;

- (int) printCPCLText:(int) rotation withFontType:(int) fontType withFontSize:(int) fontSize withPrintX:(int) printX withPrintY:(int) printY 
			 withData:(NSString *) data withCount:(int) count;

- (int) setConcat:(int) contcatMode withPrintX:(int) printX withPrintY:(int) printY;
- (int) concatText:(int) fontType withFontSize:(int) fontSize withOffset:(int) offset withData:(NSString *) data;
- (int) resetConcat;
- (int) setMultiLine:(int) lineHeight;
- (int) multiLineText:(int) rotation withFontType:(int) fontType withFontSize:(int) fontSize withPrintX:(int) printX withPrintY:(int) printY;
- (int) multiLineData:(NSString *) data;
- (int) resetMultiLine;
- (int) setMagnify:(int) width withHeight:(int) height;
- (int) resetMagnify;

- (int) printCPCLBarcode:(int) rotation withBarcodeType:(NSString *) barcodeType withNarrowBar:(int) NB withRatio:(int) ratio 
		   withBarHeight:(int) barHeight withPrintX:(int) printX withPrintY:(int) printY withData:(NSString *) data withCount:(int) count;

- (int) printBox:(int) xs withYs:(int) ys withXx:(int) xx withYX:(int) yx withThickness:(int) thickness;
- (int) printLine:(int) xs withYs:(int) ys withXx:(int) xx withYx:(int) yx withThickness:(int) thickness;
- (int) inverseLine:(int) xs withYs:(int) ys withXx:(int) xx withYx:(int) yx withThickness:(int) thickness;
- (int) setPattern:(int) patternNum;
- (int) printBitmap:(NSString *) filePath withPrintX:(int) printX withPrintY:(int) printY withBrightness:(int) bright;
- (int) setContrast:(int) darkness;
- (int) setPageWidth:(int) pageWidth;
- (int) printCPCLImage:(NSString *) imageName withPrintX:(int) printX withPrintY:(int) printY;
- (int) setSpeed:(int) speed;
- (int) setTone:(int) tone;
- (int) setCPCLBarcode:(int) fontNum withFontSize:(int) fontSize withOffset:(int) offset;

- (int) setMedia:(int) mode;
- (int) setCountry:(NSString *) country;
- (int) resetCountry;

// 2D Barcode
- (void) printPDF417:(int) rotation withPrintX:(int) printX withPrintY:(int) printY withUnitWidth:(int) unitWidth withUnitHeight:(int) unitHeight 
	withNumOfColumns:(int) column withSecurityLevel:(int) securityLevel withData:(NSString *) data;

- (void) printDATAMATRIX:(int) rotation withPrintX:(int) printX withPrintY:(int) printY withECCLevel:(int) eccLevel withCellSize:(int) cellSize 
				withData:(NSString *) data;

- (void) printQRCODE:(int) rotation withPrintX:(int) printX withPrintY:(int) printY withVersion:(int) version withECLevel:(int) ecLevel 
	  withModuleSize:(int) moduleSize withMaskNo:(int) maskNo withData:(NSString *) data;

- (void) printGS1:(int) rotation withType:(NSString *) type withModuleWidth:(int) moduleWidth withHeight:(int) height withPrintX:(int) printX withPrintY:(int) printY 
		 withData:(NSString *) data;

@end