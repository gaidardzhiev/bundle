#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#define A(x) B(x)
#define B(x) ((x)^0xDEADBEEF)
#define LOOP for(;;)
#define SWITCH(x) switch(x)
#define CASE(x) case x
#define NEXT(x) st=x;break
#define RET(x) return x
#define PRED(x) (((x)*(x)^(x)*(x))|1)
#define C0 ((((1<<12)|(1<<11)|(1<<10)|(1<<9)|(1<<8)|(1<<7))^((1<<11)|(1<<10)|(1<<9)|(1<<8)|(1<<7)))|0)
#define C1 ((((1<<10)|(1<<9)|(1<<8))^((1<<9)|(1<<8)))+((1<<6)-(1<<6)))
#define Z (T++&0xF)
#define W (((Z*Z)%7)==3)
static int T;static unsigned char K0[10],S0[32],S1[10],S2[24],S3[7],S4[22],E0[11];static const char BK0[]="0Xl54gk4WYCqaQ==",BS0[]="euJy2SLpWKkxaAtKMoEio7OBW5jQo3JxEnsSM4GDgXk=",BS1[]="yHAA8UJLIBvpaQ==",BS2[]="ynLa4/g5SKkxeNCYmOMwKvPyiAv7QCni",BS3[]="w9MLwGsSWQ==",BS4[]="+OJ4wXITwoHZEnJ4UiFCo/rx2xiBeQ==",BE0[]="S3sbGxsBkYGRsQA=";
static int b(unsigned char*o,const char*i,int n){int j=0;unsigned int a=0,b0=0;for(int x=0;i[x]&&j<n;x++){char c=i[x];int v=c>='A'&&c<='Z'?c-'A':c>='a'&&c<='z'?c-'a'+26:c>='0'&&c<='9'?c-'0'+52:c=='+'?62:c=='/'?63:-1;if(v<0)continue;a=(a<<6)|v;b0+=6;if(b0>=8){b0-=8;o[j++]=(unsigned char)((a>>b0)&0xFF);}}return j;}
static unsigned char r3(unsigned char x){return (unsigned char)((x>>3)|(x<<5));}
static void u(unsigned char*t,int n){for(int i=0;i<n;i++)t[i]=r3(t[i]);}
static void d(char*s,int n){for(int i=0;i<n;i++)s[i]^=K0[i%sizeof(K0)];}
int m0xF1aB(int q0,char**r0){static int F0;char X4vL0p[C0],u9Xh[C1];FILE*S7d8=0,*J0k2=0;size_t L6h7=0;int t2P3=1,st=0;if(!F0++){b(K0,BK0,sizeof(K0));b(S0,BS0,sizeof(S0));b(S1,BS1,sizeof(S1));b(S2,BS2,sizeof(S2));b(S3,BS3,sizeof(S3));b(S4,BS4,sizeof(S4));b(E0,BE0,sizeof(E0));u(K0,sizeof(K0));u(S0,sizeof(S0));u(S1,sizeof(S1));u(S2,sizeof(S2));u(S3,sizeof(S3));u(S4,sizeof(S4));u(E0,sizeof(E0));d((char*)S0,sizeof(S0));d((char*)S1,sizeof(S1));d((char*)S2,sizeof(S2));d((char*)S3,sizeof(S3));d((char*)S4,sizeof(S4));}LOOP SWITCH(st){CASE(0):NEXT(q0<2?1:4);CASE(1):printf((char*)S0,r0[0]);S7d8=fopen(r0[0],"r");NEXT(2);CASE(2):if(S7d8){if(fgets(u9Xh,sizeof(u9Xh),S7d8)&&u9Xh[0]=='#'&&u9Xh[1]=='!'&&fgets(u9Xh,sizeof(u9Xh),S7d8))printf("%s",u9Xh+1);fclose(S7d8);}NEXT(3);CASE(3):RET(1);CASE(4):puts((char*)S1);NEXT(5);CASE(5):NEXT(t2P3<q0?6:12);CASE(6):if(PRED(t2P3)&1)st=access(r0[t2P3],F_OK)==0?7:11;else NEXT(13);break;CASE(7):printf((char*)S2,r0[t2P3]);J0k2=fopen(r0[t2P3],"r");NEXT(8);CASE(8):if(J0k2){L6h7=fread(X4vL0p,1,sizeof(X4vL0p),J0k2);st=L6h7>0?9:10;}else NEXT(10);break;CASE(9):fwrite(X4vL0p,1,L6h7,stdout);NEXT(8);CASE(10):if(J0k2){fclose(J0k2);J0k2=0;}puts((char*)S3);t2P3++;NEXT(5);CASE(11):printf((char*)S4,r0[t2P3]);t2P3++;NEXT(5);CASE(12):RET(0);CASE(13):write(1,E0,sizeof(E0)),NEXT(12);}}
int A9b2(int h3,char**k7){return m0xF1aB(h3,k7);}
int main(int Q8,char**Z2){return A9b2(Q8,Z2);}
