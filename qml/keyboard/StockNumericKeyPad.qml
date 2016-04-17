import QtQuick 2.5

NumericKeyPad {
    id: stockNumericKeyPad

    // Current key:
    property int currentKey: -1

    // Theo par:
    property int theoPar: 0

    // Return key enabled state:
    function keyEnabledState(keyId)
    {
        return ((keyId < 10) && (keyId > theoPar)) ? false : true
    }
}

