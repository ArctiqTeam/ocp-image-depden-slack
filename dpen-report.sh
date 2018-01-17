#!/bin/bash

echo "Querying Openshift and loading message"

#start of for loop based on output of istag on openshift
for x in $(oc get istag | awk '{if (NR!=1) {print $1}}')
	do 
		echo -n "."
		#load the ocout variable with the output of the build-chain command
		ocout=$ocout"\\\n"$(oc adm build-chain $x -n openshift --all)
done
echo -e "\nScript is done loading, sending output to slack"

#strip the quotes from the output and replace with * so we get bold text output with mrkdwn
text=$(echo $ocout | sed 's/\"/*/g')

#use read to load the jsonout variable
read -d '' jsonout << EOF
{
        "username": "Image Dependencies Report",
        "icon_emoji": ":fax:",
        "mrkdwn": true,
        "text": "$text"
}
EOF

#send the output to slack
curl -s -d "payload=$jsonout" https://hooks.slack.com/services/$slackwebhook

#Slack curl examples:
#curl -X POST -H 'Content-type: application/json' --data '{"text":"This is a line of text.\nAnd this is another one."}' https://hooks.slack.com/services/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
#curl -X POST --data-urlencode "payload={\"text\": \"This is posted to #general and comes from a bot named webhookbot.\"}" https://hooks.slack.com/services/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