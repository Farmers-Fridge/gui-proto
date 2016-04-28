import QtQuick 2.5
import ".."

Command {
    id: addToCartCommand

    // Current item:
    property variant currentItem: undefined

    // Execute:
    function execute()
    {
        // Log:
        mainWindow.logMessage("RUNNING AddToCartCommand WITH: " +
            currentItem["vendItemName"] + "/" + currentItem["icon"] + "/" +
                currentItem["nutrition"] + "/" + currentItem["category"] + "/" +
                    currentItem["price"])
        if (currentItem)
        {
            var vendItemName = currentItem["vendItemName"]
            var icon = currentItem["icon"]
            var nutrition = currentItem["nutrition"]
            var category = currentItem["category"]
            var price = currentItem["price"]

            // Add item:
            _controller.addItem(vendItemName, icon, nutrition, category, price)
        }
    }
}

