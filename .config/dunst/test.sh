#!/bin/bash

# Function to send a notification
send_notification() {
    local summary="$1"
    local body="$2"
    local urgency="$3"
    local timeout="$4"

    notify-send --urgency="$urgency" --expire-time="$timeout" "$summary" "$body"
}

# Function to send a notification with actions
send_notification_with_actions() {
    dbus-send \
      --session \
      --dest=org.freedesktop.Notifications \
      --type=method_call \
      --print-reply \
      /org/freedesktop/Notifications org.freedesktop.Notifications.Notify \
      string:"swaync-test" \
      uint32:0 \
      string:"dialog-information" \
      string:"Action Test" \
      string:"Click a button to test actions." \
      array:string:"action1","Button 1","action2","Button 2" \
      dict:string:variant: \
      int32:0
}

# Notification test functions
basic_test() {
    send_notification "Test Notification" "This is a basic test notification." "normal" 3000
}

urgency_test() {
    send_notification "Low Urgency Test" "This is a low urgency notification." "low" 3000
    send_notification "Normal Urgency Test" "This is a normal urgency notification." "normal" 3000
    send_notification "Critical Urgency Test" "This is a critical urgency notification." "critical" 3000
}

persistent_test() {
    send_notification "Persistent Notification" "This will not expire until dismissed." "normal" 0
}

long_text_test() {
    send_notification "Long Text Test" "This notification contains a long body of text to check how it wraps and displays." "normal" 3000
}

empty_body_test() {
    send_notification "No Body Test" "" "normal" 3000
}

special_characters_test() {
    send_notification "Special Characters Test" "This notification contains special characters: ~!@#$%^&*()_+{}|:\"<>?[];'.,\`" "normal" 3000
}

emoji_test() {
    send_notification "Emoji Test" "This notification contains emojis: 🚀🎉🔥💡" "normal" 3000
}

rapid_notifications_test() {
    for i in {1..5}; do
        send_notification "Rapid Test $i" "This is notification number $i." "normal" 1000
        sleep 0.5
    done
}

action_test() {
    send_notification_with_actions
}

inline_reply_test() {
    notify-send "Inline-Reply Test" \
               "Type a reply below and hit Enter." \
               -A inline-reply="Reply"
}

progress_test() {
    local id progress
    id=$(notify-send -u low -p \
          -h string:synchronous:progress_demo \
          -h int:value:0 \
          "Progress Demo" "0 %")
    for progress in {10..100..10}; do
        notify-send -u low -r "$id" \
          -h string:synchronous:progress_demo \
          -h int:value:$progress \
          "Progress Demo" "$progress %"
        sleep 0.4
    done
}

# Run all tests automatically
echo "Starting all notification tests..."
basic_test
urgency_test
persistent_test
long_text_test
empty_body_test
special_characters_test
emoji_test
rapid_notifications_test
action_test
inline_reply_test
progress_test
echo "All tests completed."
