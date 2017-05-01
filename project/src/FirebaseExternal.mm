#include <hx/CFFI.h>

extern "C" {

    void extension_firebase_main() {
        printf("GetSocial: extension_getsocial_main");
        val_int(0);
    }
    DEFINE_ENTRY_POINT(extension_firebase_main);

    int extension_firebase_register_prims(){
        printf("Firebase: extension_firebase_main");
        return 0;
    }
}