
;CodeVisionAVR C Compiler V2.03.9 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width
;(s)scanf features      : long, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _dev_type=R6
	.DEF _dev_num=R9
	.DEF _motor_cmd=R8
	.DEF _servo_cmd=R11
	.DEF _direction=R10
	.DEF _ret=R13
	.DEF _servo_poz=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_motd:
	.DB  0x53,0x79,0x73,0x74,0x65,0x6D,0x20,0x73
	.DB  0x74,0x61,0x72,0x74,0x65,0x64,0xA,0xD
	.DB  0x52,0x65,0x61,0x64,0x79,0x20,0x66,0x6F
	.DB  0x72,0x20,0x77,0x6F,0x72,0x6B,0xA,0xD
	.DB  0x0
_err_dev_num:
	.DB  0xA,0xD,0x45,0x72,0x72,0x6F,0x72,0x3A
	.DB  0x20,0x49,0x6E,0x76,0x61,0x6C,0x69,0x64
	.DB  0x20,0x64,0x65,0x76,0x69,0x63,0x65,0x20
	.DB  0x6E,0x75,0x6D,0x62,0x65,0x72,0x3A,0x20
	.DB  0x0
_err_dev_val:
	.DB  0xA,0xD,0x45,0x72,0x72,0x6F,0x72,0x3A
	.DB  0x20,0x49,0x6E,0x76,0x61,0x6C,0x69,0x64
	.DB  0x20,0x64,0x65,0x76,0x69,0x63,0x65,0x20
	.DB  0x76,0x61,0x6C,0x75,0x65,0x3A,0x20,0x0
_err_dev_max_val:
	.DB  0xA,0xD,0x45,0x72,0x72,0x6F,0x72,0x3A
	.DB  0x20,0x44,0x65,0x76,0x69,0x63,0x65,0x20
	.DB  0x76,0x61,0x6C,0x75,0x65,0x20,0x69,0x73
	.DB  0x20,0x6F,0x75,0x74,0x20,0x6F,0x66,0x20
	.DB  0x72,0x61,0x6E,0x67,0x65,0x3A,0x20,0x0
_err_dev_mot_cmd:
	.DB  0xA,0xD,0x45,0x72,0x72,0x6F,0x72,0x3A
	.DB  0x20,0x49,0x6E,0x76,0x61,0x6C,0x69,0x64
	.DB  0x20,0x63,0x6F,0x6D,0x6D,0x61,0x6E,0x64
	.DB  0x20,0x66,0x6F,0x72,0x20,0x74,0x68,0x65
	.DB  0x20,0x64,0x65,0x76,0x69,0x63,0x65,0x20
	.DB  0x6D,0x6F,0x74,0x6F,0x72,0x3A,0x20,0x0
_err_dev_serv_cmd:
	.DB  0xA,0xD,0x45,0x72,0x72,0x6F,0x72,0x3A
	.DB  0x20,0x49,0x6E,0x76,0x61,0x6C,0x69,0x64
	.DB  0x20,0x63,0x6F,0x6D,0x6D,0x61,0x6E,0x64
	.DB  0x20,0x66,0x6F,0x72,0x20,0x74,0x68,0x65
	.DB  0x20,0x64,0x65,0x76,0x69,0x63,0x65,0x20
	.DB  0x73,0x65,0x72,0x76,0x6F,0x3A,0x20,0x0
_mystring:
	.DB  0x74,0x65,0x73,0x74,0x0
_pb_state:
	.DB  0x1,0x0

_0x3:
	.DB  0x0,0x7F
_0x4:
	.DB  0x20,0x4E
_0x5:
	.DB  0xE,0x2B,0x39,0x47,0x56,0x5D,0x64,0x7
	.DB  0x2B,0x47,0x64,0x64,0x64,0x64,0x7,0x32
	.DB  0x5D,0x64,0x64,0x64,0x64,0x7,0x32,0x39
	.DB  0x64,0x64,0x64,0x64,0x1D,0x1D,0x1D,0x1D
	.DB  0x39,0x4F,0x64,0x24,0x24,0x24,0x24,0x47
	.DB  0x5D,0x64,0x24,0x24,0x24,0x24,0x47,0x4F
	.DB  0x64
_0x6D:
	.DB  0x0,0x0,0x0,0x7F
_0x0:
	.DB  0x66,0x69,0x6C,0x6C,0x20,0x62,0x75,0x66
	.DB  0xA,0xD,0x0,0x62,0x75,0x66,0x3A,0xA
	.DB  0xD,0x0,0x25,0x63,0x0,0x30,0x78,0x25
	.DB  0x78,0x0,0x61,0x63,0x63,0x65,0x6C,0xA
	.DB  0xD,0x0,0x62,0x72,0x61,0x6B,0x65,0xA
	.DB  0xD,0x0,0x73,0x65,0x72,0x76,0x6F,0x5F
	.DB  0x73,0x74,0x65,0x65,0x72,0x3D,0x25,0x64
	.DB  0xA,0xD,0x0,0x72,0x65,0x76,0x65,0x72
	.DB  0x73,0x65,0xA,0xD,0x0,0x63,0x6D,0x64
	.DB  0x3A,0x20,0x73,0x74,0x6F,0x70,0xA,0xD
	.DB  0x0,0x63,0x6D,0x64,0x3A,0x20,0x66,0x6F
	.DB  0x72,0x77,0x61,0x72,0x64,0xA,0xD,0x0
	.DB  0x63,0x6D,0x64,0x3A,0x20,0x66,0x6F,0x72
	.DB  0x77,0x61,0x72,0x64,0x2D,0x72,0x69,0x67
	.DB  0x68,0x74,0xA,0xD,0x0,0x63,0x6D,0x64
	.DB  0x3A,0x20,0x66,0x6F,0x72,0x77,0x61,0x72
	.DB  0x64,0x2D,0x6C,0x65,0x66,0x74,0xA,0xD
	.DB  0x0,0x63,0x6D,0x64,0x3A,0x20,0x62,0x61
	.DB  0x63,0x6B,0x77,0x61,0x72,0x64,0xA,0xD
	.DB  0x0,0x63,0x6D,0x64,0x3A,0x20,0x62,0x61
	.DB  0x63,0x6B,0x77,0x61,0x72,0x64,0x2D,0x72
	.DB  0x69,0x67,0x68,0x74,0xA,0xD,0x0,0x63
	.DB  0x6D,0x64,0x3A,0x20,0x62,0x61,0x63,0x6B
	.DB  0x77,0x61,0x72,0x64,0x2D,0x6C,0x65,0x66
	.DB  0x74,0xA,0xD,0x0,0xA,0xD,0x43,0x4F
	.DB  0x4D,0x4D,0x41,0x4E,0x44,0xA,0xD,0x0
	.DB  0xA,0xD,0x4D,0x4F,0x54,0x4F,0x52,0xA
	.DB  0xD,0x0,0xA,0xD,0x41,0x43,0x43,0x45
	.DB  0x4C,0xA,0xD,0x0,0xA,0xD,0x42,0x52
	.DB  0x41,0x4B,0x45,0xA,0xD,0x0,0xA,0xD
	.DB  0x52,0x45,0x56,0x45,0x52,0x53,0x45,0xA
	.DB  0xD,0x0,0xA,0xD,0x50,0x4F,0x57,0x45
	.DB  0x52,0xA,0xD,0x0,0xA,0xD,0x56,0x61
	.DB  0x6C,0x75,0x65,0x3A,0x20,0x25,0x64,0xA
	.DB  0xD,0x0,0xA,0xD,0x53,0x45,0x52,0x56
	.DB  0x4F,0xA,0xD,0x0,0xA,0xD,0x41,0x4E
	.DB  0x47,0x4C,0x45,0xA,0xD,0x0,0xA,0xD
	.DB  0x54,0x45,0x53,0x54,0xA,0xD,0x0,0x31
	.DB  0xA,0xD,0x0,0x30,0xA,0xD,0x0
_0x20000:
	.DB  0x4D,0x4D,0x43,0x5F,0x49,0x6E,0x69,0x74
	.DB  0x3A,0x20,0x6D,0x6D,0x63,0x20,0x65,0x72
	.DB  0x72,0x6F,0x72,0xA,0xD,0x0,0x6D,0x6D
	.DB  0x63,0x5F,0x77,0x72,0x69,0x74,0x65,0x5F
	.DB  0x63,0x6F,0x6D,0x6D,0x61,0x6E,0x64,0x3A
	.DB  0x20,0x62,0x72,0x65,0x61,0x6B,0x20,0x66
	.DB  0x72,0x6F,0x6D,0x20,0x77,0x68,0x69,0x6C
	.DB  0x65,0xA,0xD,0x0,0x6D,0x6D,0x63,0x5F
	.DB  0x77,0x72,0x69,0x74,0x65,0x5F,0x73,0x65
	.DB  0x63,0x74,0x6F,0x72,0xA,0xD,0x0,0x6D
	.DB  0x6D,0x63,0x5F,0x72,0x65,0x61,0x64,0x5F
	.DB  0x62,0x6C,0x6F,0x63,0x6B,0xA,0xD,0x0
	.DB  0x6D,0x6D,0x63,0x5F,0x72,0x65,0x61,0x64
	.DB  0x5F,0x73,0x65,0x63,0x74,0x6F,0x72,0xA
	.DB  0xD,0x0,0x6D,0x6D,0x63,0x5F,0x72,0x65
	.DB  0x61,0x64,0x5F,0x63,0x69,0x64,0xA,0xD
	.DB  0x0,0x6D,0x6D,0x63,0x5F,0x72,0x65,0x61
	.DB  0x64,0x5F,0x63,0x73,0x64,0xA,0xD,0x0
