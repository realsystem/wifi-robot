#pragma hdrstop
#include "qcode_lib.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

 
double angleF(char* datas, long int steps, CvSize szSrc, int bx,int by,int dx1,int dy1,int dx2,int dy2,int l, int b){
  double inner=0, outer=0;
  double d1=sqrt(dx1*dx1+dy1*dy1);
  double d2=sqrt(dx2*dx2+dy2*dy2);
  double dx1n=dx1/d1, dy1n=dy1/d1;
  double dx2n=dx2/d2, dy2n=dy2/d2;
  for(int j=1; j<=b; j++){
  for(int i=1; i<=l; i++){
    long int adr,d_x,d_y;
    d_x=bx+j*(dx1n+dx2n)+i*dx1n;
    d_y=by+j*(dy1n+dy2n)+i*dy1n;
    if( d_x<0 || d_x>szSrc.width || d_y<0 || d_y>szSrc.height ){
      inner+=0;
    }else{
      adr=d_x*3+(szSrc.height-d_y)*steps+2;
      inner+=datas[adr];
    };
    d_x=bx+j*(dx1n+dx2n)+i*dx2n;
    d_y=by+j*(dy1n+dy2n)+i*dy2n;
    if( d_x<0 || d_x>szSrc.width || d_y<0 || d_y>szSrc.height ){
      inner+=0;
    }else{
      adr=d_x*3+(szSrc.height-d_y)*steps+2;
      inner+=datas[adr];
    };
    d_x=bx-j*(dx1n+dx2n)+i*dx1n;
    d_y=by-j*(dy1n+dy2n)+i*dy1n;
    if( d_x<0 || d_x>szSrc.width || d_y<0 || d_y>szSrc.height ){
      outer+=0;
    }else{
      adr=d_x*3+(szSrc.height-d_y)*steps+2;
      outer+=datas[adr];
    };
    d_x=bx-j*(dx1n+dx2n)+i*dx2n;
    d_y=by-j*(dy1n+dy2n)+i*dy2n;
    if( d_x<0 || d_x>szSrc.width || d_y<0 || d_y>szSrc.height ){
      outer+=0;
    }else{
      adr=d_x*3+(szSrc.height-d_y)*steps+2;
      outer+=datas[adr];
    };
  };};
  return outer-inner;
};
 
double sqr(double a){
  return a*a;
};
 
