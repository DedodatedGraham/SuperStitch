#include "Spinnaker\include\Spinnaker.h"
#include "Spinnaker\include\SpinGenApi\SpinnakerGenApi.h"
#include <iostream>
#include <sstream>
//#include <ctime>
#include <chrono>
#include <stdlib.h>
#include <time.h>
//#include <unistd.h>
#include <thread>
using namespace Spinnaker;
using namespace Spinnaker::GenApi;
using namespace Spinnaker::GenICam;
using namespace std;

#define BILLION 1000000000.0
#define PHOTO_PER_SLIDE 8500


int AcquireImages(CameraPtr pCam, INodeMap& nodeMap, INodeMap& nodeMapTLDevice,int numphoto)
{
    int result = 0;
    double difference;
    //struct timespec start,end;
    //clock_gettime(CLOCK_MONOTONIC, &start);
    auto start = chrono::high_resolution_clock::now();
    
    ios_base::sync_with_stdio(false);
    
    cout << endl << endl << "*** IMAGE ACQUISITION ***" << endl << endl;

    try
    {
        // Set acquisition mode to continuous
        // Retrieve enumeration node from nodemap
        CEnumerationPtr ptrAcquisitionMode = nodeMap.GetNode("AcquisitionMode");
        if (!IsReadable(ptrAcquisitionMode) ||
            !IsWritable(ptrAcquisitionMode))
        {
            cout << "Unable to set acquisition mode to continuous (enum retrieval). Aborting..." << endl << endl;
            return -1;
        }

        // Retrieve entry node from enumeration node
        CEnumEntryPtr ptrAcquisitionModeContinuous = ptrAcquisitionMode->GetEntryByName("Continuous");
        if (!IsReadable(ptrAcquisitionModeContinuous))
        {
            cout << "Unable to get or set acquisition mode to continuous (entry retrieval). Aborting..." << endl << endl;
            return -1;
        }

        // Retrieve integer value from entry node
        const int64_t acquisitionModeContinuous = ptrAcquisitionModeContinuous->GetValue();
        
        // Set integer value from entry node as new value of enumeration node
        ptrAcquisitionMode->SetIntValue(acquisitionModeContinuous);

        cout << "Acquisition mode set to continuous..." << endl;

        
        // Begin acquiring images
        pCam->BeginAcquisition();

        cout << "Acquiring images..." << endl;


        // Create ImageProcessor instance for post processing images
        ImageProcessor processor;

        // Set default image processor color processing method 
        processor.SetColorProcessing(SPINNAKER_COLOR_PROCESSING_ALGORITHM_HQ_LINEAR);
        //auto start = std::chrono::high_resolution_clock::now();

        for (int imageCnt = 0; imageCnt < 20*numphoto; imageCnt++)
        {
            if(imageCnt % 2 == 0){
                try
                {
                    // Retrieve next received image
                    ImagePtr pResultImage = pCam->GetNextImage(1000);
                    //auto elapsed = std::chrono::high_resolution_clock::now() - start;
                    // Ensure image completion
                    if (pResultImage->IsIncomplete())
                    {
                        // Retrieve and print the image status description
                        cout << "Image incomplete: " << Image::GetImageStatusDescription(pResultImage->GetImageStatus())
                            << "..." << endl
                            << endl;
                    }
                    else
                    {
                        // Print image information; height and width recorded in pixels

                        const size_t width = pResultImage->GetWidth();

                        const size_t height = pResultImage->GetHeight();

                        cout << "Grabbed image " << imageCnt << ", width = " << width << ", height = " << height << endl;

                        ImagePtr convertedImage = processor.Convert(pResultImage, PixelFormat_Mono8);

                        //make file 
                        ostringstream filename;
                        //long long microseconds = std::chrono::duration_cast<std::chrono::seconds>(elapsed).count();

                        //clock_gettime(CLOCK_MONOTONIC, &end);
                        auto end = chrono::high_resolution_clock::now();
			
			//difference = double(end.tv_sec - start.tv_sec) + (double(end.tv_nsec - start.tv_nsec) / BILLION);
			difference = chrono::duration_cast<chrono::nanoseconds>(end - start).count();
			
                        difference = difference / BILLION;

			filename << "SuperStitch-";
                        filename << difference << ".jpg";

                        // Save image
                        convertedImage->Save(filename.str().c_str());

                        cout << "Image saved at " << filename.str() << endl;
                    }

                    pResultImage->Release();
                    cout << endl;
                }
                catch (Spinnaker::Exception& e)
                {
                    cout << "Error: " << e.what() << endl;
                    result = -1;
                }
            }
            else{
                std::this_thread::sleep_for(std::chrono::milliseconds(70));
            }
        }

        pCam->EndAcquisition();
    }
    catch (Spinnaker::Exception& e)
    {
        cout << "Error: " << e.what() << endl;
        return -1;
    }

    return result;

}

