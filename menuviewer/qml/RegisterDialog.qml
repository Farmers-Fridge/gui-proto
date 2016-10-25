import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0

UserDialogTemplate {
    id: signDialog

    ListModel {
        id: listModel
        ListElement {
            inputTitle: "First Name:"
            inputPlaceHolder: "Enter First Name"
        }
        ListElement {
            inputTitle: "Last Name:"
            inputPlaceHolder: "Enter Last Name"
        }
        ListElement {
            inputTitle: "Email Address:"
            inputPlaceHolder: "Enter Email Address"
        }

        ListElement {
            inputTitle: "Phone Numer:"
            inputPlaceHolder: "Enter Phone Number"
        }
    }

    model: listModel
}
