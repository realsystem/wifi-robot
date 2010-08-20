#pragma hdrstop
#include "qcode_lib.h"
#include "qcode_std.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

IplImage* frame;

int main(int argc, char* argv[])
{

	CvCapture* capture = cvCreateCameraCapture(CV_CAP_ANY);
	assert( capture );
	//cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH, 640);//1280); 
        //cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT, 480);//960); 
        // узнаем ширину и высоту кадра
        double width = cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH);
        double height = cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT);
        printf("[i] %.0f x %.0f\n", width, height );
        // window to show the result
        cvNamedWindow("original",CV_WINDOW_AUTOSIZE);

        while(1){
                // get the next frame
                frame = cvQueryFrame( capture );
		printf("q %i", frame);
		if( !frame ) {
                        break;
                }

                // processing...
		mycvGetQCodeBeacons(frame, 5, 0.3, 2.0);
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
