import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0

UserDialogTemplate {
    id: signDialog

    ListModel {
        id: listModel
        ListElement {
            inputTitle: "Login:"
            inputPlaceHolder: "Enter Login"
        }
        ListElement {
            inputTitle: "Password:"
            inputPlaceHolder: "Enter Password"
        }
    }

    model: listModel
}
