# Consul Slack Notifier

Handler for consul which sends health check messages to a slack channel.

Requires the following checks config:

    {
        "type": "checks",
        "handler": "/opt/consul-slack-notifier.sh"
    }