_0x202005F:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _dev_val
	.DW  _0x3*2

	.DW  0x02
	.DW  _ctr_last
	.DW  _0x4*2

	.DW  0x31
	.DW  _p
	.DW  _0x5*2

	.DW  0x04
	.DW  0x09
	.DW  _0x6D*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x202005F*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;
;Project : Robot
;Version : 0.0.1
;Date    :
;Author  : RealSystem
;Comments: Based on http://avr123.nm.ru
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include "control_1.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Константы !  строки в памяти программ
;flash char motd[]="System started\n\rReady for work\n\r";
;//flash char err_low_volt[]="\n\rError: Low voltage, chargering needs: ";
;flash char err_dev_num[]="\n\rError: Invalid device number: ";
;flash char err_dev_val[]="\n\rError: Invalid device value: ";
;flash char err_dev_max_val[]="\n\rError: Device value is out of range: ";
;flash char err_dev_mot_cmd[]="\n\rError: Invalid command for the device motor: ";
;flash char err_dev_serv_cmd[]="\n\rError: Invalid command for the device servo: ";
;flash char mystring[] = "test";
;
;//USART vars
;u8 rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;    u8 rx_wr_index,rx_rd_index,rx_counter;
;#else
;    u16 rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;//MMC_SD vars
;u8 sector[512];
;
;//motor and servo vars
;u8 dev_val[DEV_COUNT]={0,127};

	.DSEG
;//input dev type(ascii)
;u8 dev_type;
;//0-motor
;//1-servo
;u8 dev_num = 0, motor_cmd, servo_cmd;
;//u8 pwm = 0; // Величина ШИМ начальная PWM в %
;s8 direction = 0;
;u8 ret; // переменная для разных нужд
;//u32 pwm_val; // для хранения величины ШИМ PWM в  1/1024
;u8 servo_poz = 127;
;u8 index_st = 0; //  индекс для работы в прерывании
;flash char pb_state[2]={
;0b00000001,  // "1" на servo на PB0
;0b00000000 };// "0" на всех servo
;
;u16  ctr_last  = 20000;
;// сколько мкС осталось досчитать до 20 мС
;
;u8 timer0_int_cnt;
;//счетчик переполнений Таймера0
;
;u8 timer0_pause_cnt;
;//счетчик пауз
;
;//Robot logic
;
;u8 p[7][7] =
;{
;    {14,	43,	    57,	    71,	    86,	    93,	    100},
;    {7,	    43,	    71,	    100,	100,	100,	100},
;    {7,	    50,	    93,	    100,	100,	100,	100},
;    {7,	    50,	    57,	    100,	100,	100,	100},
;    {29,	29,	    29,	    29,	    57,	    79,	    100},
;    {36,	36,	    36,	    36,	    71,	    93,	    100},
;    {36,	36,	    36,	    36,	    71,	    79,	    100},
;};
;
;u8 cur_move;
;
;enum {STOP, F, FR, FL, B, BR, BL};
;
;
;// RC5 vars
;u8 RC5flg;
;u8 RC5err;
;u8 RC5num;
;u8 RC5cnt;
;u8 RC5wrk;
;u8 RC5prg;
;
;u16 RC5inp;
;u16 RC5old;
;u16 RC5rcv;
;u16 RC5tmp;
;
;u8 RC5cnt0a;
;u8 RC5cnt1a;
;u8 RC5cnt0b;
;u8 RC5cnt1b;
;
;
;//++++++++++++++++++++++++++++++++++++++++++++++++
;
;//FUNCTIONS
;
;
;//SPI init
;void spi_init(void)
; 0000 0073 {

	.CSEG
; 0000 0074     TCCR0=0x00;
; 0000 0075     TCNT0=0x00;
; 0000 0076     TCCR1A=0x00;
; 0000 0077     TCCR1B=0x00;
; 0000 0078     TCNT1H=0x00;
; 0000 0079     TCNT1L=0x00;
; 0000 007A     ICR1H=0x00;
; 0000 007B     ICR1L=0x00;
; 0000 007C     OCR1A=0x00;
; 0000 007D     OCR1BH=0x00;
; 0000 007E     OCR1BL=0x00;
; 0000 007F 
; 0000 0080     ASSR=0x00;
; 0000 0081     TCCR2=0x00;
; 0000 0082     TCNT2=0x00;
; 0000 0083     OCR2=0x00;
; 0000 0084 
; 0000 0085 
; 0000 0086     DDRB = 0x2c;
; 0000 0087     SPCR = 0x53;
; 0000 0088     MMC_Enable();    // set chip select to low (MMC is selected)
; 0000 0089 }
;
;//timers init function
;void timer_init(void)
; 0000 008D {
_timer_init:
; 0000 008E // Timer/Counter 0 initialization
; 0000 008F // Clock source: System Clock
; 0000 0090 // Clock value: 7,813 kHz
; 0000 0091 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0092 TCNT0=0xF4;
	LDI  R30,LOW(244)
	OUT  0x32,R30
; 0000 0093 
; 0000 0094 //timer1 for servo
; 0000 0095 
; 0000 0096 // Timer/Counter 1 initialization
; 0000 0097 // Clock source: System Clock
; 0000 0098 // Clock value: 1000,000 kHz
; 0000 0099 // Mode: Normal top=FFFFh
; 0000 009A // OC1A output: Discon.
; 0000 009B // OC1B output: Discon.
; 0000 009C // Noise Canceler: Off
; 0000 009D // Input Capture on Falling Edge
; 0000 009E // Timer 1 Overflow Interrupt: Off
; 0000 009F // Input Capture Interrupt: Off
; 0000 00A0 // Compare A Match Interrupt: On
; 0000 00A1 // Compare B Match Interrupt: Off
; 0000 00A2 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00A3 TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 00A4 TCNT1H=0x00;
	RCALL SUBOPT_0x0
; 0000 00A5 TCNT1L=0x00;
; 0000 00A6 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00A7 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00A8 OCR1A=1496;
	LDI  R30,LOW(1496)
	LDI  R31,HIGH(1496)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00A9 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 00AA OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00AB 
; 0000 00AC //timer1 for motor - not use
; 0000 00AD 
; 0000 00AE // Timer/Counter 1 initialization
; 0000 00AF // Clock source: System Clock
; 0000 00B0 // Clock value: 8000,000 kHz
; 0000 00B1 // Mode: Fast PWM top=03FFh
; 0000 00B2 // OC1A output: Non-Inv.
; 0000 00B3 // OC1B output: Non-Inv.
; 0000 00B4 // Noise Canceler: Off
; 0000 00B5 // Input Capture on Falling Edge
; 0000 00B6 // Timer 1 Overflow Interrupt: Off
; 0000 00B7 // Input Capture Interrupt: Off
; 0000 00B8 // Compare A Match Interrupt: Off
; 0000 00B9 // Compare B Match Interrupt: Off
; 0000 00BA //TCCR1A=0xA3;
; 0000 00BB //TCCR1B=0x09;//9
; 0000 00BC 
; 0000 00BD /*
; 0000 00BE настройка таймера_1
; 0000 00BF TCCR1A=0xA3; // 1010 0011
; 0000 00C0 
; 0000 00C1 описание этого регистра на стр. 109 ДШ.
; 0000 00C2 Биты_7_6 влияют на  ШИМ на ножке PD5
; 0000 00C3 Биты_5_4 влияют на  ШИМ на ножке PD4
; 0000 00C4 Как влияют написано в таблице 45 ДШ
; 0000 00C5 
; 0000 00C6 Биты_1_0  совместно  с  битами_5_4
; 0000 00C7 регистра  TCCR1B  определяют
; 0000 00C8 режим работы ШИМ по таблице  47
; 0000 00C9 
; 0000 00CA У нас так :
; 0000 00CB TCCR1B=0x09; // 0000 1001
; 0000 00CC 
; 0000 00CD значит комбинация 4-х битов определяющая режим ШИМ такова:   0111
; 0000 00CE по таблице 47 это режим 7  - как мы и заказывали мастеру !
; 0000 00CF 
; 0000 00D0 Биты_2_0  регистра  TCCR1B  определяют коэф. деления источника
; 0000 00D1 тактового сигнала прежде чем он будет тикать таймер_1
; 0000 00D2 
; 0000 00D3 У нас это 001  по таблице 48  коэф. деления  1   - т.е. таймер_1
; 0000 00D4 считает с частотой кварца.
; 0000 00D5 */
; 0000 00D6 
; 0000 00D7 //TCNT1H=0x00;
; 0000 00D8 //TCNT1L=0x00;
; 0000 00D9 //ICR1H=0x00;
; 0000 00DA //ICR1L=0x00;
; 0000 00DB 
; 0000 00DC // +++++++++++++++++++++++++++++++++++++++++++++++
; 0000 00DD // установить величину ШИМ на PB1
; 0000 00DE //OCR1AH=0x00;
; 0000 00DF //OCR1AL=0x00;
; 0000 00E0 
; 0000 00E1 // +++++++++++++++++++++++++++++++++++++++++++++++
; 0000 00E2 // установить величину ШИМ на PB2
; 0000 00E3 //OCR1BH=0x00;
; 0000 00E4 //OCR1BL=0x00;
; 0000 00E5 
; 0000 00E6 /*     величина ШИМ в процентах равна частному от
; 0000 00E7    деления числа в 16-битном регистре OCR1xx  на 10.23  */
; 0000 00E8    // Timer/Counter 2 initialization
; 0000 00E9 // Clock source: System Clock
; 0000 00EA // Clock value: 8000,000 kHz
; 0000 00EB // Mode: Fast PWM top=FFh
; 0000 00EC // OC2 output: Non-Inverted PWM
; 0000 00ED ASSR=0x00;
	OUT  0x22,R30
; 0000 00EE TCCR2=0x69;
	LDI  R30,LOW(105)
	OUT  0x25,R30
; 0000 00EF TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00F0 OCR2=0x00;
	OUT  0x23,R30
; 0000 00F1 }
	RET
