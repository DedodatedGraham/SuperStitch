#include "Spinnaker.h"
#include "SpinGenApi/SpinnakerGenApi.h"
#include <iostream>
#include <sstream>
#include <ctime>
#include <chrono>

using namespace Spinnaker;
using namespace Spinnaker::GenApi;
using namespace Spinnaker::GenICam;
using namespace std;

int AcquireImages(CameraPtr pCam, INodeMap& nodeMap, INodeMap& nodeMapTLDevice,int numphoto)
{
    int result = 0;

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
        auto start = std::chrono::high_resolution_clock::now();

        for (unsigned int imageCnt = 0; imageCnt < numphoto; imageCnt++)
        {
            try
            {
                // Retrieve next received image
                ImagePtr pResultImage = pCam->GetNextImage(1000);
                auto elapsed = std::chrono::high_resolution_clock::now() - start;
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
                    long long microseconds = std::chrono::duration_cast<std::chrono::seconds>(elapsed).count();

                    filename << "SuperStitch-" << microseconds;
                    filename << imageCnt << ".jpg";

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

        // Acquire images
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
        return -1;
    }
    fclose(tempFile);
    remove("test.txt");

    //loadargs
    int numphoto;
    if(argc>0){
        numphoto = atoi(argv[1]); 
    }
    else{
        return -1;
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
 

