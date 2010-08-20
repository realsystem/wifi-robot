#pragma hdrstop
#include "qcode_lib.h"
#include "qcode_std.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

IplImage* frame;

int main(int argc, char* argv[])
{
        char* filename;

	if (!argc) return 0;
	else filename = argv[1];
        printf("file: %s\n", filename);

        // window to show the result
        cvNamedWindow("original",CV_WINDOW_AUTOSIZE);

        // get info about the video file
        CvCapture* capture = cvCreateFileCapture(filename);

        while(1){
                // get the next frame
                frame = cvQueryFrame( capture );
		printf("q %i", frame);
		if( !frame ) {
                        break;
                }

                // processing...
		mycvGetQCodeBeacons(frame, 5, 0.438, 2.813);
                // show the frame
                cvShowImage( "original", frame );

                char c = cvWaitKey(33);
                if (c == 27) { // press ESC for exit
                        break;
                }
        }

        // release resources
        cvReleaseCapture( &capture );
        // delete window
        cvDestroyWindow("original");
        return 0;
}