;
;//init function
;void init(void)
; 0000 00F5 {
_init:
; 0000 00F6 // Input/Output Ports initialization
; 0000 00F7 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00F8 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 00F9 
; 0000 00FA PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00FB DDRC=0x1F;
	LDI  R30,LOW(31)
	OUT  0x14,R30
; 0000 00FC 
; 0000 00FD // Port D initialization
; 0000 00FE PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00FF DDRD=0x00;
	OUT  0x11,R30
; 0000 0100 
; 0000 0101 // USART initialization
; 0000 0102 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0103 // USART Receiver: On
; 0000 0104 // USART Transmitter: On
; 0000 0105 // USART Mode: Asynchronous
; 0000 0106 // USART Baud rate: 38400
; 0000 0107 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0108 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0109 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 010A UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 010B UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 010C 
; 0000 010D 
; 0000 010E // External Interrupt(s) initialization
; 0000 010F // INT0: On
; 0000 0110 // INT0 Mode: Any change
; 0000 0111 // INT1: On
; 0000 0112 // INT1 Mode: Any change
; 0000 0113 GICR|=0xC0;
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0114 MCUCR=0x05;
	LDI  R30,LOW(5)
	OUT  0x35,R30
; 0000 0115 GIFR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0116 
; 0000 0117 /*
; 0000 0118 // External Interrupt(s) initialization
; 0000 0119 // INT0: On
; 0000 011A // INT0 Mode: Falling Edge
; 0000 011B // INT1: On
; 0000 011C // INT1 Mode: Falling Edge
; 0000 011D GICR|=0xC0;
; 0000 011E MCUCR=0x0A;
; 0000 011F GIFR=0xC0;
; 0000 0120 */
; 0000 0121 
; 0000 0122 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0123 TIMSK=0x11;
	LDI  R30,LOW(17)
	OUT  0x39,R30
; 0000 0124 
; 0000 0125 // Analog Comparator initialization
; 0000 0126 // Analog Comparator: Off
; 0000 0127 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0128 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0129 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 012A 
; 0000 012B // Global enable interrupts
; 0000 012C #asm("sei")
	sei
; 0000 012D }
	RET
