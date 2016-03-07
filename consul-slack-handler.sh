#!/bin/bash

SLACK_URL="$1"

[ $# -ge 2 -a -f "$2" ] && input="$2" || input="-"

json="$(cat $input)"
echo "$json" | jq -r 'keys[]' |while read key
do
    color=good
    case $(echo "$json"|jq "\(.[$key].Status)") in
        critical)
            color="danger"
            image="https://res.cloudinary.com/byrnedo/image/upload/v1457345752/doom_fvhzga.png"
            ;;
        warning)
            color="warning"
            image="https://res.cloudinary.com/byrnedo/image/upload/v1457347277/hurt_ptjr10.png"
            ;;
        passing)
            color="good"
            image="https://res.cloudinary.com/byrnedo/image/upload/v1457347239/godmode_ofwzk7.jpg"
            ;;
    esac

    attachment=$(echo "$json" | jq "{\"fallback\":\"\(.[$key].Node)/\(.[$key].CheckID) \(.[$key].Status)!\",\"title\":\"\(.[$key].Node)/\(.[$key].CheckID) \(.[$key].Status)\",\"pretext\":\"Consul check is \(.[$key].Status)\",\"color\":\"$color\",\"thumb_url\":\"$image\",\"fields\":[{\"title\":\"Description\",\"value\":\"\(.[$key].Name)\",\"short\":true},{\"title\":\"Priority\",\"value\":\"\(.[$key].Status)\",\"short\":true}]}")

    curl -X POST -H 'Content-type: application/json' --data-binary @- $SLACK_URL << EOFF
    {
        "attachments": [
        $attachment
        ]
    }
EOFF

done
