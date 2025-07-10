from notifications import SlackNotifier  

def test_send_slack_message():
    notifier = SlackNotifier()
    result = notifier.send_message("Test Message")
    assert result == True  
