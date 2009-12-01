
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

#pragma used+

char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
char *strtok(char *str1,char flash *str2);

unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
unsigned int strcspn(char *str,char *set);
unsigned int strcspnf(char *str,char flash *set);
int strpos(char *str,char c);
int strrpos(char *str,char c);
unsigned int strspn(char *str,char *set);
unsigned int strspnf(char *str,char flash *set);

#pragma used-
#pragma library string.lib

#pragma used+
unsigned char spi(unsigned char data);
#pragma used-

#pragma library spi.lib

extern int MMC_Init(void);
extern unsigned char     mmc_write_sector (unsigned long int	 addr, unsigned char     *Buffer);
extern unsigned char     mmc_read_sector (unsigned long int	 addr, unsigned char     *Buffer);
extern unsigned char     mmc_read_cid (unsigned char     *Buffer);
extern unsigned char     mmc_read_csd (unsigned char     *Buffer);

char SPI(char d)
{  
char received = 0;

SPDR = d;
while(!(SPSR & (1<<7)));
received = SPDR;

return (received);
}

char Command(char befF, unsigned int     AdrH, unsigned int     AdrL, char befH )
{    
SPI(0xFF);
SPI(befF);
SPI((unsigned char    )(AdrH >> 8));
SPI((unsigned char    )AdrH);
SPI((unsigned char    )(AdrL >> 8));
SPI((unsigned char    )AdrL);
SPI(befH);
SPI(0xFF);
return SPI(0xFF);    
}

int MMC_Init(void) { 
unsigned char     i;
PORTB |= (1 << 2    );;

for(i=0; i < 10; i++) SPI(0xFF); 
PORTB &= ~(1 << 2    );;

if (Command(0x40,0,0,0x95) != 1) goto mmcerror; 

st: 
if (Command(0x41,0,0,0xFF) !=0) goto st;

return 1;
mmcerror:
printf("MMC_Init: mmc error\n\r");

return 0;
}

unsigned char     mmc_read_byte (void)
{
unsigned char     Byte = 0;

SPDR = 0xff;
while(!(SPSR & (1<<7)))
{

}
Byte = SPDR;

return (Byte);
}

void mmc_write_byte (unsigned char     Byte)
{

SPDR = Byte;
while(!(SPSR & (1<<7)))
{

}
}

unsigned char     mmc_write_command (unsigned char     *cmd)
{
unsigned char     tmp = 0xff, a;
unsigned int     Timeout = 0;

PORTB |= (1 << 2    );;

mmc_write_byte(0xFF);

PORTB &= ~(1 << 2    );;

for (a = 0; a<0x06; a++)
{
mmc_write_byte(*cmd++);
}

while (tmp == 0xff)
{
tmp = mmc_read_byte();
if (Timeout++ > 500)
{
printf("mmc_write_command: break from while\n\r");
break;
}
}

return(tmp);
}

unsigned char     mmc_write_sector (unsigned long int	 addr, unsigned char     *Buffer)
{
unsigned char     tmp;
unsigned int     a;
unsigned char     cmd[] = {0x58,0x00,0x00,0x00,0x00,0xFF};

printf("mmc_write_sector\n\r");
addr = addr << 9; 

cmd[1] = ((addr & 0xFF000000) >>24 );
cmd[2] = ((addr & 0x00FF0000) >>16 );
cmd[3] = ((addr & 0x0000FF00) >>8 );

tmp = mmc_write_command (cmd);
if (tmp != 0)
{
return(tmp);
}

for (a=0; a<100; a++)
{
mmc_read_byte();
}

mmc_write_byte(0xFE);

for (a=0;a<512;a++)
{
mmc_write_byte(*Buffer++);
}

mmc_write_byte(0xFF); 
mmc_write_byte(0xFF); 

if((mmc_read_byte()&0x1F) != 0x05) return(1);

while (mmc_read_byte() != 0xFF){};

PORTB |= (1 << 2    );;

return(0);
}

void mmc_read_block(unsigned char     *cmd, unsigned char     *Buffer, unsigned int     Bytes)
{
unsigned char     a;

printf("mmc_read_block\n\r");

if (mmc_write_command (cmd) != 0)
{
return;
}

while (mmc_read_byte() != 0xFE){};

for (a=0; a<Bytes; a++)
{
*Buffer++ = mmc_read_byte();
}

mmc_read_byte();
mmc_read_byte();

PORTB |= (1 << 2    );;

return;
}

unsigned char     mmc_read_sector (unsigned long int	 addr, unsigned char     *Buffer)
{
unsigned char     cmd[] = {0x51,0x00,0x00,0x00,0x00,0xFF};

printf("mmc_read_sector\n\r");
addr = addr << 9; 
cmd[1] = ((addr & 0xFF000000) >>24 );
cmd[2] = ((addr & 0x00FF0000) >>16 );
cmd[3] = ((addr & 0x0000FF00) >>8 );
mmc_read_block(cmd, Buffer, 128);

return(0);
}

unsigned char     mmc_read_cid (unsigned char     *Buffer)
{
unsigned char     cmd[] = {0x4A, 0x00, 0x00, 0x00, 0x00, 0xFF};

printf("mmc_read_cid\n\r");
mmc_read_block(cmd, Buffer, 16);

return(0);
}

unsigned char     mmc_read_csd (unsigned char     *Buffer)
{
unsigned char     cmd[] = {0x49, 0x00, 0x00, 0x00, 0x00, 0xFF};

printf("mmc_read_csd\n\r");
mmc_read_block(cmd, Buffer, 16);

return(0);
}
