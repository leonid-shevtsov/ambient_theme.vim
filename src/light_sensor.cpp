// Read the MacBook's ambient light sensor and print out the results
#import <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>

struct lmu_data {
  long int left;
  long int right;
};

int getLmuData(lmu_data &result) {
	kern_return_t kr;
	io_service_t serviceObject;
	io_connect_t dataPort = 0;
	
	serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleLMUController"));
	if (serviceObject) {
		kr= IOServiceOpen(serviceObject, mach_task_self(), 0, &dataPort);
		IOObjectRelease(serviceObject);
		if(kr==KERN_SUCCESS) {

			uint32_t outputCnt= 2;
			uint64_t scalarI_64[2];
			scalarI_64[0]= 0;
			scalarI_64[1]= 0;
			uint32_t left, right;

#if defined(__LP64__)		//check if 10.5 api available
      kr= IOConnectCallScalarMethod(dataPort, 0, NULL, 0, scalarI_64, &outputCnt);
      if(kr==KERN_SUCCESS) {
        result.left = scalarI_64[0];
        result.right = scalarI_64[1];
        return 1;
      }					
#else						//use 10.4 api
      kr= IOConnectMethodScalarIScalarO(dataPort, 0, 0, 2, &left, &right);
      if(kr==KERN_SUCCESS) {
        result.left = left;
        result.right = right;
        return 1;
      }
#endif
		}
	}
  return 0;
}

int main() {
  lmu_data data;
  if (getLmuData(data) > 0) {
    printf("%lu %lu\n", data.left, data.right);
    return 0;
  } else {
    return -1;
  }
}