;
;
;
;// Новая Функция getchar()
;#ifndef _printf_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;
;#pragma used+
;u8 getchar(void)
; 0000 0138 {
_getchar:
; 0000 0139     u8 data;
; 0000 013A 
; 0000 013B     while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 013C     data=rx_buffer[rx_rd_index];
	MOV  R30,R4
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 013D     if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R4
	LDI  R30,LOW(100)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 013E     #asm("cli")
_0x9:
	cli
; 0000 013F     --rx_counter;
	DEC  R7
; 0000 0140     #asm("sei")
	sei
; 0000 0141 
; 0000 0142     return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0143 }
;#pragma used-
;
;#endif
;
;void fillbuf(u8 *buf)     { // fill buffer sector with ASCII characters
; 0000 0148 void fillbuf(unsigned char     *buf)     {
; 0000 0149     u16 i, c = 0;
; 0000 014A 
; 0000 014B     printf("fill buf\n\r");
;	*buf -> Y+4
;	i -> R16,R17
;	c -> R18,R19
; 0000 014C     for (i=0; i<=512; i++) {
; 0000 014D         buf[i] = mystring[c];
; 0000 014E         c++;
; 0000 014F         if (c > 4) { c = 0; }
; 0000 0150     }
; 0000 0151 }
;
;
;void output_buf(u8 *buf, u8 num, u8 type)
; 0000 0155 {   //type=1 if char, type=0 if digit
; 0000 0156     u8 i;
; 0000 0157 
; 0000 0158     printf("buf:\n\r");
;	*buf -> Y+3
;	num -> Y+2
;	type -> Y+1
;	i -> R17
; 0000 0159     for (i = 0; i < num; i++)
; 0000 015A     {
; 0000 015B         if (type == 1) printf("%c", buf[i]);
; 0000 015C         else printf("0x%x", buf[i]);
; 0000 015D     }
; 0000 015E     printf("\n\r");
; 0000 015F }
;
;int power(int t, int k)
; 0000 0162 {
_power:
; 0000 0163     int res = 1;
; 0000 0164     while (k)
	RCALL __SAVELOCR2
;	t -> Y+4
;	k -> Y+2
;	res -> R16,R17
	__GETWRN 16,17,1
_0x13:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BREQ _0x15
; 0000 0165     {
; 0000 0166 	    if (k & 1) res *= t;
	ANDI R30,LOW(0x1)
	BREQ _0x16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	MOVW R26,R16
	RCALL __MULW12
	MOVW R16,R30
; 0000 0167 	    t *= t;
_0x16:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __MULW12
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0168 	    k >>= 1;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ASR  R31
	ROR  R30
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0169     }
	RJMP _0x13
_0x15:
; 0000 016A     return res;
	MOVW R30,R16
	RCALL __LOADLOCR2
	ADIW R28,6
	RET
; 0000 016B }
;
;/*
;//function for changing pwm
;void change_pwm(char new_pwm)
;{
;if (new_pwm > 102)
;{ //если ШИМ уже более 100 %
;     new_pwm = 0;  // обнулить величину ШИМ
;};
;
;pwm_val = ((1023 * (u32)new_pwm)/100);
;// перевели % в 1024-е доли
;// Вывод нового значение ШИМ в %  в USART
;//printf("PWM");
;
;// вывод в USART значения переменной pwm (число от 0 до 100)
;
;// вывод числа сотен
;
;temp = new_pwm/100;
;// целочисленное деление на 100 даст
;// нам число сотен в числе pwm
;
;if (temp)
;{   // если temp содержит не ноль, то нужно печатать количество сотен
;    //putchar(temp+48);
;}
;
;temp = new_pwm%100;
;
;// вывод числа десятков
;//putchar((temp/10) + 48);
;
;temp = temp%10;
;
;// вывод единиц
;//putchar(temp+48);
;
;// вывести в USART пробел и знак "проценты"
;//printf(" %\n\r");
;
;// pwm_val - это число от 0 до 1023
;// PWM(PB1) = OCR1A / 10.23  (%)
;OCR1AH = (char)(pwm_val>>8);
;OCR1AL = (char)pwm_val;
;
;}*/
;
;void accel(void)
; 0000 019D {
_accel:
; 0000 019E     printf("accel\n\r");
	__POINTW1FN _0x0,26
	RCALL SUBOPT_0x2
; 0000 019F     PORTC SET_B(0);
	SBI  0x15,0
; 0000 01A0     PORTC CLR_B(1);
	CBI  0x15,1
; 0000 01A1     while (dev_val[0] != MAX_PWM)
_0x17:
	LDS  R26,_dev_val
	CPI  R26,LOW(0xFE)
	BREQ _0x19
; 0000 01A2     {
; 0000 01A3         dev_val[0]++;
	RCALL SUBOPT_0x3
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x4
; 0000 01A4         OCR2 = dev_val[0];
; 0000 01A5         delay_us(ACCEL_DELAY);//FIXME
; 0000 01A6     }
	RJMP _0x17
_0x19:
; 0000 01A7 }
	RET
;
;void brake(void)
; 0000 01AA {
_brake:
; 0000 01AB     printf("brake\n\r");
	__POINTW1FN _0x0,34
	RCALL SUBOPT_0x2
; 0000 01AC     while (dev_val[0] != MIN_PWM)
_0x1A:
	RCALL SUBOPT_0x3
	CPI  R30,0
	BREQ _0x1C
; 0000 01AD     {
; 0000 01AE         dev_val[0]--;
	RCALL SUBOPT_0x3
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x4
; 0000 01AF         OCR2 = dev_val[0];
; 0000 01B0         delay_us(BRAKE_DELAY);//FIXME
; 0000 01B1     }
	RJMP _0x1A
_0x1C:
; 0000 01B2     PORTC CLR_B(0);
	CBI  0x15,0
; 0000 01B3     PORTC CLR_B(1);
	CBI  0x15,1
; 0000 01B4 }
	RET
;
;void test_servo(void)
; 0000 01B7 {
_test_servo:
; 0000 01B8     servo_poz = 0;
	CLR  R12
; 0000 01B9     delay_ms(500);
	RCALL SUBOPT_0x5
; 0000 01BA     servo_poz = 254;
	LDI  R30,LOW(254)
	MOV  R12,R30
; 0000 01BB     delay_ms(500);
	RCALL SUBOPT_0x5
; 0000 01BC     servo_poz = 127;
	LDI  R30,LOW(127)
	MOV  R12,R30
; 0000 01BD     delay_ms(500);
	RCALL SUBOPT_0x5
; 0000 01BE }
	RET
;
;void servo_steer(u8 poz, u8 step)
; 0000 01C1 {
; 0000 01C2     u8 i;
; 0000 01C3 
; 0000 01C4     if (servo_poz < poz)
;	poz -> Y+2
;	step -> Y+1
;	i -> R17
; 0000 01C5     do
; 0000 01C6     {
; 0000 01C7         servo_poz = servo_poz + step;
; 0000 01C8     } while (servo_poz < poz);
; 0000 01C9     else
; 0000 01CA     if (servo_poz > poz)
; 0000 01CB     do
; 0000 01CC     {
; 0000 01CD         servo_poz = servo_poz - step;
; 0000 01CE     } while (servo_poz > poz);
; 0000 01CF     else servo_poz = poz;
; 0000 01D0     printf("servo_steer=%d\n\r", servo_poz);
; 0000 01D1 }
;
;//function for reverse
;void reverse(void)
; 0000 01D5 {
_reverse:
; 0000 01D6     printf("reverse\n\r");
	__POINTW1FN _0x0,59
	RCALL SUBOPT_0x2
; 0000 01D7     if (direction == 1)
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x27
; 0000 01D8     {
; 0000 01D9         PORTC SET_B(0);
	SBI  0x15,0
; 0000 01DA         delay_us(REVERSE_DELAY);
	RCALL SUBOPT_0x6
; 0000 01DB         PORTC CLR_B(1);
	CBI  0x15,1
; 0000 01DC         direction = 0;
	CLR  R10
; 0000 01DD     }
; 0000 01DE     else
	RJMP _0x28
_0x27:
; 0000 01DF     {
; 0000 01E0         PORTC SET_B(1);
	SBI  0x15,1
; 0000 01E1         delay_us(REVERSE_DELAY);
	RCALL SUBOPT_0x6
; 0000 01E2         PORTC CLR_B(0);
	CBI  0x15,0
; 0000 01E3         direction = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 01E4     }
_0x28:
; 0000 01E5 }
	RET
;
;//functions for Robot's logic
;
;
;void go(u8 direction)
; 0000 01EB {
; 0000 01EC     switch (direction)
;	direction -> Y+0
; 0000 01ED     {
; 0000 01EE         case STOP:
; 0000 01EF             printf("cmd: stop\n\r");
; 0000 01F0             brake();
; 0000 01F1             break;
; 0000 01F2 
; 0000 01F3         case F:
; 0000 01F4             printf("cmd: forward\n\r");
; 0000 01F5             servo_steer(SERVO_FORWARD, 10);
; 0000 01F6             accel();
; 0000 01F7             break;
; 0000 01F8 
; 0000 01F9         case FR:
; 0000 01FA             printf("cmd: forward-right\n\r");
; 0000 01FB             servo_steer(SERVO_RIGHT, 10);
; 0000 01FC             accel();
; 0000 01FD             break;
; 0000 01FE 
; 0000 01FF         case FL:
; 0000 0200             printf("cmd: forward-left\n\r");
; 0000 0201             servo_steer(SERVO_LEFT, 10);
; 0000 0202             accel();
; 0000 0203             break;
; 0000 0204 
; 0000 0205         case B:
; 0000 0206             printf("cmd: backward\n\r");
; 0000 0207             brake();
; 0000 0208             reverse();
; 0000 0209             servo_steer(SERVO_FORWARD, 10);
; 0000 020A             accel();
; 0000 020B             break;
; 0000 020C 
; 0000 020D         case BR:
; 0000 020E             printf("cmd: backward-right\n\r");
; 0000 020F             brake();
; 0000 0210             reverse();
; 0000 0211             servo_steer(SERVO_RIGHT, 10);
; 0000 0212             accel();
; 0000 0213             break;
; 0000 0214 
; 0000 0215         case BL:
; 0000 0216             printf("cmd: backward-left\n\r");
; 0000 0217             brake();
; 0000 0218             reverse();
; 0000 0219             servo_steer(SERVO_LEFT, 10);
; 0000 021A             accel();
; 0000 021B             break;
; 0000 021C     }
; 0000 021D }
;
;
;u8 next_move(void)
; 0000 0221 {
; 0000 0222    u8 pp, i;
; 0000 0223 
; 0000 0224    pp = rand();
;	pp -> R17
;	i -> R16
; 0000 0225    for (i = 0; i < 7; i++)
; 0000 0226    {
; 0000 0227       if (p[cur_move][i] > pp) break;
; 0000 0228    }
; 0000 0229    cur_move = i;
; 0000 022A 
; 0000 022B    return(i);
; 0000 022C }
;
;u8 walk(void)
; 0000 022F {
; 0000 0230    //while((bit_is_set(IN, LIGHT_R)) && (bit_is_set(IN, LIGHT_L)))
; 0000 0231    {
; 0000 0232        go(next_move());
; 0000 0233        delay_ms(2500);
; 0000 0234    }
; 0000 0235 
; 0000 0236    return(0);
; 0000 0237 }
;
;/*
;//function for testing motor and servo
;void test_prog1(void)
;{
;    servo_poz = 127;
;    accel();
;    servo_poz = 0;
;    delay_ms(400);
;    servo_poz = 254;
;    delay_ms(500);
;    servo_poz = 127;
;    delay_ms(400);
;    brake();
;    reverse();
;    accel();
;    servo_poz = 0;
;    delay_ms(400);
;    servo_poz = 254;
;    delay_ms(500);
;    servo_poz = 127;
;    delay_ms(400);
;    brake();
;}
;
;//function for testing motor and servo
;void test_prog2(void)
;{
;    int i;
;
;    accel();
;    delay_ms(100);
;    for (i = 127; i >= 0; i-=5)
;    {
;        servo_poz = i;
;        delay_ms(10);
;    }
;    delay_ms(100);
;    brake();
;    delay_ms(10);
;    reverse();
;    accel();
;    for (i = 0; i <= 254; i+=5)
;    {
;        servo_poz = i;
;        delay_ms(10);
;    }
;    for (i = 254; i >= 127; i-=5)
;    {
;        servo_poz = i;
;        delay_ms(10);
;    }
;    brake();
;    delay_ms(10);
;    reverse();
;}
;
;//function for testing motor and servo
;void test_prog3(void)
;{
;    servo_poz = 127;
;    accel();
;    delay_ms(2000);
;    brake();
;    delay_ms(10);
;    reverse();
;}*/
;
;//get value from the end of input command
;//count is a count of the digits, for example: for 100 we should use count=3
;//return value if it is OK (0-254)
;//return -1 if error
;int get_val(int count)
; 0000 0281 {
_get_val:
; 0000 0282     int tmp_chr, i, tmp_val = 0;
; 0000 0283 
; 0000 0284     for (i=count-1;i>=0;i--)
	RCALL __SAVELOCR6
;	count -> Y+6
;	tmp_chr -> R16,R17
;	i -> R18,R19
;	tmp_val -> R20,R21
	__GETWRN 20,21,0
	RCALL SUBOPT_0x7
	SBIW R30,1
	MOVW R18,R30
_0x38:
	TST  R19
	BRMI _0x39
; 0000 0285     {
; 0000 0286         //get char and convert it from the ascii to the number
; 0000 0287         tmp_chr = getchar() - 48;
	RCALL _getchar
	RCALL SUBOPT_0x1
	SBIW R30,48
	MOVW R16,R30
; 0000 0288         //is it digit?
; 0000 0289         if ((tmp_chr > 9) && (tmp_chr < 0))
	__CPWRN 16,17,10
	BRLT _0x3B
	TST  R17
	BRMI _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 028A         {
; 0000 028B             printf(err_dev_val);
	LDI  R30,LOW(_err_dev_val*2)
	LDI  R31,HIGH(_err_dev_val*2)
	RCALL SUBOPT_0x2
; 0000 028C             printf("%d\n\r", tmp_chr);
	RCALL SUBOPT_0x8
	MOVW R30,R16
	RCALL SUBOPT_0x9
; 0000 028D         }
; 0000 028E         else
	RJMP _0x3D
_0x3A:
; 0000 028F         {
; 0000 0290             tmp_val += tmp_chr * power(10,i);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0xA
	ST   -Y,R19
	ST   -Y,R18
	RCALL _power
	MOVW R26,R16
	RCALL __MULW12
	__ADDWRR 20,21,30,31
; 0000 0291             //printf("\n\ri=%d, tmp_chr=%d, tmp_val=%d\n\r", i, tmp_chr, tmp_val);
; 0000 0292         }
_0x3D:
; 0000 0293     }
	__SUBWRN 18,19,1
	RJMP _0x38
_0x39:
; 0000 0294     //check value
; 0000 0295     if (tmp_val > MAX_VAL)
	__CPWRN 20,21,255
	BRLT _0x3E
; 0000 0296     {
; 0000 0297         printf(err_dev_max_val);
	LDI  R30,LOW(_err_dev_max_val*2)
	LDI  R31,HIGH(_err_dev_max_val*2)
	RCALL SUBOPT_0x2
; 0000 0298         printf("%d\n\r", tmp_val);
	RCALL SUBOPT_0x8
	MOVW R30,R20
	RCALL SUBOPT_0x9
; 0000 0299         return -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0003
; 0000 029A     }
; 0000 029B     else return tmp_val;
_0x3E:
	MOVW R30,R20
; 0000 029C }
_0x20C0003:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;
;//usart buffers polling, get command and analyse
;int usart_buf_poll(void)
; 0000 02A0 {
_usart_buf_poll:
; 0000 02A1     if (getchar()== COMMAND)
	RCALL _getchar
	CPI  R30,LOW(0x63)
	BREQ PC+2
	RJMP _0x40
; 0000 02A2     {
; 0000 02A3         printf("\n\rCOMMAND\n\r");
	__POINTW1FN _0x0,196
	RCALL SUBOPT_0x2
; 0000 02A4         dev_type = getchar();
	RCALL _getchar
	MOV  R6,R30
; 0000 02A5         switch (dev_type)
	MOV  R30,R6
	RCALL SUBOPT_0x1
; 0000 02A6         {
; 0000 02A7             case MOTOR:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x44
; 0000 02A8             {
; 0000 02A9                 printf("\n\rMOTOR\n\r");
	__POINTW1FN _0x0,208
	RCALL SUBOPT_0x2
; 0000 02AA                 dev_num = 0;
	CLR  R9
; 0000 02AB                 motor_cmd = getchar();
	RCALL _getchar
	MOV  R8,R30
; 0000 02AC                 switch (motor_cmd)
	MOV  R30,R8
	RCALL SUBOPT_0xB
; 0000 02AD                 {
; 0000 02AE                     case ACCEL:
	BRNE _0x48
; 0000 02AF                     {
; 0000 02B0                         printf("\n\rACCEL\n\r");
	__POINTW1FN _0x0,218
	RCALL SUBOPT_0x2
; 0000 02B1                         accel();
	RCALL _accel
; 0000 02B2                         break;
	RJMP _0x47
; 0000 02B3                     }
; 0000 02B4                     case BRAKE:
_0x48:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x49
; 0000 02B5                     {
; 0000 02B6                         printf("\n\rBRAKE\n\r");
	__POINTW1FN _0x0,228
	RCALL SUBOPT_0x2
; 0000 02B7                         brake();
	RCALL _brake
; 0000 02B8                         break;
	RJMP _0x47
; 0000 02B9                     }
; 0000 02BA                     case REVERSE:
_0x49:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x4A
; 0000 02BB                     {
; 0000 02BC                         printf("\n\rREVERSE\n\r");
	__POINTW1FN _0x0,238
	RCALL SUBOPT_0x2
; 0000 02BD                         reverse();
	RCALL _reverse
; 0000 02BE                         break;
	RJMP _0x47
; 0000 02BF                     }
; 0000 02C0                     case POWER:
_0x4A:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x4D
; 0000 02C1                     {
; 0000 02C2                         printf("\n\rPOWER\n\r");
	__POINTW1FN _0x0,250
	RCALL SUBOPT_0x2
; 0000 02C3                         //get power value
; 0000 02C4                         ret = get_val(3);
	RCALL SUBOPT_0xC
; 0000 02C5                         if (ret != -1)
	BREQ _0x4C
; 0000 02C6                         {
; 0000 02C7                             dev_val[dev_num] = ret;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 02C8                             printf("\n\rValue: %d\n\r", dev_val[dev_num]);
	RCALL SUBOPT_0xF
; 0000 02C9                             //change motor power
; 0000 02CA                             OCR2 = dev_val[dev_num];
	LD   R30,Z
	OUT  0x23,R30
; 0000 02CB                         }
; 0000 02CC                         break;
_0x4C:
	RJMP _0x47
; 0000 02CD                     }
; 0000 02CE                     default:
_0x4D:
; 0000 02CF                     {
; 0000 02D0                         printf(err_dev_mot_cmd);
	LDI  R30,LOW(_err_dev_mot_cmd*2)
	LDI  R31,HIGH(_err_dev_mot_cmd*2)
	RCALL SUBOPT_0x2
; 0000 02D1                         printf("%d\n\r", motor_cmd);
	RCALL SUBOPT_0x8
	MOV  R30,R8
	RJMP _0x20C0002
; 0000 02D2                         return -1;
; 0000 02D3                     }
; 0000 02D4                 };
_0x47:
; 0000 02D5                 break;
	RJMP _0x43
; 0000 02D6             }
; 0000 02D7             case SERVO:
_0x44:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x56
; 0000 02D8             {
; 0000 02D9                 printf("\n\rSERVO\n\r");
	__POINTW1FN _0x0,274
	RCALL SUBOPT_0x2
; 0000 02DA                 dev_num = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 02DB                 servo_cmd = getchar();
	RCALL _getchar
	MOV  R11,R30
; 0000 02DC                 switch (servo_cmd)
	MOV  R30,R11
	RCALL SUBOPT_0xB
; 0000 02DD                 {
; 0000 02DE                     case ANGLE:
	BRNE _0x52
; 0000 02DF                     {
; 0000 02E0                         printf("\n\rANGLE\n\r");
	__POINTW1FN _0x0,284
	RCALL SUBOPT_0x2
; 0000 02E1                         //get angle value
; 0000 02E2                         ret = get_val(3);
	RCALL SUBOPT_0xC
; 0000 02E3                         if (ret != -1)
	BREQ _0x53
; 0000 02E4                         {
; 0000 02E5                             dev_val[dev_num] = ret;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 02E6                             printf("\n\rValue: %d\n\r", dev_val[dev_num]);
	RCALL SUBOPT_0xF
; 0000 02E7                             //change angle
; 0000 02E8                             servo_poz = dev_val[dev_num];
	LD   R12,Z
; 0000 02E9                         }
; 0000 02EA                         break;
_0x53:
	RJMP _0x51
; 0000 02EB                     }
; 0000 02EC                     case TEST:
_0x52:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x55
; 0000 02ED                     {
; 0000 02EE                         printf("\n\rTEST\n\r");
	__POINTW1FN _0x0,294
	RCALL SUBOPT_0x2
; 0000 02EF                         test_servo();
	RCALL _test_servo
; 0000 02F0                         break;
	RJMP _0x51
; 0000 02F1                     }
; 0000 02F2                     default:
_0x55:
; 0000 02F3                     {
; 0000 02F4                         printf(err_dev_serv_cmd);
	LDI  R30,LOW(_err_dev_serv_cmd*2)
	LDI  R31,HIGH(_err_dev_serv_cmd*2)
	RJMP _0x20C0001
; 0000 02F5                         printf("%d\n\r", servo_cmd);
; 0000 02F6                         return -1;
; 0000 02F7                     }
; 0000 02F8                 };
_0x51:
; 0000 02F9                 break;
	RJMP _0x43
; 0000 02FA             }
; 0000 02FB             default:
_0x56:
; 0000 02FC             {
; 0000 02FD                 printf(err_dev_num);
	LDI  R30,LOW(_err_dev_num*2)
	LDI  R31,HIGH(_err_dev_num*2)
_0x20C0001:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 02FE                 printf("%d\n\r", servo_cmd);
	RCALL SUBOPT_0x8
	MOV  R30,R11
_0x20C0002:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 02FF                 return -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET
; 0000 0300             }
; 0000 0301         };
_0x43:
; 0000 0302     };
_0x40:
; 0000 0303 }
	RET
;
;//INTERRUPTS
;
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0309 {
_timer1_compa_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 030A     TCNT1H = 0x00; // обнулить счет таймера
	RCALL SUBOPT_0x0
; 0000 030B     TCNT1L = 0x00;
; 0000 030C     // Вывести в PORTB новое состояние
; 0000 030D     PORTB = pb_state[index_st];
	LDS  R30,_index_st
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_pb_state*2)
	SBCI R31,HIGH(-_pb_state*2)
	LPM  R0,Z
	OUT  0x18,R0
; 0000 030E 
; 0000 030F     if (index_st == 1)
	LDS  R26,_index_st
	CPI  R26,LOW(0x1)
	BRNE _0x57
; 0000 0310     {
; 0000 0311         // прерываться после отсчёта остатка времени
; 0000 0312         OCR1A = ctr_last;
	LDS  R30,_ctr_last
	LDS  R31,_ctr_last+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0313 
; 0000 0314         // обновить остаток времени на 20 мС
; 0000 0315         ctr_last = 20000;
	LDI  R30,LOW(20000)
	LDI  R31,HIGH(20000)
	STS  _ctr_last,R30
	STS  _ctr_last+1,R31
; 0000 0316 
; 0000 0317         // обнулить индекс
; 0000 0318         index_st = 0;
	LDI  R30,LOW(0)
	RJMP _0x6A
; 0000 0319     }
; 0000 031A     else
_0x57:
; 0000 031B     {
; 0000 031C         // Вычислить длину имп. для сервы и вписать в OCR1A
; 0000 031D         OCR1A=988+(((unsigned int)servo_poz)<<2);
	MOV  R26,R12
	RCALL SUBOPT_0x10
	MOVW R30,R26
	RCALL __LSLW2
	SUBI R30,LOW(-988)
	SBCI R31,HIGH(-988)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 031E         /* тут servo_poz умножается на 4 сдвигом в лево на 2 бита и затем плюсуется к 988.
; 0000 031F         Пример - среднее положение сервы это команда 127, умножим на 4 будет 508, прибавим 988 -
; 0000 0320         получим 1496 мкС - это и есть длина импульса для среднего положения вала servo.  */
; 0000 0321 
; 0000 0322         // Вычесть длину имп. сервы из периода в 20 мС
; 0000 0323         ctr_last -= OCR1A ;
	IN   R30,0x2A
	IN   R31,0x2A+1
	LDS  R26,_ctr_last
	LDS  R27,_ctr_last+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _ctr_last,R26
	STS  _ctr_last+1,R27
; 0000 0324 
; 0000 0325         // увеличить индекс на 1
; 0000 0326         index_st ++ ;
	LDS  R30,_index_st
	SUBI R30,-LOW(1)
_0x6A:
	STS  _index_st,R30
; 0000 0327     };
; 0000 0328 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;
;// Функция обработчик прерывания 12 - завершение приема символа в USART
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 032D {
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 032E     char status,data;
; 0000 032F     status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0330     data=UDR;
	IN   R16,12
; 0000 0331     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x59
; 0000 0332     {
; 0000 0333         rx_buffer[rx_wr_index]=data;
	MOV  R30,R5
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0334         if (++rx_wr_index == RX_BUFFER_SIZE)
	INC  R5
	LDI  R30,LOW(100)
	CP   R30,R5
	BRNE _0x5A
; 0000 0335         {
; 0000 0336             rx_wr_index=0;
	CLR  R5
; 0000 0337         };
_0x5A:
; 0000 0338         if (++rx_counter == RX_BUFFER_SIZE)
	INC  R7
	LDI  R30,LOW(100)
	CP   R30,R7
	BRNE _0x5B
; 0000 0339         {
; 0000 033A             rx_counter=0;
	CLR  R7
; 0000 033B             rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 033C         };
_0x5B:
; 0000 033D     };
_0x59:
; 0000 033E }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0342 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0343     TCNT0 = 0xF4;
	LDI  R30,LOW(244)
	OUT  0x32,R30
; 0000 0344     if (timer0_int_cnt < 20) PORTC INV_B(3);
	LDS  R26,_timer0_int_cnt
	CPI  R26,LOW(0x14)
	BRSH _0x5C
	IN   R30,0x15
	LDI  R26,LOW(8)
	EOR  R30,R26
	OUT  0x15,R30
; 0000 0345     if (timer0_int_cnt >= 20)
_0x5C:
	LDS  R26,_timer0_int_cnt
	CPI  R26,LOW(0x14)
	BRLO _0x5D
; 0000 0346     {
; 0000 0347         if (timer0_pause_cnt >= 40)
	LDS  R26,_timer0_pause_cnt
	CPI  R26,LOW(0x28)
	BRLO _0x5E
; 0000 0348         {
; 0000 0349             timer0_int_cnt = 0;
	LDI  R30,LOW(0)
	STS  _timer0_int_cnt,R30
; 0000 034A             timer0_pause_cnt = 0;
	RJMP _0x6B
; 0000 034B         }
; 0000 034C         else timer0_pause_cnt++;
_0x5E:
	LDS  R30,_timer0_pause_cnt
	SUBI R30,-LOW(1)
_0x6B:
	STS  _timer0_pause_cnt,R30
; 0000 034D     }
; 0000 034E     else
	RJMP _0x60
_0x5D:
; 0000 034F     {
; 0000 0350         timer0_int_cnt++;
	LDS  R30,_timer0_int_cnt
	SUBI R30,-LOW(1)
	STS  _timer0_int_cnt,R30
; 0000 0351     }
_0x60:
; 0000 0352 
; 0000 0353 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0357 {
_ext_int0_isr:
; 0000 0358     /*if(cur_move == BR) go(FL);
; 0000 0359     if(cur_move == BL) go(FR);
; 0000 035A     else go(F);
; 0000 035B     //delay_ms(2500);
; 0000 035C     cur_move = F;*/
; 0000 035D }
	RETI
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0361 {
_ext_int1_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0362     /*if(cur_move == FR) go(BL);
; 0000 0363     if(cur_move == FL) go(BR);
; 0000 0364     else go(B);
; 0000 0365     //delay_ms(2500);
; 0000 0366     cur_move = B;*/
; 0000 0367     /*if(!RC5flg)
; 0000 0368     {
; 0000 0369        RC5flg++;
; 0000 036A        RC5cnt = 0;
; 0000 036B        RC5rcv = 0;
; 0000 036C        RC5num = 0;
; 0000 036D        RC5err = 0;
; 0000 036E     }*/
; 0000 036F     if (PIND.3) printf("1\n\r");
	SBIS 0x10,3
	RJMP _0x61
	__POINTW1FN _0x0,303
	RJMP _0x6C
; 0000 0370     else printf("0\n\r");
_0x61:
	__POINTW1FN _0x0,307
_0x6C:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 0371 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;/*
;void RC5AskBit(void)
;{
;    u8 a;
;    u8 b;
;
;    if(++RC5num < 14)
;    {
;        if(abs(RC5cnt1a-RC5cnt0a) < 2) RC5err++;
;        if(abs(RC5cnt1b-RC5cnt0b) < 2) RC5err++;
;
;        a = (RC5cnt1a > RC5cnt0a)? 1:0;
;        b = (RC5cnt1b > RC5cnt0b)? 1:0;
;
;        if(a == b) RC5err++;
;
;	    RC5rcv <<= 1;
;	    RC5rcv |= (a > b)? 1:0;
;    }
;    else
;    {
;	    if(RC5num > 14)
;	    {
;	        if(!RC5err && RC5rcv & 0x1000)
;	        {
;	            RC5inp =  RC5rcv;
;	        }
;	        RC5flg = 0;
;	    }
;    }
;    RC5cnt1a = 0;
;    RC5cnt0a = 0;
;    RC5cnt1b = 0;
;    RC5cnt0b = 0;
;    return;
;}
;
;u8 RC5corrector(u8 i)
;{
;    static char corrector[12]={26,26,25,26,
;			     26,26,25,26,
;			     26,26,25,26};
;
;    return((i > 11)? 26:corrector[i]);
;}
;
;void RC5receiver(void)
;{
;    if(RC5flg)
;    {
;	    if(RC5cnt > 13)
;	    {
;	        if(PIND.3)
;	        {
;		        RC5cnt0b++;
;	        }
;	        else RC5cnt1b++;
;	    }
;	    else
;	    {
;	        if(PIND.3)
;	        {
;		        RC5cnt0a++;
;	        }
;	        else RC5cnt1a++;
;	    }
;	    if(RC5cnt++ > RC5corrector(RC5num))
;	    {
;	        RC5cnt = 0;
;	        RC5AskBit();
;	    }
;    }
;    return;
;}
;*/
;void main(void)
; 0000 03BE {
_main:
; 0000 03BF     u8 i, ar[50], res, zero_count, steer_angle;
; 0000 03C0     //bit y;
; 0000 03C1 
; 0000 03C2     //Initialization
; 0000 03C3     init();
	SBIW R28,50
;	i -> R17
;	ar -> Y+0
;	res -> R16
;	zero_count -> R19
;	steer_angle -> R18
	RCALL _init
; 0000 03C4     // Start
; 0000 03C5     printf(motd);
	LDI  R30,LOW(_motd*2)
	LDI  R31,HIGH(_motd*2)
	RCALL SUBOPT_0x2
; 0000 03C6     /*
; 0000 03C7     //working with MMC or SD flash card
; 0000 03C8     spi_init();
; 0000 03C9 	printf("MMC init\n\r");
; 0000 03CA 	res = MMC_Init();
; 0000 03CB     printf("MMC init res = %d\n\r", res);
; 0000 03CC     if (res == 1)
; 0000 03CD     {
; 0000 03CE     //mmc_read_csd(sector);
; 0000 03CF     //output_buf(sector, 16, 0);
; 0000 03D0 
; 0000 03D1     mmc_read_cid(sector);
; 0000 03D2     output_buf(sector, 16, 1);
; 0000 03D3 
; 0000 03D4 	fillbuf(sector);
; 0000 03D5     output_buf(sector, 128, 1);
; 0000 03D6 
; 0000 03D7     mmc_write_sector(0, sector);
; 0000 03D8 
; 0000 03D9     mmc_read_sector(0, sector);
; 0000 03DA     output_buf(sector, 128, 1);
; 0000 03DB     }*/
; 0000 03DC     //normal work
; 0000 03DD     timer_init();
	RCALL _timer_init
; 0000 03DE     //test all systems
; 0000 03DF     /*accel();
; 0000 03E0     servo_steer(0, 1);
; 0000 03E1     servo_steer(254, 1);
; 0000 03E2     servo_steer(127, 1);
; 0000 03E3     brake();*/
; 0000 03E4     while (1)
_0x63:
; 0000 03E5     {
; 0000 03E6         /*RC5receiver();
; 0000 03E7         delay_us(64);
; 0000 03E8         printf("RC5flg=%d, RC5cnt=%d, RC5rcv=%d, RC5num=%d, RC5err=%d\n\r", RC5flg, RC5cnt, RC5rcv, RC5num, RC5err);*/
; 0000 03E9         /*printf("rc: ");
; 0000 03EA         for (i = 0; i < 20; i++)
; 0000 03EB         {
; 0000 03EC             printf("%d", rc[i]);
; 0000 03ED         }
; 0000 03EE         printf("\n\r");
; 0000 03EF         delay_ms(300);*/
; 0000 03F0         //walk();
; 0000 03F1         usart_buf_poll();
	RCALL _usart_buf_poll
; 0000 03F2     }
	RJMP _0x63
; 0000 03F3 }
_0x66:
	RJMP _0x66
;#include "control_1.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;char SPI(char d)
; 0001 0004 {  // send character over SPI

	.CSEG
; 0001 0005     char received = 0;
; 0001 0006 
; 0001 0007     //printf("tx %d\n\r", d);
; 0001 0008     SPDR = d;
;	d -> Y+1
;	received -> R17
; 0001 0009     while(!(SPSR & (1<<SPIF)));
; 0001 000A     received = SPDR;
; 0001 000B     //printf("rx %d\n\r", received);
; 0001 000C     return (received);
; 0001 000D }
;
;
;char Command(char befF, u16 AdrH, u16 AdrL, char befH )
; 0001 0011 {    // sends a command to the MMC
; 0001 0012     SPI(0xFF);
;	befF -> Y+5
;	AdrH -> Y+3
;	AdrL -> Y+1
;	befH -> Y+0
; 0001 0013     SPI(befF);
; 0001 0014     SPI((u8)(AdrH >> 8));
; 0001 0015     SPI((u8)AdrH);
; 0001 0016     SPI((u8)(AdrL >> 8));
; 0001 0017     SPI((u8)AdrL);
; 0001 0018     SPI(befH);
; 0001 0019     SPI(0xFF);
; 0001 001A     return SPI(0xFF);    // return the last received character
; 0001 001B }
;
;int MMC_Init(void) { // init SPI
; 0001 001D int MMC_Init(void) {
; 0001 001E     u8 i;
; 0001 001F     MMC_Disable();
;	i -> R17
; 0001 0020     // start MMC in SPI mode
; 0001 0021     for(i=0; i < 10; i++) SPI(0xFF); // send 10*8=80 clock pulses
; 0001 0022 PORTB &= ~(1 << 2    );;
; 0001 0023 
; 0001 0024     if (Command(0x40,0,0,0x95) != 1) goto mmcerror; // reset MMC
; 0001 0025 
; 0001 0026 st: // if there is no MMC, prg. loops here
; 0001 0027     if (Command(0x41,0,0,0xFF) !=0) goto st;
; 0001 0028 
; 0001 0029     return 1;
; 0001 002A mmcerror:
; 0001 002B     printf("MMC_Init: mmc error\n\r");
; 0001 002C 
; 0001 002D     return 0;
; 0001 002E }
;
;u8 mmc_read_byte (void)
; 0001 0031 {
; 0001 0032     u8 Byte = 0;
; 0001 0033     //u16 Timeout = 0;
; 0001 0034 
; 0001 0035     SPDR = 0xff;
;	Byte -> R17
; 0001 0036     while(!(SPSR & (1<<SPIF)))
; 0001 0037     {
; 0001 0038         /*if (Timeout++ > 100)
; 0001 0039         {
; 0001 003A             printf("mmc_read_byte: break from while\n\r");
; 0001 003B             break;
; 0001 003C         }*/
; 0001 003D     }
; 0001 003E     Byte = SPDR;
; 0001 003F 
; 0001 0040     return (Byte);
; 0001 0041 }
;
;void mmc_write_byte (u8 Byte)
; 0001 0044 {
; 0001 0045     //u16 Timeout = 0;
; 0001 0046 
; 0001 0047     SPDR = Byte;
;	Byte -> Y+0
; 0001 0048     while(!(SPSR & (1<<SPIF)))
; 0001 0049     {
; 0001 004A         /*if (Timeout++ > 100)
; 0001 004B         {
; 0001 004C             printf("mmc_write_byte: break from while\n\r");
; 0001 004D             break;
; 0001 004E         }*/
; 0001 004F     }
; 0001 0050 }
;
;u8 mmc_write_command (u8 *cmd)
; 0001 0053 {
; 0001 0054     u8 tmp = 0xff, a;
; 0001 0055     u16 Timeout = 0;
; 0001 0056 
; 0001 0057     //printf("mmc_write_command\n\r");
; 0001 0058     MMC_Disable();
;	*cmd -> Y+4
;	tmp -> R17
;	a -> R16
;	Timeout -> R18,R19
; 0001 0059 
; 0001 005A     //sendet 8 Clock Impulse
; 0001 005B     mmc_write_byte(0xFF);
; 0001 005C 
; 0001 005D     MMC_Enable();
; 0001 005E 
; 0001 005F     //printf("mmc_write_command: send 6 byte\n\r");
; 0001 0060     //sendet 6 Byte Commando
; 0001 0061     for (a = 0; a<0x06; a++)
; 0001 0062     {
; 0001 0063         mmc_write_byte(*cmd++);
; 0001 0064     }
; 0001 0065 
; 0001 0066     //printf("mmc_write_command: while\n\r");
; 0001 0067     while (tmp == 0xff)
; 0001 0068     {
; 0001 0069         tmp = mmc_read_byte();
; 0001 006A         if (Timeout++ > 500)
; 0001 006B         {
; 0001 006C             printf("mmc_write_command: break from while\n\r");
; 0001 006D             break;
; 0001 006E         }
; 0001 006F     }
; 0001 0070 
; 0001 0071     return(tmp);
; 0001 0072 }
;
;u8 mmc_write_sector (u32 addr, u8 *Buffer)
; 0001 0075 {
; 0001 0076     u8 tmp;
; 0001 0077     u16 a;
; 0001 0078     u8 cmd[] = {0x58,0x00,0x00,0x00,0x00,0xFF};
; 0001 0079 
; 0001 007A     printf("mmc_write_sector\n\r");
;	addr -> Y+12
;	*Buffer -> Y+10
;	tmp -> R17
;	a -> R18,R19
;	cmd -> Y+4
; 0001 007B     addr = addr << 9; //addr = addr * 512
; 0001 007C 
; 0001 007D     cmd[1] = ((addr & 0xFF000000) >>24 );
; 0001 007E     cmd[2] = ((addr & 0x00FF0000) >>16 );
; 0001 007F     cmd[3] = ((addr & 0x0000FF00) >>8 );
; 0001 0080 
; 0001 0081     tmp = mmc_write_command (cmd);
; 0001 0082     if (tmp != 0)
; 0001 0083     {
; 0001 0084         return(tmp);
; 0001 0085     }
; 0001 0086 
; 0001 0087     for (a=0; a<100; a++)
; 0001 0088     {
; 0001 0089         mmc_read_byte();
; 0001 008A     }
; 0001 008B 
; 0001 008C     mmc_write_byte(0xFE);
; 0001 008D 
; 0001 008E     //printf("mmc_write_sector: writing...\n\r");
; 0001 008F     for (a=0;a<512;a++)
; 0001 0090     {
; 0001 0091         mmc_write_byte(*Buffer++);
; 0001 0092     }
; 0001 0093 
; 0001 0094     mmc_write_byte(0xFF); //Schreibt Dummy CRC
; 0001 0095     mmc_write_byte(0xFF); //CRC Code wird nicht benutzt
; 0001 0096 
; 0001 0097     //(Data Response XXX00101 = OK)
; 0001 0098     if((mmc_read_byte()&0x1F) != 0x05) return(1);
; 0001 0099 
; 0001 009A     //printf("mmc_write_sector: wait if busy\n\r");
; 0001 009B     //Wartet auf MMC/SD-Karte Bussy
; 0001 009C     while (mmc_read_byte() != 0xFF){};
; 0001 009D 
; 0001 009E     MMC_Disable();
; 0001 009F 
; 0001 00A0     return(0);
; 0001 00A1 }
;
;void mmc_read_block(u8 *cmd, u8 *Buffer, u16 Bytes)
; 0001 00A4 {
; 0001 00A5     u8 a;
; 0001 00A6 
; 0001 00A7     printf("mmc_read_block\n\r");
;	*cmd -> Y+5
;	*Buffer -> Y+3
;	Bytes -> Y+1
;	a -> R17
; 0001 00A8     //Sendet Commando cmd an MMC/SD-Karte
; 0001 00A9     if (mmc_write_command (cmd) != 0)
; 0001 00AA     {
; 0001 00AB         return;
; 0001 00AC     }
; 0001 00AD 
; 0001 00AE     //printf("mmc_read_block: wait 0xFE\n\r");
; 0001 00AF     while (mmc_read_byte() != 0xFE){};
; 0001 00B0 
; 0001 00B1     //printf("mmc_read_block: reading...\n\r");
; 0001 00B2     for (a=0; a<Bytes; a++)
; 0001 00B3     {
; 0001 00B4         *Buffer++ = mmc_read_byte();
; 0001 00B5     }
; 0001 00B6 
; 0001 00B7     mmc_read_byte();//CRC - Byte wird nicht ausgewertet
; 0001 00B8     mmc_read_byte();//CRC - Byte wird nicht ausgewertet
; 0001 00B9 
; 0001 00BA     MMC_Disable();
; 0001 00BB 
; 0001 00BC     return;
; 0001 00BD }
;
;u8 mmc_read_sector (u32 addr, u8 *Buffer)
; 0001 00C0 {
; 0001 00C1     u8 cmd[] = {0x51,0x00,0x00,0x00,0x00,0xFF};
; 0001 00C2 
; 0001 00C3     printf("mmc_read_sector\n\r");
;	addr -> Y+8
;	*Buffer -> Y+6
;	cmd -> Y+0
; 0001 00C4     addr = addr << 9; //addr = addr * 512
; 0001 00C5     cmd[1] = ((addr & 0xFF000000) >>24 );
; 0001 00C6     cmd[2] = ((addr & 0x00FF0000) >>16 );
; 0001 00C7     cmd[3] = ((addr & 0x0000FF00) >>8 );
; 0001 00C8     mmc_read_block(cmd, Buffer, 128);
; 0001 00C9 
; 0001 00CA     return(0);
; 0001 00CB }
;
;u8 mmc_read_cid (u8 *Buffer)
; 0001 00CE {
; 0001 00CF     u8 cmd[] = {0x4A, 0x00, 0x00, 0x00, 0x00, 0xFF};
; 0001 00D0 
; 0001 00D1     printf("mmc_read_cid\n\r");
;	*Buffer -> Y+6
;	cmd -> Y+0
; 0001 00D2     mmc_read_block(cmd, Buffer, 16);
; 0001 00D3 
; 0001 00D4     return(0);
; 0001 00D5 }
;
;u8 mmc_read_csd (u8 *Buffer)
; 0001 00D8 {
; 0001 00D9     u8 cmd[] = {0x49, 0x00, 0x00, 0x00, 0x00, 0xFF};
; 0001 00DA 
; 0001 00DB     printf("mmc_read_csd\n\r");
;	*Buffer -> Y+6
;	cmd -> Y+0
; 0001 00DC     mmc_read_block(cmd, Buffer, 16);
; 0001 00DD 
; 0001 00DE     return(0);
; 0001 00DF }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
__put_G100:
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x2000012:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x2000013:
	RJMP _0x2000014
_0x2000010:
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _putchar
_0x2000014:
	RCALL __LOADLOCR2
	ADIW R28,7
	RET
__print_G100:
	SBIW R28,11
	RCALL __SAVELOCR6
	LDI  R17,0
_0x2000015:
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ADIW R30,1
	STD  Y+23,R30
	STD  Y+23+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000017
	MOV  R30,R17
	RCALL SUBOPT_0x1
	SBIW R30,0
	BRNE _0x200001B
	CPI  R18,37
	BRNE _0x200001C
	LDI  R17,LOW(1)
	RJMP _0x200001D
_0x200001C:
	RCALL SUBOPT_0x11
_0x200001D:
	RJMP _0x200001A
_0x200001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x200001E
	CPI  R18,37
	BRNE _0x200001F
	RCALL SUBOPT_0x11
	RJMP _0x20000C5
_0x200001F:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000020
	LDI  R16,LOW(1)
	RJMP _0x200001A
_0x2000020:
	CPI  R18,43
	BRNE _0x2000021
	LDI  R20,LOW(43)
	RJMP _0x200001A
_0x2000021:
	CPI  R18,32
	BRNE _0x2000022
	LDI  R20,LOW(32)
	RJMP _0x200001A
_0x2000022:
	RJMP _0x2000023
_0x200001E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2000024
_0x2000023:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000025
	ORI  R16,LOW(128)
	RJMP _0x200001A
_0x2000025:
	RJMP _0x2000026
_0x2000024:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2000027
_0x2000026:
	CPI  R18,48
	BRLO _0x2000029
	CPI  R18,58
	BRLO _0x200002A
_0x2000029:
	RJMP _0x2000028
_0x200002A:
	MOV  R26,R21
	RCALL SUBOPT_0x10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R22,R21
	CLR  R23
	MOV  R26,R18
	RCALL SUBOPT_0x10
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ADD  R30,R26
	MOV  R21,R30
	RJMP _0x200001A
_0x2000028:
	CPI  R18,108
	BRNE _0x200002B
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200001A
_0x200002B:
	RJMP _0x200002C
_0x2000027:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x200001A
_0x200002C:
	RCALL SUBOPT_0x12
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x2000031
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x15
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2000034
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000035
_0x2000034:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2000037
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000035:
	ANDI R16,LOW(127)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2000038
_0x2000037:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x200003B
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x200003C
_0x200003B:
	ORI  R16,LOW(4)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x200003E
_0x200003D:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x200003F
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x18
	LDI  R17,LOW(10)
	RJMP _0x2000040
_0x200003F:
	__GETD1N 0x2710
	RCALL SUBOPT_0x18
	LDI  R17,LOW(5)
	RJMP _0x2000040
_0x200003E:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x2000042
	ORI  R16,LOW(8)
	RJMP _0x2000043
_0x2000042:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2000076
_0x2000043:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000045
	__GETD1N 0x10000000
	RCALL SUBOPT_0x18
	LDI  R17,LOW(8)
	RJMP _0x2000040
_0x2000045:
	__GETD1N 0x1000
	RCALL SUBOPT_0x18
	LDI  R17,LOW(4)
_0x2000040:
	SBRS R16,1
	RJMP _0x2000046
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x19
	RCALL __GETD1P
	RJMP _0x20000C6
_0x2000046:
	SBRS R16,2
	RJMP _0x2000048
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x19
	RCALL __GETW1P
	RCALL __CWD1
	RJMP _0x20000C6
_0x2000048:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x19
	RCALL __GETW1P
	CLR  R22
	CLR  R23
_0x20000C6:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x200004A
	LDD  R26,Y+15
	TST  R26
	BRPL _0x200004B
	__GETD1S 12
	RCALL __ANEGD1
	RCALL SUBOPT_0x1A
	LDI  R20,LOW(45)
_0x200004B:
	CPI  R20,0
	BREQ _0x200004C
	SUBI R17,-LOW(1)
	RJMP _0x200004D
_0x200004C:
	ANDI R16,LOW(251)
_0x200004D:
_0x200004A:
_0x2000038:
	SBRC R16,0
	RJMP _0x200004E
_0x200004F:
	CP   R17,R21
	BRSH _0x2000051
	SBRS R16,7
	RJMP _0x2000052
	SBRS R16,2
	RJMP _0x2000053
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000054
_0x2000053:
	LDI  R18,LOW(48)
_0x2000054:
	RJMP _0x2000055
_0x2000052:
	LDI  R18,LOW(32)
_0x2000055:
	RCALL SUBOPT_0x11
	SUBI R21,LOW(1)
	RJMP _0x200004F
_0x2000051:
_0x200004E:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x2000056
_0x2000057:
	CPI  R19,0
	BREQ _0x2000059
	SBRS R16,3
	RJMP _0x200005A
	RCALL SUBOPT_0x7
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x20000C7
_0x200005A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x20000C7:
	ST   -Y,R30
	RCALL SUBOPT_0x15
	CPI  R21,0
	BREQ _0x200005C
	SUBI R21,LOW(1)
_0x200005C:
	SUBI R19,LOW(1)
	RJMP _0x2000057
_0x2000059:
	RJMP _0x200005D
_0x2000056:
_0x200005F:
	RCALL SUBOPT_0x1B
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2000061
	SBRS R16,3
	RJMP _0x2000062
	RCALL SUBOPT_0x12
	ADIW R30,55
	RJMP _0x20000C8
_0x2000062:
	RCALL SUBOPT_0x12
	SUBI R30,LOW(-87)
	SBCI R31,HIGH(-87)
_0x20000C8:
	MOV  R18,R30
	RJMP _0x2000064
_0x2000061:
	RCALL SUBOPT_0x12
	ADIW R30,48
	MOV  R18,R30
_0x2000064:
	SBRC R16,4
	RJMP _0x2000066
	CPI  R18,49
	BRSH _0x2000068
	RCALL SUBOPT_0x1C
	__CPD2N 0x1
	BRNE _0x2000067
_0x2000068:
	RJMP _0x200006A
_0x2000067:
	CP   R21,R19
	BRLO _0x200006C
	SBRS R16,0
	RJMP _0x200006D
_0x200006C:
	RJMP _0x200006B
_0x200006D:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006E
	LDI  R18,LOW(48)
_0x200006A:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006F
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x15
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
_0x2000070:
_0x200006F:
_0x200006E:
_0x2000066:
	RCALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x200006B:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x1B
	RCALL __MODD21U
	RCALL SUBOPT_0x1A
	LDD  R30,Y+16
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1C
	RCALL __CWD1
	RCALL __DIVD21U
	RCALL SUBOPT_0x18
	__GETD1S 8
	RCALL __CPD10
	BREQ _0x2000060
	RJMP _0x200005F
_0x2000060:
_0x200005D:
	SBRS R16,0
	RJMP _0x2000072
_0x2000073:
	CPI  R21,0
	BREQ _0x2000075
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x15
	RJMP _0x2000073
_0x2000075:
_0x2000072:
_0x2000076:
_0x2000032:
_0x20000C5:
	LDI  R17,LOW(0)
_0x200001A:
	RJMP _0x2000015
_0x2000017:
	RCALL __LOADLOCR6
	ADIW R28,25
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	RCALL __SAVELOCR2
	MOVW R26,R28
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0xA
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0xA
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0xA
	RCALL __print_G100
	RCALL __LOADLOCR2
	ADIW R28,4
	POP  R15
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
    lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x64
_dev_val:
	.BYTE 0x2
_index_st:
	.BYTE 0x1
_ctr_last:
	.BYTE 0x2
_timer0_int_cnt:
	.BYTE 0x1
_timer0_pause_cnt:
	.BYTE 0x1
_p:
	.BYTE 0x31
_cur_move:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4
_p_S1020024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x1:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDS  R30,_dev_val
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	STS  _dev_val,R30
	RCALL SUBOPT_0x3
	OUT  0x23,R30
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	__POINTW1FN _0x0,54
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0xA
	RCALL _get_val
	MOV  R13,R30
	MOV  R26,R13
	LDI  R30,LOW(255)
	LDI  R27,0
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	MOV  R30,R9
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_dev_val)
	SBCI R31,HIGH(-_dev_val)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	ST   Z,R13
	__POINTW1FN _0x0,260
	RCALL SUBOPT_0xA
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LD   R30,Z
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11:
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RCALL SUBOPT_0xA
	MOVW R30,R28
	ADIW R30,20
	RCALL SUBOPT_0xA
	RJMP __put_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	MOV  R30,R18
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x15:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RCALL SUBOPT_0xA
	MOVW R30,R28
	ADIW R30,20
	RCALL SUBOPT_0xA
	RJMP __put_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	RCALL SUBOPT_0x13
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0x7
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x18:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	__GETD1S 8
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	__GETD2S 8
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