int RunSingleCamera(CameraPtr pCam,int numphoto)
{
    int result = 0;
    try
    {
        // Retrieve TL device nodemap and print device information
        INodeMap& nodeMapTLDevice = pCam->GetTLDeviceNodeMap();

        // Initialize camera
        pCam->Init();
        

        // Retrieve GenICam nodemap
        INodeMap& nodeMap = pCam->GetNodeMap();
        //set Exposure 
        CEnumerationPtr ptrExposureAuto = nodeMap.GetNode("ExposureAuto");
        if (IsReadable(ptrExposureAuto) && IsWritable(ptrExposureAuto)){
            CEnumEntryPtr ptrExposureAutoOn = ptrExposureAuto->GetEntryByName("Off");
            if (IsReadable(ptrExposureAutoOn)){
                ptrExposureAuto->SetIntValue(ptrExposureAutoOn->GetValue());
                cout << "Automatic exposure enabled..." << ptrExposureAutoOn->GetValue() << endl;
            }
        }
        else 
        {
            CEnumerationPtr ptrAutoBright = nodeMap.GetNode("autoBrightnessMode");
            if (!IsReadable(ptrAutoBright) ||
                !IsWritable(ptrAutoBright))
            {
                cout << "Unable to get or set exposure time. Aborting..." << endl << endl;
                return -1;
            }
            cout << "Unable to disable automatic exposure. Expected for some models... " << endl;
            cout << "Proceeding..." << endl;
            result = 1;
        }
        
        CFloatPtr ptrExposureTime = nodeMap.GetNode("ExposureTime");
        const double exposureTimeMax = ptrExposureTime->GetMax();
        double exposureTimeToSet = 1000.0;

        if (exposureTimeToSet > exposureTimeMax)
        {
            exposureTimeToSet = exposureTimeMax;
        }

        ptrExposureTime->SetValue(exposureTimeToSet);
        //CEnumerationPtr ptrExposureAuto=nodeMap.GetNode("ExposureAuto");
        //CEnumEntryPtr ptrExposureAutoCts=ptrExposureAuto->GetEntryByName("Continuous");
        //ptrExposureAuto->SetIntValue(ptrExposureAutoCts->GetValue());
        CEnumerationPtr ptrGainAuto=nodeMap.GetNode("GainAuto");
        CEnumEntryPtr ptrGainAutoCts=ptrGainAuto->GetEntryByName("Continuous");
        ptrGainAuto->SetIntValue(ptrGainAutoCts->GetValue());
        //Set Metering Mode
        CEnumerationPtr ptrMeteringMode=nodeMap.GetNode("AutoExposureMeteringMode");
        CEnumEntryPtr ptrMeteringModePartial=ptrMeteringMode->GetEntryByName("Partial");
        ptrMeteringMode->SetIntValue(ptrMeteringModePartial->GetValue());
        //
        //Goin/ExposureTime
        //CEnumerationPtr exposurePriorityNode = nodeMap.GetNode("ExposurePriority");
        //exposurePriorityNode->SetIntValue(1);
        //CEnumerationPtr gainPriorityNode = nodeMap.GetNode("GainPriority");
        //gainPriorityNode->SetIntValue(1);
        //// Acquire images
        result = result | AcquireImages(pCam, nodeMap, nodeMapTLDevice,numphoto);

        // Deinitialize camera
        pCam->DeInit();
    }
    catch (Spinnaker::Exception& e)
    {
        cout << "Error: " << e.what() << endl;
        result = -1;
    }

    return result;
}

int main(int argc, char *argv[]){
    //ensure file permissions
    FILE* tempFile = fopen("test.txt", "w+");
    if (tempFile == nullptr){
        cout << "File Failed to open :(" << endl;
	return -1;
    }
    fclose(tempFile);
    remove("test.txt");

    int numphoto = PHOTO_PER_SLIDE;
    if(strcmp(argv[1], "2")) {
        numphoto = numphoto * 2;
    }
    
    //Recieve communication
    SystemPtr system = System::GetInstance();
    CameraList camList = system->GetCameras();
    const unsigned int numCameras = camList.GetSize();
    cout << "Number of cameras detected: " << numCameras << endl << endl;
    
    int result = 0;
    if(numCameras > 0){
        CameraPtr pCam = nullptr;
        pCam = camList.GetByIndex(0);
        result = result | RunSingleCamera(pCam,numphoto);
    }
    else{
        return -1;
    }
    return result;
}
 

