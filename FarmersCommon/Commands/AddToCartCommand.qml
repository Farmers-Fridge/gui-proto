import QtQuick 2.5
import ".."

Command {
    id: addToCartCommand

    // Current item:
    property variant currentItem: undefined

    // Add item:
    signal addItem(string vendItemName, string icon, string nutrition, string category, string price)

    // Execute:
    function execute()
    {
        // Log:
        console.log("RUNNING AddToCartCommand WITH: " +
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
            addItem(vendItemName, icon, nutrition, category, price)
        }
    }
}