CvQCodeBeacon* mycvGetQCodeBeacons(IplImage *img, int ThresholdSteps, double k_front, double k_side){
 //printf("start mycvGetQCodeBeacons\n");
  CvQCodeBeacon* fbeacon = NULL;
 
  CvSize szSrc; szSrc.width=img->width; szSrc.height=img->height;
  CvSize szDiv2; szDiv2.width=szSrc.width/2; szDiv2.height=szSrc.height/2;
 
  IplImage* pyr = cvCreateImage(szDiv2, IPL_DEPTH_8U, 3);
  IplImage* tmp = cvCreateImage(szSrc, IPL_DEPTH_8U, 3);

  cvPyrDown( img, pyr, 7 );
  cvPyrUp(   pyr, tmp, 7 );
 
  IplImage*  gray = cvCreateImage( szSrc, 8, 1 );
  IplImage* tgray = cvCreateImage( szSrc, 8, 1 );
 
  cvSetImageCOI( tmp, 2 );
  cvCopy( tmp, tgray, 0 );
 
  CvMemStorage* storage=cvCreateMemStorage(0);
  CvSeq* contours, result;
 
  for(int l=0; l<ThresholdSteps; l++){
  //printf("for\n");
    //??????????? ???????????
    if(l==0){
      cvCanny( tgray, gray, 0, 100, 5 );
      cvDilate( gray, gray, 0, 1 );
    }else{
      cvThreshold( tgray, gray, (l+1)*255/ThresholdSteps, 255, CV_THRESH_BINARY );
    };
 
    //?????? ??? ??????? ?? ???????????
 //printf("start cvFindContours\n");
    cvFindContours( gray, storage, &contours, sizeof(CvContour),
                    CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0) );
 
    //??? ??????? ?? ????????? ????????
    while( contours )
    {
//printf("while\n");
      //????????? ??? ???????????????
      CvSeq* result = cvApproxPoly( contours, sizeof(CvContour), storage,
      CV_POLY_APPROX_DP, cvContourPerimeter(contours)*0.02, 0 );
 
      //???????? ?????????? ?????? ??????????????
      int count = result->total;

      if(
        count == 4 //??? ?????? ???? ???????????????
        && fabs(cvContourArea(result,CV_WHOLE_SEQ)) > 100 //??????????? ???????
        && cvCheckContourConvexity(result) //????????
      ){
/* printf("count=%d\n", count);
 printf("if OK, l=%d\n", l);
if (l==9)
{
cvShowImage("mainWin", gray );
return fbeacon;
}*/
        //????, ??????? ????? ??????????, ???? ???-?? ?? ??? ??? ????????
        int isPara=1;
 
        //??????? ?????????? ??? ??????
        double x[5],y[5];
        for(int i=0; i < count; i++){
          CvPoint *pt=(CvPoint*)cvGetSeqElem( result, i );
          x[i]=pt->x;
          y[i]=szSrc.height-pt->y;
 //printf("x[%d]=%f\n", i, x[i]);
 //printf("y[%d]=%f\n", i, y[i]);
        }; x[count]=x[0]; y[count]=y[0];
 
        //????????? ????? ?????? ??????????? ????????????????
        double l[5];
        for(int i=1; i<=4; i++){
          l[i]=sqrt(sqr(x[i-1]-x[i])+sqr(y[i-1]-y[i]));
 //printf("l[%d]=%f ", i, l[i]);
        };
 //printf("\n");
 
        //???????? ??? ???????, ???? ??? ?????? ?????????? ?? ?????, ?? ?????
        if( fabs(l[1]/(l[1]+l[3])-0.5)>0.1 ){ isPara=0; };
        if( fabs(l[2]/(l[2]+l[4])-0.5)>0.1 ){ isPara=0; };
        if( fabs(l[2]/(l[2]+l[3])-0.5)>0.2 ){ isPara=0; };
        if( l[1]+l[2]>800 ){ isPara=0; };
 
        //???????? ???? ?? ????? - ???? ?? ?????? ?????????? ?? ???????, ?? ?????
        double s_mul=(x[1]-x[0])*(x[2]-x[1])+(y[1]-y[0])*(y[2]-y[1]);
        double cos_a=s_mul/(l[1]*l[2]);
        if( cos_a > 0.3 ){ isPara=0; };
 
        //????????, ??? ? ???? ??????????? ??? ?? ???????? ?????-???? ????
        if( isPara ){
          double cx=(x[0]+x[1]+x[2]+x[3])/4;
          double cy=(y[0]+y[1]+y[2]+y[3])/4;
          CvQCodeBeacon *bc=fbeacon;
          while( bc ){
            double dist=sqrt(sqr(cx-bc->x)+sqr(cy-bc->y));
            if( dist<5 ){ isPara=0; }; //???? ???-?? ????? ????? ????, ?? ?????
            bc=bc->next;
          };
        };
 
        //???? ?????? ??? ????????? ????????
        if( isPara ){
  //printf("isPara\n");
          double idx1,idy1,idx2,idy2,idx3,idy3;
 
          char* datas=tmp->imageDataOrigin;
          long int steps=tmp->widthStep;
 
          double v1x=x[1]-x[2], v1y=y[1]-y[2];
          double v2x=x[3]-x[2], v2y=y[3]-y[2];
 
          int area=5;
          int L=8;
          int B=3;
          
          double wasmax=0;
          //?????? ?????????? ????? x[1],y[1] ??????? ????? ?????????
          //????? ? ???????????????? ????????????
          for(long int dx1=-area; dx1<=area; dx1++){
          for(long int dy1=-area; dy1<=area; dy1++){
            double a=angleF(datas,steps,szSrc,x[1]+dx1,y[1]+dy1,-v1x,-v1y,v2x,v2y,L,B);
            if(a>wasmax){
              idx1=dx1; idy1=dy1;
              wasmax=a;
            };
          };};
 
          wasmax=0;
          //?????? ?????????? ????? x[2],y[2] ??????? ????? ?????????
          //????? ? ???????????????? ????????????
          for(long int dx2=-area; dx2<=area; dx2++){
          for(long int dy2=-area; dy2<=area; dy2++){
            double a=angleF(datas,steps,szSrc,x[2]+dx2,y[2]+dy2,v1x,v1y,v2x,v2y,L,B);
            if(a>wasmax){
              idx2=dx2; idy2=dy2;
              wasmax=a;
            };
          };};
 
          wasmax=0;
          //?????? ?????????? ????? x[3],y[3] ??????? ????? ?????????
          //????? ? ???????????????? ????????????
          for(long int dx3=-area; dx3<=area; dx3++){
          for(long int dy3=-area; dy3<=area; dy3++){
            double a=angleF(datas,steps,szSrc,x[3]+dx3,y[3]+dy3,v1x,v1y,-v2x,-v2y,L,B);
            if(a>wasmax){
              idx3=dx3; idy3=dy3;
              wasmax=a;
            };
          };};
 
          double res[7][7];
          int K=7;
 
          double base_x=x[2]+idx2, base_y=y[2]+idy2;
          v1x=x[1]-x[2]+idx1-idx2, v1y=y[1]-y[2]+idy1-idy2;
          v2x=x[3]-x[2]+idx3-idx2, v2y=y[3]-y[2]+idy3-idy2;
          double vmax=0,vmin=255;
 
            //???????? ??????? ?????? ?????
            for(long int d1=0; d1<K; d1++){
            for(long int d2=0; d2<K; d2++){
              long int d_x=base_x+(0.5+d1)*v1x/K+(0.5+d2)*v2x/K;
              long int d_y=base_y+(0.5+d1)*v1y/K+(0.5+d2)*v2y/K;
              if( d_x<0 || d_x>szSrc.width || d_y<0 || d_y>szSrc.height ){
                res[d1][d2]=1000;
              }else{
                long int adr=d_x*3+(szSrc.height-d_y)*steps+2;
                res[d1][d2]=datas[adr];
              };
              if( res[d1][d2]>vmax ){ vmax=res[d1][d2]; };
              if( res[d1][d2]<vmin ){ vmin=res[d1][d2]; };
            };};
 
            for(int d1=0; d1<K; d1++){
              for(int d2=0; d2<K; d2++){
                res[d1][d2]= res[d1][d2]<(vmax+vmin)/2 ? 1 : 0;
		if (res[d1][d2] == 0) res[d1][d2] = 1;
			else res[d1][d2] = 0;
              };
            };
 
            int isGood=1;
 
            //???????? ?? ??, ??? ?? ????????? ???????????? ???????? ????? ???????? 7?7 ???? ?????? ??????, ????? ??????
            for(int i=0; i<K; i++){
              if( res[0][i]==0 ){ isGood=0; i=K; 
//printf("1\n");
};
              if( res[K-1][i]==0 ){ isGood=0; i=K; 
//printf("2\n");
};
              if( res[i][0]==0 ){ isGood=0; i=K; 
//printf("3\n");
};
              if( res[i][K-1]==0 ){ isGood=0; i=K; 
//printf("4\n");
};
            };
 
            //????????, ??? ?? ?????????? ???????? 5?5 ????? ? ????? ????? 1 ?????? ????????? (?????? ????????)
            if( res[1][1]+res[5][1]+res[5][5]+res[1][5] != 1 ){ isGood=0; 
//printf("5\n");
};
   //printf("check1\n");
            //???? ????????? ??? ???????? ??????, ?? ???????? ??????.
            if( isGood==1 ){
   //printf("good1\n");
              //????????? ?????? ??? ??????? ??????? ?????
              double tmp[7][7];
              for(int d1=0; d1<K; d1++){
              for(int d2=0; d2<K; d2++){
                int dd1=res[1][1]+res[1][5]==1 ? d1 : K-1-d1;
                int dd2=res[1][1]+res[5][1]==1 ? d2 : K-1-d2;
                tmp[d1][d2]=res[dd1][dd2];
              };};
 
              for(int d1=0; d1<K; d1++){
              for(int d2=0; d2<K; d2++){
                int dd1=tmp[1][2]==1 ? d1 : d2;
                int dd2=tmp[1][2]==1 ? d2 : d1;
                res[d1][d2]=tmp[dd1][dd2];
              };};
 
              int code[20]; for(int i=0; i<20; i++){ code[i]=0; };
 
              long int beacon=0;
   //printf("check2\n");
              //?????????? ????? ????? ? ???????? ??? ??????????? ?????
              if( isGood==1 ){
  //printf("good2\n");
                int checkbits=0;
                for(int i=2; i<=4; i++){ code[i-1]=res[5][i]; };
                for(int i=1; i<=5; i++){ code[i+3]=res[4][i]; code[i+8]=res[3][i]; };
                for(int i=2; i<=5; i++){ code[i+12]=res[2][i]; };
                for(int i=3; i<=4; i++){ code[i+15]=res[1][i]; };
                for(int j=0; j<5; j++){
                  int bits=0;
                  for(int i=0; i<4; i++){ bits = (bits << 1) + code[j*4+i]; };
                  checkbits = checkbits ^ bits;
                  if( j<4 ){ beacon = (beacon << 4) + bits; };
                };
		//printf("beacon=%d\n", beacon);
                if( checkbits != 13 ){ isGood=0; printf("checkbits=%d\n", checkbits);};
              };
   //printf("check3\n");
              //???? ??????????? ????? ??????, ????? ?????????????? ????? ???????????? ????
              if( isGood==1 ){
  //printf("good3\n");
                CvQCodeBeacon* cur=fbeacon;
                while( cur && cur->next && cur->id != beacon ){ cur=cur->next; };
                if( !cur ){
                  cur=new CvQCodeBeacon();
                  fbeacon=cur;
                  cur->next=NULL;
                }else if( cur->id != beacon ){
                  cur->next=new CvQCodeBeacon();
                  cur=cur->next;
                  cur->next=NULL;
                };
                cur->id=beacon;
                cur->x=base_x+(v1x+v2x)/2;
                cur->y=base_y+(v1y+v2y)/2;
                cur->bx=base_x;
                cur->by=base_y;
                cur->x1=v1x;
                cur->y1=v1y;
                cur->x2=v2x;
                cur->y2=v2y;
                double size=sqrt(sqr(v1x+v2x)+sqr(v1y+v2y));
 
                //?????????? ?????????? ????? ???????????? ??????
                cur->rx=k_front*szDiv2.width/size;
                cur->ry=((cur->x) - szDiv2.width)*(cur->rx)/(szDiv2.width*k_side);
                cur->rz=((cur->y) - szDiv2.height)*(cur->rx)/(szDiv2.width*k_side);
 
                cur->d=sqrt(sqr(cur->rx)+sqr(cur->ry)+sqr(cur->rz));
                cur->d=floor(cur->d*100)/100;
  
  double x__=base_x+(v1x+v2x)/2;
  double y__=base_y+(v1y+v2y)/2;
  double rx__=k_front*szDiv2.width/size;
  double ry__=((x__) - szDiv2.width)*(rx__)/(szDiv2.width*k_side);
  double rz__=((y__) - szDiv2.height)*(rx__)/(szDiv2.width*k_side);
  double d__=sqrt(sqr(rx__)+sqr(ry__)+sqr(rz__));
  d__=floor(d__*100)/100;
  
  //printf("v1x=%6.2f\n", v1x);
  //printf("v1y=%6.2f\n", v1y);
  //printf("v2x=%6.2f\n", v2x);
  //printf("v2y=%6.2f\n", v2y);
  //printf("size=%6.2f\n", size);
  printf("x=%6.2f\n", x__);
  printf("y=%6.2f\n", y__);
  printf("bx=%6.2f\n", base_x);
  printf("by=%6.2f\n", base_y);
  printf("rx=%6.2f\n", rx__);
  printf("ry=%6.2f\n", ry__);
  printf("rz=%6.2f\n", rz__);
  printf("d=%6.2f\n", d__);
		printf("beacon=%d\n", cur->id);
            /*for(int d1=K-1; d1>=0; d1--){
              for(int d2=0; d2<K; d2++)
		{
			printf("%d ", (int)res[d1][d2]);
		}
		printf("\n");
		}*/
              };
            };
 
        };
      };
      contours = contours->h_next;
    };
  };
 
  cvReleaseMemStorage( &storage );
 
  cvReleaseImage(&pyr);
  cvReleaseImage(&tmp);
  cvReleaseImage(&gray);
  cvReleaseImage(&tgray);
 
  return fbeacon;
 };

