# iCubeTest-iOS

# Problem

Create a form with the following fields/inputs

- Name (mandatory)
- Email with validation (mandatory, must be valid email format)
- Button to go to details to another screen to pickup items either from markers on a map or list (shown below map). 

May be 5 items maximum to show on both map and list. You can hardcode location to a fixed address. Markers and list must show same information. For this test scenario, assume the markers are the address of attractions such as theme park, museums, temples etc. 

Each attraction has entry ticket price. Tapping on the marker should show the ticket price and a button to select that attraction or deselect the location. Selected items in the list and map should show highlight colour different from unselected items.

Multiple items can be selected. For the list view, show the attraction name and price. Tapping on the row means selecting the item and another tap would deselect the item. Click done button to go back to Form screen, show the total amount of selected items.
- Items source is from JSON Rest API, you can hard code it and place it on any site that you can pick up
- Click on submit button just to do validation of name and email field and show error, no need to do any form submission.

# Step To install

1. Clone repository
2. Pod install
3. Open iCubeTest.xcworkspace
4. Try the app ^_^

# Library and tools

1. Cocoapod
   a. Promise Kit 
   b. Moya
   c. NVActivityIndicatorView
2. API Server -> https://my-json-server.typicode.com
3. Xcode 10.2.1
4. iOS 12.2
5. Swift 5
