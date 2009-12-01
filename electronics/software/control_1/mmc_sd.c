#include "control_1.h"

char SPI(char d)
{  // send character over SPI
    char received = 0;

    //printf("tx %d\n\r", d);
    SPDR = d;
    while(!(SPSR & (1<<SPIF)));
    received = SPDR;
    //printf("rx %d\n\r", received);
    return (received);
}


char Command(char befF, u16 AdrH, u16 AdrL, char befH )
{    // sends a command to the MMC
    SPI(0xFF);
    SPI(befF);
    SPI((u8)(AdrH >> 8));
    SPI((u8)AdrH);
    SPI((u8)(AdrL >> 8));
    SPI((u8)AdrL);
    SPI(befH);
    SPI(0xFF);
    return SPI(0xFF);    // return the last received character
}

int MMC_Init(void) { // init SPI
    u8 i;
    MMC_Disable();
    // start MMC in SPI mode
    for(i=0; i < 10; i++) SPI(0xFF); // send 10*8=80 clock pulses
    MMC_Enable();

    if (Command(0x40,0,0,0x95) != 1) goto mmcerror; // reset MMC

st: // if there is no MMC, prg. loops here
    if (Command(0x41,0,0,0xFF) !=0) goto st;

    return 1;
mmcerror:
    printf("MMC_Init: mmc error\n\r");

    return 0;
}

u8 mmc_read_byte (void)
{
    u8 Byte = 0;
    //u16 Timeout = 0;

    SPDR = 0xff;
    while(!(SPSR & (1<<SPIF)))
    {
        /*if (Timeout++ > 100)
        {
            printf("mmc_read_byte: break from while\n\r");
            break;
        }*/
    }
    Byte = SPDR;

    return (Byte);
}

void mmc_write_byte (u8 Byte)
{
    //u16 Timeout = 0;

    SPDR = Byte;
    while(!(SPSR & (1<<SPIF)))
    {
        /*if (Timeout++ > 100)
        {
            printf("mmc_write_byte: break from while\n\r");
            break;
        }*/
    }
}

u8 mmc_write_command (u8 *cmd)
{
    u8 tmp = 0xff, a;
    u16 Timeout = 0;

    //printf("mmc_write_command\n\r");
    MMC_Disable();

    //sendet 8 Clock Impulse
    mmc_write_byte(0xFF);

    MMC_Enable();

    //printf("mmc_write_command: send 6 byte\n\r");
    //sendet 6 Byte Commando
    for (a = 0; a<0x06; a++)
    {
        mmc_write_byte(*cmd++);
    }

    //printf("mmc_write_command: while\n\r");
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

u8 mmc_write_sector (u32 addr, u8 *Buffer)
{
    u8 tmp;
    u16 a;
    u8 cmd[] = {0x58,0x00,0x00,0x00,0x00,0xFF};

    printf("mmc_write_sector\n\r");
    addr = addr << 9; //addr = addr * 512

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

    //printf("mmc_write_sector: writing...\n\r");
    for (a=0;a<512;a++)
    {
        mmc_write_byte(*Buffer++);
    }

    mmc_write_byte(0xFF); //Schreibt Dummy CRC
    mmc_write_byte(0xFF); //CRC Code wird nicht benutzt

    //(Data Response XXX00101 = OK)
    if((mmc_read_byte()&0x1F) != 0x05) return(1);

    //printf("mmc_write_sector: wait if busy\n\r");
    //Wartet auf MMC/SD-Karte Bussy
    while (mmc_read_byte() != 0xFF){};

    MMC_Disable();

    return(0);
}

void mmc_read_block(u8 *cmd, u8 *Buffer, u16 Bytes)
{
    u8 a;

    printf("mmc_read_block\n\r");
    //Sendet Commando cmd an MMC/SD-Karte
    if (mmc_write_command (cmd) != 0)
    {
        return;
    }

    //printf("mmc_read_block: wait 0xFE\n\r");
    while (mmc_read_byte() != 0xFE){};

    //printf("mmc_read_block: reading...\n\r");
    for (a=0; a<Bytes; a++)
    {
        *Buffer++ = mmc_read_byte();
    }

    mmc_read_byte();//CRC - Byte wird nicht ausgewertet
    mmc_read_byte();//CRC - Byte wird nicht ausgewertet

    MMC_Disable();

    return;
}

u8 mmc_read_sector (u32 addr, u8 *Buffer)
{
    u8 cmd[] = {0x51,0x00,0x00,0x00,0x00,0xFF};

    printf("mmc_read_sector\n\r");
    addr = addr << 9; //addr = addr * 512
    cmd[1] = ((addr & 0xFF000000) >>24 );
    cmd[2] = ((addr & 0x00FF0000) >>16 );
    cmd[3] = ((addr & 0x0000FF00) >>8 );
    mmc_read_block(cmd, Buffer, 128);

    return(0);
}

u8 mmc_read_cid (u8 *Buffer)
{
    u8 cmd[] = {0x4A, 0x00, 0x00, 0x00, 0x00, 0xFF};

    printf("mmc_read_cid\n\r");
    mmc_read_block(cmd, Buffer, 16);

    return(0);
}

u8 mmc_read_csd (u8 *Buffer)
{
    u8 cmd[] = {0x49, 0x00, 0x00, 0x00, 0x00, 0xFF};

    printf("mmc_read_csd\n\r");
    mmc_read_block(cmd, Buffer, 16);

    return(0);
}
