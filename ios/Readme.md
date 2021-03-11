
# IOS APP

## xcconfig file

1. For target1 create .xcconfig file ex- NoonSecureDebug.xcconfig under Runner->Flutter
    
    Write following lines inside created .xcconfig file
    ex- #include "Pods/Target Support Files/Pods-Noon Secure/Pods-Noon Secure.debug.xcconfig"
    
    Also include following
    #include "Generated.xcconfig"
    
2. Define debug config file path of specif target:
    Navigate to Project (blue one) (Not targets)
    Navigate to Info -> Configuration
    Set config file for Target1
    
Note-
1. .xcconfig you created will be different for debug, release and profile mode
2. Repeat above steps for all the targets.

3. In Info -> Configuration Tab
For Runner select the current build .xcconfig file or select none option.
    
    
##ERROR
1. If got error while building application
Close the project run following command from terminal from root of project
flutter pub get

After this run following command from  ios folder of project
pod install

You may also delete poldock file before above command.

2. Check pod file added in target's Build phase->Embedded Binary 
3. Check FLUTTER_ROOT in build settings
