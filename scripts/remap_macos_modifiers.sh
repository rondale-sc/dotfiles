#!/bin/bash

# Define the JSON for remapping Caps Lock to Escape
hidutil_config='{
  "UserKeyMapping":[
    {
      "HIDKeyboardModifierMappingSrc": 0x700000039,
      "HIDKeyboardModifierMappingDst": 0x7000000e0
    }
  ]
}'

# Apply the remapping to all connected keyboards
hidutil property --set "$hidutil_config"
